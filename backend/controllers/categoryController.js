import { prisma } from "../database/prisma.js";

// ===== General categories (selected by workers) =====

export const getGeneralCategories = async (req, res) => {
  try {
    const categories = await prisma.generalCategory.findMany();
    res.json(categories);
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

export const getGeneralCategory = async (req, res) => {
  try {
    const category = await prisma.generalCategory.findUnique({ where: { id: req.params.id } });
    if (!category) {
      return res.status(404).json({ message: "No records found" });
    }
    res.json(category);
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

export const createGeneralCategory = async (req, res) => {
  try {
    const { name } = req.body;
    if (!name) {
      return res.status(400).json({ message: "The 'name' field is required." });
    }
    const category = await prisma.generalCategory.create({ data: { name } });
    res.status(201).json({ message: "General category created successfully", category });
  } catch (error) {
    console.error("Error creating general category:", error);
    res.status(500).json({ message: "Error registering category", error: error.message });
  }
};

// ===== Specific categories (assigned to posts) =====

export const getSpecificCategories = async (req, res) => {
  try {
    const categories = await prisma.specificCategory.findMany();
    res.json(categories);
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

export const getSpecificCategory = async (req, res) => {
  try {
    const category = await prisma.specificCategory.findUnique({ where: { id: req.params.id } });
    if (!category) {
      return res.status(404).json({ message: "No records found" });
    }
    res.json(category);
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

// A specific category must be created linked to at least one general
// category, otherwise it will never be matched to any worker.
export const createSpecificCategory = async (req, res) => {
  try {
    const { name, generalCategoryIds } = req.body;

    if (!name || !Array.isArray(generalCategoryIds) || generalCategoryIds.length === 0) {
      return res.status(400).json({
        message: "'name' and at least one general category in 'generalCategoryIds' are required.",
      });
    }

    const category = await prisma.specificCategory.create({
      data: {
        name,
        hierarchyLinks: {
          create: generalCategoryIds.map((generalCategoryId) => ({ generalCategoryId })),
        },
      },
      include: { hierarchyLinks: true },
    });

    res.status(201).json({ message: "Specific category created successfully", category });
  } catch (error) {
    console.error("Error creating specific category:", error);
    res.status(500).json({ message: "Error registering category", error: error.message });
  }
};

// ===== Worker categories (a worker selects which general categories apply to them) =====

export const getWorkerCategories = async (req, res) => {
  try {
    const workerCategories = await prisma.workerCategory.findMany({
      include: { generalCategory: true },
    });
    res.json(workerCategories);
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

export const createWorkerCategory = async (req, res) => {
  const { workerId, generalCategoryIds } = req.body;

  if (!workerId || !Array.isArray(generalCategoryIds) || generalCategoryIds.length === 0) {
    return res.status(400).json({
      message: "A workerId and a generalCategoryIds array with at least one element are required.",
    });
  }

  try {
    await prisma.workerCategory.createMany({
      data: generalCategoryIds.map((generalCategoryId) => ({
        workerId,
        generalCategoryId: generalCategoryId.trim(),
      })),
      skipDuplicates: true,
    });

    res.status(200).json({
      message: "Categories assigned to worker successfully.",
      data: { workerId, generalCategoryIds },
    });
  } catch (error) {
    console.error("Error registering worker_category:", error.message);
    res.status(500).json({
      message: "Error registering worker categories.",
      error: error.message,
    });
  }
};
