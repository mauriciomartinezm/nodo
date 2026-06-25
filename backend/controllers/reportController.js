import { prisma } from "../database/prisma.js";

export const getReports = async (req, res) => {
  try {
    const reports = await prisma.report.findMany();
    res.json(reports);
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

export const getReport = async (req, res) => {
  try {
    const report = await prisma.report.findUnique({ where: { id: req.params.id } });
    if (!report) {
      return res.status(404).json({ message: "No records found" });
    }
    res.json(report);
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: error.message });
    }
  }
};

export const getReportByPostId = async (req, res) => {
  try {
    const reports = await prisma.report.findMany({ where: { postId: req.params.id } });
    if (reports.length === 0) {
      return res.status(200).json({ message: "No records found" });
    }
    res.json(reports);
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: error.message });
    }
  }
};

// A user can only report the same post once (unique constraint in the database).
export const createReport = async (req, res) => {
  try {
    const { postId, userId, reason } = req.body;

    if (!postId || !userId || !reason) {
      return res.status(400).json({ message: "Missing required fields." });
    }

    const post = await prisma.post.findUnique({ where: { id: postId } });
    if (!post) {
      return res.status(404).json({ message: "Post does not exist." });
    }

    const report = await prisma.report.create({
      data: { postId, userId, reason },
    });

    res.status(201).json({ ...report, message: "Report created successfully" });
  } catch (error) {
    if (error.code === "P2002") {
      return res.status(409).json({ message: "You already reported this post." });
    }
    console.error(error);
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};
