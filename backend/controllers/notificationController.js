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

  const redisKey = `notifications:${userId}`;

  try {
    const notifications = await redis.lRange(redisKey, 0, -1);
    const result = notifications.map(n => JSON.parse(n));
    return res.status(200).json(result);
  } catch (error) {
    console.error('Error fetching notifications:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

export async function getNotifications(req, res) {
  try {
    const keys = await redis.keys('notifications:*');

    const result = [];

    for (const key of keys) {
      const userId = key.split(':')[1];
      const notifications = await redis.lRange(key, 0, -1);
      const parsed = notifications.map(n => JSON.parse(n));
      result.push({ userId, notifications: parsed });
    }

    return res.status(200).json(result);
  } catch (error) {
    console.error('Error fetching all notifications:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}
