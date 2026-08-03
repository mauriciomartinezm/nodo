import { WebSocketServer, WebSocket } from "ws";
import { prisma } from "../database/prisma.js";

// conversationId -> Set<WebSocket>
const rooms = new Map();

export function setupChatWebSocket(httpServer) {
  const wss = new WebSocketServer({ server: httpServer, path: "/chat" });

  wss.on("connection", (ws, req) => {
    const params = new URLSearchParams((req.url ?? "").split("?")[1] ?? "");
    const conversationId = params.get("conversationId");

    if (!conversationId) {
      ws.close(1008, "conversationId required");
      return;
    }

    if (!rooms.has(conversationId)) rooms.set(conversationId, new Set());
    rooms.get(conversationId).add(ws);

    ws.on("message", async (raw) => {
      let parsed;
      try {
        parsed = JSON.parse(raw.toString());
      } catch {
        return;
      }

      const { senderId, content } = parsed;
      if (!senderId || !content?.trim()) return;

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

        const payload = JSON.stringify({ type: "message", ...message });
        const room = rooms.get(conversationId);
        if (room) {
          for (const client of room) {
            if (client.readyState === WebSocket.OPEN) client.send(payload);
          }
        }
      } catch (e) {
        console.error("WS: error saving message:", e);
        if (ws.readyState === WebSocket.OPEN) {
          ws.send(JSON.stringify({ type: "error", message: "No se pudo enviar el mensaje." }));
        }
      }
    });

    ws.on("close", () => {
      const room = rooms.get(conversationId);
      if (room) {
        room.delete(ws);
        if (room.size === 0) rooms.delete(conversationId);
      }
    });

    ws.on("error", (err) => console.error("WS client error:", err));
  });
}
