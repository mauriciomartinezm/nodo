import { PrismaClient } from "../generated/prisma/index.js";
import { PrismaPg } from "@prisma/adapter-pg";

const isLocal = /localhost|127\.0\.0\.1/.test(process.env.DATABASE_URL ?? "");

const adapter = new PrismaPg({
  connectionString: process.env.DATABASE_URL,
  ssl: isLocal ? false : { rejectUnauthorized: false },
});

export const prisma = new PrismaClient({ adapter });
