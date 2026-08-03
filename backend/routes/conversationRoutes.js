import { Router } from "express";
import {
  getOrCreateConversation,
  getMessages,
  sendMessage,
} from "../controllers/conversationController.js";

const conversationRouter = Router();

conversationRouter.get("/api/getOrCreateConversation/:applicationId", getOrCreateConversation);
conversationRouter.get("/api/getMessages/:conversationId", getMessages);
conversationRouter.post("/api/sendMessage", sendMessage);

export default conversationRouter;
