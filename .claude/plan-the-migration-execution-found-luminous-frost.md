### Indexes requiring modification

Old SQL
```sql
-- GIN index for image_urls array
CREATE INDEX IF NOT EXISTS idx_posts_image_urls ON public.posts USING GIN (image_urls);
```

New SQL
```sql
-- GIN index for image_urls array
CREATE INDEX IF NOT EXISTS idx_messages_image_urls ON public.messages USING GIN (image_urls);
```

Reason: The `posts` table does not have an `image_urls` column. The `messages` table does have an `image_urls` column (of type TEXT[]) and lacks a GIN index for efficient array queries.

STALE INDEX REPORT
- idx_posts_image_urls: missing column (the `posts` table has no `image_urls` column)