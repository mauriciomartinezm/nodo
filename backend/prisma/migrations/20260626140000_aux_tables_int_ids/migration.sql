-- Auxiliary/internal lookup tables get autoincrement int ids instead of
-- uuid (better join/index performance, no exposure risk since they're
-- never used for authorization). Main entities (AppUser, Post, etc.) keep
-- uuid since their ids are exposed to clients and sequential ints would
-- make enumeration trivial.
--
-- These tables only ever held seed/dev data (re-created by prisma/seed.js
-- on every run), so they were emptied before this migration instead of
-- attempting a uuid->int cast.

-- Drop FKs that reference the columns changing type.
ALTER TABLE "category_hierarchy" DROP CONSTRAINT IF EXISTS "category_hierarchy_generalCategoryId_fkey";
ALTER TABLE "category_hierarchy" DROP CONSTRAINT IF EXISTS "category_hierarchy_specificCategoryId_fkey";
ALTER TABLE "worker_category" DROP CONSTRAINT IF EXISTS "worker_category_generalCategoryId_fkey";
ALTER TABLE "post_category" DROP CONSTRAINT IF EXISTS "post_category_specificCategoryId_fkey";

-- general_category: uuid -> serial
ALTER TABLE "general_category" DROP CONSTRAINT IF EXISTS "general_category_pkey";
ALTER TABLE "general_category" DROP COLUMN "id";
ALTER TABLE "general_category" ADD COLUMN "id" SERIAL NOT NULL;
ALTER TABLE "general_category" ADD CONSTRAINT "general_category_pkey" PRIMARY KEY ("id");

-- specific_category: uuid -> serial
ALTER TABLE "specific_category" DROP CONSTRAINT IF EXISTS "specific_category_pkey";
ALTER TABLE "specific_category" DROP COLUMN "id";
ALTER TABLE "specific_category" ADD COLUMN "id" SERIAL NOT NULL;
ALTER TABLE "specific_category" ADD CONSTRAINT "specific_category_pkey" PRIMARY KEY ("id");

-- category_hierarchy: FK columns -> integer, re-point to the new ids
ALTER TABLE "category_hierarchy" DROP CONSTRAINT IF EXISTS "category_hierarchy_pkey";
TRUNCATE TABLE "category_hierarchy";
ALTER TABLE "category_hierarchy" ALTER COLUMN "general_category_id" TYPE INTEGER USING NULL;
ALTER TABLE "category_hierarchy" ALTER COLUMN "specific_category_id" TYPE INTEGER USING NULL;
ALTER TABLE "category_hierarchy" ADD CONSTRAINT "category_hierarchy_pkey" PRIMARY KEY ("general_category_id", "specific_category_id");
ALTER TABLE "category_hierarchy" ADD CONSTRAINT "category_hierarchy_general_category_id_fkey" FOREIGN KEY ("general_category_id") REFERENCES "general_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "category_hierarchy" ADD CONSTRAINT "category_hierarchy_specific_category_id_fkey" FOREIGN KEY ("specific_category_id") REFERENCES "specific_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- worker_category: FK column -> integer
TRUNCATE TABLE "worker_category";
ALTER TABLE "worker_category" ALTER COLUMN "general_category_id" TYPE INTEGER USING NULL;
ALTER TABLE "worker_category" ADD CONSTRAINT "worker_category_general_category_id_fkey" FOREIGN KEY ("general_category_id") REFERENCES "general_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- post_category: FK column -> integer
TRUNCATE TABLE "post_category";
ALTER TABLE "post_category" ALTER COLUMN "specific_category_id" TYPE INTEGER USING NULL;
ALTER TABLE "post_category" ADD CONSTRAINT "post_category_specific_category_id_fkey" FOREIGN KEY ("specific_category_id") REFERENCES "specific_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- post_photo: uuid -> serial (no other table references it)
ALTER TABLE "post_photo" DROP CONSTRAINT IF EXISTS "post_photo_pkey";
ALTER TABLE "post_photo" DROP COLUMN "id";
ALTER TABLE "post_photo" ADD COLUMN "id" SERIAL NOT NULL;
ALTER TABLE "post_photo" ADD CONSTRAINT "post_photo_pkey" PRIMARY KEY ("id");

-- dispute_evidence: uuid -> serial (no other table references it)
ALTER TABLE "dispute_evidence" DROP CONSTRAINT IF EXISTS "dispute_evidence_pkey";
ALTER TABLE "dispute_evidence" DROP COLUMN "id";
ALTER TABLE "dispute_evidence" ADD COLUMN "id" SERIAL NOT NULL;
ALTER TABLE "dispute_evidence" ADD CONSTRAINT "dispute_evidence_pkey" PRIMARY KEY ("id");

-- balance_movement: uuid -> serial (no other table references it)
ALTER TABLE "balance_movement" DROP CONSTRAINT IF EXISTS "balance_movement_pkey";
ALTER TABLE "balance_movement" DROP COLUMN "id";
ALTER TABLE "balance_movement" ADD COLUMN "id" SERIAL NOT NULL;
ALTER TABLE "balance_movement" ADD CONSTRAINT "balance_movement_pkey" PRIMARY KEY ("id");

-- New lookup table: ubicaciones del Urabá antioqueño.
CREATE TABLE "location" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "location_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "location_name_key" ON "location"("name");
