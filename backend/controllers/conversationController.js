import { prisma } from "../database/prisma.js";

export const getOrCreateConversation = async (req, res) => {
  const { applicationId } = req.params;
  try {
    let conversation = await prisma.conversation.findUnique({
      where: { applicationId },
    });
    if (!conversation) {
      conversation = await prisma.conversation.create({
        data: { applicationId },
      });
    }
    res.json(conversation);
  } catch (e) {
    console.error("Error in getOrCreateConversation:", e);
    res.status(500).json({ message: "Error fetching conversation." });
  }
};

export const getMessages = async (req, res) => {
  const { conversationId } = req.params;
  try {
    const messages = await prisma.message.findMany({
      where: { conversationId },
      orderBy: { sentAt: "asc" },
      select: {
        id: true,
        senderId: true,
        content: true,
        sentAt: true,
        status: true,
      },
    });
    res.json(messages);
  } catch (e) {
    console.error("Error in getMessages:", e);
    res.status(500).json({ message: "Error fetching messages." });
  }
};

export const sendMessage = async (req, res) => {
  const { conversationId, senderId, content } = req.body;
  if (!conversationId || !senderId || !content?.trim()) {
    return res.status(400).json({
      message: "conversationId, senderId and content are required.",
    });
  }
  try {
    const message = await prisma.message.create({
      data: {
        conversationId,
        senderId,
        content: content.trim(),
        status: "sent",
      },
      select: {
        id: true,
        senderId: true,
        content: true,
        sentAt: true,
        status: true,
      },
    });
    res.status(201).json(message);
  } catch (e) {
    console.error("Error in sendMessage:", e);
    res.status(500).json({ message: "Error sending message." });
  }
};
