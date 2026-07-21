import bcrypt from "bcryptjs";
import { prisma } from "../database/prisma.js";

const userInclude = {
  worker: { include: { workerCategories: { include: { generalCategory: true } } } },
};

// The frontend's date picker sends dates as "dd/MM/yyyy", which JS's Date
// constructor cannot parse reliably (it expects ISO format). Accepts both
// "dd/MM/yyyy" and ISO strings.
function parseBirthDate(value) {
  const ddmmyyyy = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(value);
  if (ddmmyyyy) {
    const [, day, month, year] = ddmmyyyy;
    return new Date(Number(year), Number(month) - 1, Number(day));
  }
  return new Date(value);
}

function omitPassword(user) {
  if (!user) return user;
  const { passwordHash, ...rest } = user;
  return rest;
}

export const getUsers = async (req, res) => {
  try {
    const users = await prisma.appUser.findMany({ include: userInclude });
    res.json(users.map(omitPassword));
  } catch (error) {
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

export const getUser = async (req, res) => {
  try {
    const user = await prisma.appUser.findUnique({
      where: { id: req.params.id },
      include: userInclude,
    });

    if (!user) {
      return res.status(404).json({ message: "No records found" });
    }

    res.json(omitPassword(user));
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: error.message });
    }
  }
};

// id is no longer sent by the client: Prisma generates it automatically.
// If isWorker is true, a Worker profile is created alongside the user.
export const createUser = async (req, res) => {
  try {
    const data = req.body;

    const requiredFields = [
      "firstName",
      "lastName",
      "dni",
      "email",
      "phone",
      "birthDate",
      "password",
    ];
    const missing = requiredFields.filter((field) => !data[field]);
    if (missing.length > 0) {
      return res.status(400).json({
        message: `Missing required fields: ${missing.join(", ")}`,
      });
    }

    const birthDate = parseBirthDate(data.birthDate);
    if (isNaN(birthDate.getTime())) {
      return res.status(400).json({ message: "Invalid birthDate." });
    }

    const passwordHash = await bcrypt.hash(data.password, 10);

    const user = await prisma.appUser.create({
      data: {
        firstName: data.firstName,
        lastName: data.lastName,
        secondLastName: data.secondLastName ?? null,
        dni: data.dni,
        email: data.email,
        phone: data.phone,
        birthDate,
        passwordHash,
        profilePhoto: data.profilePhoto ?? null,
        location: data.location ?? null,
        verified: false,
      },
    });

    let worker = null;
    if (data.isWorker) {
      worker = await prisma.worker.create({
        data: {
          userId: user.id,
          description: data.description ?? null,
        },
      });
    }

    res.status(200).json({
      message: "User registered successfully",
      user: { ...omitPassword(user), worker: worker ? { ...worker, workerCategories: [] } : null },
    });
  } catch (error) {
    console.error("Error creating user:", error);
    if (error.code === "P2002") {
      return res.status(409).json({
        message: "A user with that DNI, email, or phone already exists.",
      });
    }
    res.status(500).json({ message: "Error registering user", error: error.message });
  }
};

export const login = async (req, res) => {
  const { identifier, password } = req.body; // phone or email

  try {
    const user = await prisma.appUser.findFirst({
      where: { OR: [{ phone: identifier }, { email: identifier }] },
      include: userInclude,
    });

    if (!user) {
      return res.status(401).json({ messageFail: "Invalid credentials" });
    }

    const passwordMatches = await bcrypt.compare(password, user.passwordHash);
    if (!passwordMatches) {
      return res.status(401).json({ messageFail: "Invalid credentials" });
    }

    return res.status(200).json({
      messageSuccess: "Login successful",
      user: omitPassword(user),
    });
  } catch (error) {
    console.error("Error en login:", error);
    return res.status(500).json({ messageFail: "Server error", error: error.message });
  }
};

export const updateUser = async (req, res) => {
  try {
    const userId = req.params.id;
    const data = { ...req.body };

    if (data.password) {
      data.passwordHash = await bcrypt.hash(data.password, 10);
      delete data.password;
    }
    if (data.birthDate) {
      data.birthDate = parseBirthDate(data.birthDate);
    }

    // Estos dos viven en Worker/WorkerCategory, no en AppUser, así que no
    // pueden pasar por prisma.appUser.update junto con el resto de `data`.
    const description = data.description;
    delete data.description;
    const generalCategoryIds = data.generalCategoryIds;
    delete data.generalCategoryIds;

    if (Object.keys(data).length > 0) {
      await prisma.appUser.update({ where: { id: userId }, data });
    }

    if (description !== undefined) {
      await prisma.worker.update({ where: { userId }, data: { description } });
    }

    if (Array.isArray(generalCategoryIds)) {
      const categoryIds = generalCategoryIds.map(Number);
      await prisma.workerCategory.deleteMany({ where: { workerId: userId } });
      await prisma.workerCategory.createMany({
        data: categoryIds.map((generalCategoryId) => ({ workerId: userId, generalCategoryId })),
        skipDuplicates: true,
      });
    }

    res.json({ message: "Data updated successfully" });
  } catch (error) {
    if (error.code === "P2025") {
      return res.status(404).json({ message: "Record not found" });
    }
    console.error(error);
    res.status(500).json({ message: error.message });
  }
};

// Convierte a un cliente existente en trabajador: crea su fila en Worker
// (si todavía no la tiene) y le asigna los rubros elegidos. Es idempotente,
// así que también sirve si alguien reintenta tras un error de red.
export const activateWorker = async (req, res) => {
  try {
    const userId = req.params.id;
    const { description, generalCategoryIds, location } = req.body;

    if (!description || !Array.isArray(generalCategoryIds) || generalCategoryIds.length === 0) {
      return res.status(400).json({
        message: "'description' y al menos un rubro en 'generalCategoryIds' son obligatorios.",
      });
    }

    const user = await prisma.appUser.findUnique({ where: { id: userId } });
    if (!user) {
      return res.status(404).json({ message: "El usuario no existe." });
    }

    const categoryIds = generalCategoryIds.map(Number);
    const matchingCategories = await prisma.generalCategory.findMany({
      where: { id: { in: categoryIds } },
    });
    if (matchingCategories.length !== categoryIds.length) {
      return res.status(404).json({ message: "Uno o más rubros no existen." });
    }

    await prisma.worker.upsert({
      where: { userId },
      create: { userId, description },
      update: { description },
    });

    if (location) {
      await prisma.appUser.update({ where: { id: userId }, data: { location } });
    }

    await prisma.workerCategory.deleteMany({ where: { workerId: userId } });
    await prisma.workerCategory.createMany({
      data: categoryIds.map((generalCategoryId) => ({ workerId: userId, generalCategoryId })),
      skipDuplicates: true,
    });

    res.json({ message: "Perfil de trabajador activado correctamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: error.message });
  }
};

export const deleteUser = async (req, res) => {
  try {
    await prisma.appUser.delete({ where: { id: req.params.id } });
    res.json({ message: "Record deleted successfully" });
  } catch (error) {
    if (error.code === "P2025") {
      return res.status(404).json({ message: "Record not found" });
    }
    console.error(error);
    res.status(500).json({ message: error.message });
  }
};
