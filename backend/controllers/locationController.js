import { prisma } from "../database/prisma.js";

export const getLocations = async (req, res) => {
  try {
    const locations = await prisma.location.findMany({ orderBy: { name: "asc" } });
    res.json(locations);
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};
