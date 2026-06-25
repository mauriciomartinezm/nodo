import { prisma } from "../database/prisma.js";
import { saveNotification } from "../services/notificationService.js";

export const finishJob = async (req, res) => {
  const { postId, applicationId } = req.body;

  if (!postId && !applicationId) {
    return res.status(400).json({ message: "At least one ID is required to finish." });
  }

  try {
    // The client confirms the job is done: closes the service and the post.
    if (postId) {
      const application = await prisma.application.findFirst({
        where: { postId, status: "accepted" },
        include: { service: true },
      });

      if (!application?.service) {
        return res.status(404).json({ message: "No active service found for this post." });
      }

      await prisma.$transaction([
        prisma.service.update({
          where: { id: application.service.id },
          data: { status: "completed", endDate: new Date() },
        }),
        prisma.post.update({
          where: { id: postId },
          data: { status: "finished" },
        }),
      ]);

      await saveNotification(
        application.workerId,
        "job_completed",
        "Job finished",
        "Your job has been successfully finished. Don't forget to leave a review!",
        {}
      );

      return res.status(200).json({ message: "Post and service finished." });
    }

    // The worker marks the job as done: the client is asked to confirm.
    if (applicationId) {
      const application = await prisma.application.findUnique({
        where: { id: applicationId },
        include: { post: true },
      });

      if (!application) {
        return res.status(404).json({ message: "Application not found." });
      }

      await saveNotification(
        application.post.clientId,
        "completion_confirmation",
        "Completion confirmation required",
        `The worker has marked the job "${application.post.title}" as done. Please review the results, go to the post, and confirm if you agree to finish the process.`,
        {}
      );

      return res.status(200).json({ message: "Completion notification sent to the client." });
    }
  } catch (e) {
    console.error("Error in finishJob:", e);
    return res.status(500).json({ message: "Error finishing the job." });
  }
};
