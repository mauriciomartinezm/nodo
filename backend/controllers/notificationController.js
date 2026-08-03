import redis from '../database/redisClient.js';
import { saveNotification } from '../services/notificationService.js';

export async function createNotification(req, res) {
  const { userId, type, title, message, data } = req.body;

  try {
    await saveNotification(userId, type, title, message, data);
    res.json({ message: 'Notification added successfully' });
  } catch (error) {
    console.error('Error creating notification:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

export async function getNotificationsByUserId(req, res) {
  const { userId } = req.params;

  if (!userId) {
    return res.status(400).json({ error: 'userId is required' });
  }

  if (!redis.isOpen) {
    return res.status(200).json([]);
  }

  try {
    const notifications = await redis.lRange(`notifications:${userId}`, 0, -1);
    return res.status(200).json(notifications.map(n => JSON.parse(n)));
  } catch (error) {
    console.error('Error fetching notifications:', error.message);
    return res.status(200).json([]);
  }
}

export async function getNotifications(req, res) {
  if (!redis.isOpen) {
    return res.status(200).json([]);
  }

  try {
    const keys = await redis.keys('notifications:*');
    const result = [];
    for (const key of keys) {
      const userId = key.split(':')[1];
      const notifications = await redis.lRange(key, 0, -1);
      result.push({ userId, notifications: notifications.map(n => JSON.parse(n)) });
    }
    return res.status(200).json(result);
  } catch (error) {
    console.error('Error fetching all notifications:', error.message);
    return res.status(200).json([]);
  }
}
