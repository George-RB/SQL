CREATE TABLE dwarves (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    profession VARCHAR(50),
    happiness INT DEFAULT 50
);

INSERT INTO dwarves (name, profession, happiness)
VALUES ('Urist McMiner', 'miner', 75),
    ('Dumat Stoneshield', 'miner', 25),
    ('Inod Craftsdwarf', 'craftsdwarf', 90),
    ('Zon Blacksmith', 'blacksmith', 45),
    ('Tosid Woodcutter', 'woodcutter', 60),
    ('Monom Miserable', 'miner', 12),
    ('Astesh Brewer', 'brewer', 55),
    ('Rith Jeweler', 'jeweler', 80);

-- Добавим больше данных для аналитики
INSERT INTO dwarves (name, profession, happiness)
VALUES ('Ubbul Carpenter', 'carpenter', 70),
    ('Meng Mason', 'mason', 35),
    ('Shem Miner', 'miner', 85),
    ('Catten Engineer', 'engineer', 50),
    ('Doren Farmer', 'farmer', 20),
    ('Kib Brewer', 'brewer', 65),
    ('Mafol Blacksmith', 'blacksmith', 40);

-- Таблица заданий (для сложных запросов)
CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dwarf_id INT,
    task_type VARCHAR(50),
    duration_days INT,
    completed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (dwarf_id) REFERENCES dwarves (id)
);

INSERT INTO tasks (dwarf_id, task_type, duration_days, completed)
VALUES (1, 'dig', 5, TRUE),
    (1, 'dig', 3, TRUE),
    (2, 'dig', 4, FALSE),
    (3, 'craft', 2, TRUE),
    (4, 'smith', 6, TRUE),
    (4, 'smith', 2, FALSE),
    (5, 'woodcut', 3, TRUE),
    (6, 'brew', 1, TRUE),
    (6, 'brew', 2, TRUE),
    (7, 'carpenter', 4, FALSE),
    (8, 'mason', 5, TRUE),
    (9, 'dig', 3, TRUE),
    (9, 'dig', 2, FALSE),
    (10, 'engineer', 7, TRUE);

-- Добавим артефакты (новая таблица)
CREATE TABLE artifacts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dwarf_id INT,
    value INT,
    created_year INT,
    FOREIGN KEY (dwarf_id) REFERENCES dwarves (id)
);

INSERT INTO artifacts (name, dwarf_id, value, created_year)
VALUES ('Silver Blade', 1, 5000, 105),
    ('Diamond Door', 3, 12000, 106),
    ('Obsidian Crown', 4, 8000, 105),
    ('Ruby Amulet', 1, 3000, 107),
    ('Gold Statue', NULL, 15000, 108);

-- Гномы (уже есть)
-- Задания (уже есть)
-- Артефакты (уже есть)
-- Добавим форты для сложных подзапросов
CREATE TABLE fortresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    difficulty INT,
    founding_year INT
);

ALTER TABLE dwarves
ADD COLUMN fortress_id INT NULL;

ALTER TABLE dwarves
ADD FOREIGN KEY (fortress_id) REFERENCES fortresses (id);

INSERT INTO fortresses (name, difficulty, founding_year)
VALUES ('Boatmurdered', 8, 105),
    ('Caveblazes', 5, 107),
    ('Silverhold', 3, 110);

UPDATE dwarves
SET fortress_id = 1
WHERE id IN (1, 2, 3);

UPDATE dwarves
SET fortress_id = 2
WHERE id IN (4, 5, 6, 7);

UPDATE dwarves
SET fortress_id = 3
WHERE id IN (8, 9, 10);

-- Назначим руководителей
-- Urist (id=1) — главный
-- Dumat (id=2) подчиняется Urist
-- Inod (id=3) подчиняется Urist
-- Zon (id=4) подчиняется Dumat
-- Tosid (id=5) подчиняется Inod
UPDATE dwarves
SET manager_id = NULL
WHERE id = 1;

UPDATE dwarves
SET manager_id = 1
WHERE id IN (2, 3);

UPDATE dwarves
SET manager_id = 2
WHERE id = 4;

UPDATE dwarves
SET manager_id = 3
WHERE id = 5;