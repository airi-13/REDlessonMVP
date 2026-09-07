PRAGMA foreign_keys = ON;

CREATE TABLE students (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE period_slots (
  period INTEGER PRIMARY KEY,
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL
);

INSERT INTO period_slots VALUES
(1,'15:00','15:40'),
(2,'15:45','16:25'),
(3,'16:30','17:10'),
(4,'17:15','17:55'),
(5,'18:00','18:40'),
(6,'18:45','19:25'),
(7,'19:30','20:10'),
(8,'20:15','20:55');

CREATE TABLE weekday_availability (
  weekday INTEGER NOT NULL CHECK (weekday BETWEEN 0 AND 6),
  period INTEGER NOT NULL REFERENCES period_slots(period),
  available INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (weekday, period)
);

INSERT INTO weekday_availability(weekday,period,available) VALUES
(0,1,1),(0,2,1),(0,3,1),(0,4,1),(0,5,1),(0,6,1),(0,7,1),(0,8,1),
(1,1,1),(1,2,1),(1,3,1),(1,4,1),(1,5,1),(1,6,1),(1,7,1),(1,8,1),
(2,1,1),(2,2,1),(2,3,1),(2,4,1),(2,5,1),(2,6,1),(2,7,1),(2,8,1),
(3,1,1),(3,2,1),(3,3,1),(3,4,1),(3,5,1),(3,6,1),(3,7,1),(3,8,1),
(4,1,1),(4,2,1),(4,3,1),(4,4,1),(4,5,1),(4,6,1),(4,7,1),(4,8,1),
(5,1,1),(5,2,1),(5,3,1),(5,4,1),(5,5,1),(5,6,1),(5,7,1),(5,8,1),
(6,1,1),(6,2,1),(6,3,1),(6,4,1),(6,5,1),(6,6,1),(6,7,1),(6,8,1);

CREATE TABLE weekly_lessons (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  weekday INTEGER NOT NULL CHECK (weekday BETWEEN 0 AND 6),
  period INTEGER NOT NULL REFERENCES period_slots(period),
  active INTEGER NOT NULL DEFAULT 1,
  UNIQUE(student_id, weekday, period)
);

CREATE TABLE lessons (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  lesson_date TEXT NOT NULL,
  period INTEGER NOT NULL REFERENCES period_slots(period),
  source TEXT NOT NULL CHECK (source IN ('weekly','admin','makeup')),
  original_lesson_id INTEGER REFERENCES lessons(id),
  status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled','absent','makeup_used','cancelled')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(student_id, lesson_date, period)
);

CREATE TABLE makeup_entitlements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  original_lesson_id INTEGER NOT NULL UNIQUE REFERENCES lessons(id) ON DELETE CASCADE,
  used_lesson_id INTEGER UNIQUE REFERENCES lessons(id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_lessons_student_date ON lessons(student_id, lesson_date);
CREATE INDEX idx_weekly_lessons_student ON weekly_lessons(student_id);
CREATE INDEX idx_makeup_student ON makeup_entitlements(student_id);
