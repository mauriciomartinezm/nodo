-- DropForeignKey
ALTER TABLE "post_category" DROP CONSTRAINT "post_category_post_id_fkey";

-- DropForeignKey
ALTER TABLE "post_photo" DROP CONSTRAINT "post_photo_post_id_fkey";

-- AddForeignKey
ALTER TABLE "post_photo" ADD CONSTRAINT "post_photo_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_category" ADD CONSTRAINT "post_category_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE CASCADE;
