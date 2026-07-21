import { prisma } from "../database/prisma.js";
import { saveNotification } from "../services/notificationService.js";

// Business rule (not expressible as a constraint): a worker can re-apply to
// the same post if their last application was 'withdrawn', but NOT if it
// was 'rejected'.
export const apply = async (req, res) => {
  const { postId, workerId } = req.body;

  try {
    const post = await prisma.post.findUnique({ where: { id: postId } });
    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const lastApplication = await prisma.application.findFirst({
      where: { postId, workerId },
      orderBy: { applicationDate: "desc" },
    });

    if (lastApplication?.status === "rejected") {
      return res.status(409).json({
        message: "You were already rejected for this post and cannot re-apply.",
      });
    }

    const client = await prisma.appUser.findUnique({ where: { id: post.clientId } });

    const application = await prisma.application.create({
      data: { postId, workerId, status: "pending" },
    });

    if (!client?.fcmToken) {
      return res.status(200).json({
        message: "Application created successfully but the client has no FCM token",
        application,
      });
    }

    await saveNotification(
      post.clientId,
      "request",
      "New application",
      "A worker has applied to your post",
      { postId: postId.toString(), workerId: workerId.toString() }
    );

    res.status(200).json({ message: "Application created and notification sent successfully", application });
  } catch (error) {
    console.error("Error applying:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const getApplications = async (req, res) => {
  try {
    const applications = await prisma.application.findMany();
    res.json(applications);
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

export const getApplication = async (req, res) => {
  try {
    const application = await prisma.application.findUnique({ where: { id: req.params.id } });
    if (!application) {
      return res.status(404).json({ message: "No records found" });
    }
    res.json(application);
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: error.message });
    }
  }
};

export const getApplicationsByUserId = async (req, res) => {
  try {
    const applications = await prisma.application.findMany({
      where: { workerId: req.params.id },
    });

    if (applications.length === 0) {
      return res.status(204).json({ message: "No records found" });
    }

    res.status(200).json(applications);
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: error.message });
    }
  }
};

export const getApplicationsByPostId = async (req, res) => {
  try {
    const applications = await prisma.application.findMany({
      where: { postId: req.params.id },
      include: {
        worker: {
          include: {
            user: true,
            workerCategories: { include: { generalCategory: true } },
          },
        },
      },
    });

    if (applications.length === 0) {
      return res.status(204).json({ message: "No records found" });
    }

    const sanitized = applications.map((application) => {
      const { passwordHash, fcmToken, ...user } = application.worker.user;
      return {
        ...application,
        worker: { ...application.worker, user },
      };
    });

    res.status(200).json(sanitized);
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: error.message });
    }
  }
};

export const updateApplication = async (req, res) => {
  const applicationId = req.params.id;
  const { status } = req.body;

  try {
    const application = await prisma.application.findUnique({ where: { id: applicationId } });
    if (!application) {
      return res.status(404).json({ message: "Application not found" });
    }

    if (status === "accepted") {
      await prisma.$transaction([
        prisma.application.updateMany({
          where: { postId: application.postId, id: { not: applicationId } },
          data: { status: "rejected" },
        }),
        prisma.application.update({
          where: { id: applicationId },
          data: { status: "accepted" },
        }),
        prisma.post.update({
          where: { id: application.postId },
          data: { status: "in_progress" },
        }),
        prisma.service.create({
          data: { applicationId, status: "in_progress" },
        }),
      ]);

      const post = await prisma.post.findUnique({ where: { id: application.postId } });
      await saveNotification(
        post.clientId,
        "application_accepted",
        "A worker has accepted your offer",
        "The worker has accepted the job. You can start the conversation to coordinate details",
        {}
      );

      return res.json({ message: "Application updated successfully" });
    }

    await prisma.application.update({
      where: { id: applicationId },
      data: { status },
    });

    res.json({ message: "Application updated successfully" });
  } catch (error) {
    console.error("Error updating application:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export const deleteApplication = async (req, res) => {
  try {
    await prisma.application.delete({ where: { id: req.params.id } });
    res.json({ message: "Record deleted successfully" });
  } catch (error) {
    if (error.code === "P2025") {
      return res.status(404).json({ message: "Record not found" });
    }
    if (error.code === "P2003") {
      return res.status(409).json({
        message: "Cannot delete: this application has an associated service or other related records.",
      });
    }
    console.error(error);
    res.status(500).json({ message: error.message });
  }
};
