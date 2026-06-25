-- Rename column to preserve existing data (instead of drop + add)
ALTER TABLE "app_user" RENAME COLUMN "national_id" TO "dni";

-- Rename the unique index to match
ALTER INDEX "app_user_national_id_key" RENAME TO "app_user_dni_key";
