import { prisma } from "../database/prisma.js";
import { saveNotification } from "../services/notificationService.js";

export const finishJob = async (req, res) => {
  const { postId, applicationId } = req.body;

  if (!postId && !applicationId) {
    return res.status(400).json({ message: "At least one ID is required to finish." });
  }

  try {
    // Worker marks their part as done
    if (applicationId) {
      const application = await prisma.application.findUnique({
        where: { id: applicationId },
        include: { post: true, service: true },
      });

      if (!application) {
        return res.status(404).json({ message: "Application not found." });
      }
      if (!application.service) {
        return res.status(404).json({ message: "No active service found for this application." });
      }
      if (application.service.status !== "in_progress") {
        return res.status(409).json({ message: "Service is already finished or cancelled." });
      }

      const updatedService = await prisma.service.update({
        where: { id: application.service.id },
        data: { workerCompletionRequest: true },
      });

      // Both confirmed — complete everything
      if (updatedService.clientCompletionRequest) {
        await prisma.$transaction([
          prisma.service.update({
            where: { id: application.service.id },
            data: { status: "completed", endDate: new Date() },
          }),
          prisma.post.update({
            where: { id: application.postId },
            data: { status: "finished" },
          }),
        ]);

        await saveNotification(
          application.post.clientId,
          "job_completed",
          "Trabajo finalizado",
          `El trabajo "${application.post.title}" se completó con éxito. ¡No olvides dejar una reseña!`,
          {}
        );

        return res.status(200).json({ message: "Post and service finished.", completed: true });
      }

      // Only worker confirmed — notify client
      await saveNotification(
        application.post.clientId,
        "completion_confirmation",
        "Confirmación de finalización pendiente",
        `El trabajador ha marcado "${application.post.title}" como terminado. Revisa el resultado y confirma si estás de acuerdo.`,
        {}
      );

      return res.status(200).json({ message: "Completion notification sent to the client.", completed: false });
    }

    // Client marks their part as done
    if (postId) {
      const application = await prisma.application.findFirst({
        where: { postId, status: "accepted" },
        include: { service: true },
      });

      if (!application?.service) {
        return res.status(404).json({ message: "No active service found for this post." });
      }
      if (application.service.status !== "in_progress") {
        return res.status(409).json({ message: "Service is already finished or cancelled." });
      }

      const updatedService = await prisma.service.update({
        where: { id: application.service.id },
        data: { clientCompletionRequest: true },
      });

      // Both confirmed — complete everything
      if (updatedService.workerCompletionRequest) {
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
          "Trabajo finalizado",
          "Tu trabajo ha sido finalizado con éxito. ¡No olvides dejar una reseña!",
          {}
        );

        return res.status(200).json({ message: "Post and service finished.", completed: true });
      }

      // Only client confirmed — notify worker
      await saveNotification(
        application.workerId,
        "completion_confirmation",
        "Confirmación de finalización pendiente",
        "El cliente ha confirmado el trabajo. Confirma tu parte para cerrar el proceso.",
        {}
      );

      return res.status(200).json({ message: "Completion notification sent to the worker.", completed: false });
    }
  } catch (e) {
    console.error("Error in finishJob:", e);
    return res.status(500).json({ message: "Error finishing the job." });
  }
};
