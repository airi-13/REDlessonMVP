PRAGMA foreign_keys = ON;

-- A single absence can have at most one makeup lesson, even under concurrent requests.
CREATE UNIQUE INDEX IF NOT EXISTS idx_one_makeup_per_original
ON lessons(original_lesson_id)
WHERE source = 'makeup';
