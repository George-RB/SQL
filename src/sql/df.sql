CREATE TABLE dwarves (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    profession VARCHAR(50),
    happiness INT DEFAULT 50
);

INSERT INTO dwarves (name, profession, happiness) VALUES
('Urist McMiner', 'miner', 75),
('Dumat Stoneshield', 'miner', 25),
('Inod Craftsdwarf', 'craftsdwarf', 90),
('Zon Blacksmith', 'blacksmith', 45),
('Tosid Woodcutter', 'woodcutter', 60),
('Monom Miserable', 'miner', 12),
('Astesh Brewer', 'brewer', 55),
('Rith Jeweler', 'jeweler', 80);
----

SELECT * FROM dwarves
WHERE profession = 'miner'
----

select name, profession from dwarves
where profession != 'blacksmith'

select name, happiness from dwarves
ORDER BY happiness desc
limit 3 

select name from dwarves
where name like 'U%'

select name, happiness from dwarves
where happiness between 40 and 71 

select name, happiness from dwarves
where profession = 'miner' and happiness <30 

select * from dwarves
ORDER BY profession asc, happiness desc

select name, profession, happiness from dwarves
ORDER BY happiness asc
LIMIT 3

-- Список имён шахтёров в одной строке
SELECT profession, GROUP_CONCAT(name) AS all_names
FROM dwarves
GROUP BY profession;

SELECT profession, AVG(happiness) AS avg_happiness
FROM dwarves
GROUP BY profession WITH ROLLUP;

-- Добавим больше данных для аналитики
INSERT INTO dwarves (name, profession, happiness) VALUES
('Ubbul Carpenter', 'carpenter', 70),
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
    FOREIGN KEY (dwarf_id) REFERENCES dwarves(id)
);

INSERT INTO tasks (dwarf_id, task_type, duration_days, completed) VALUES
(1, 'dig', 5, TRUE),
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

select count(name) as count_dwarves, avg(happiness) as avg_happ, max(happiness) as max_happ, min(happiness) as min_happ from dwarves

select count(*), profession as  prof from dwarves
GROUP BY profession

select avg(happiness) as avg_happ, profession from dwarves
GROUP BY profession

select count(name) as count, profession, avg(happiness) as avg_happ, max(happiness) as max_happ, min(happiness) as min_happ from dwarves
group by profession

select count(*) as compl, dwarf_id from tasks
where completed = true
GROUP BY dwarf_id

select profession from dwarves
GROUP BY profession
HAVING count(*) > 2

select profession, avg(happiness) as avg_happ from dwarves
GROUP BY profession
HAVING avg(happiness) < 50

select profession, GROUP_concat(name) from dwarves
GROUP BY profession

-- Гномы (уже есть)
SELECT * FROM dwarves;

-- Задания (уже есть)
SELECT * FROM tasks;

-- Добавим артефакты (новая таблица)
CREATE TABLE artifacts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dwarf_id INT,
    value INT,
    created_year INT,
    FOREIGN KEY (dwarf_id) REFERENCES dwarves(id)
);

INSERT INTO artifacts (name, dwarf_id, value, created_year) VALUES
('Silver Blade', 1, 5000, 105),
('Diamond Door', 3, 12000, 106),
('Obsidian Crown', 4, 8000, 105),
('Ruby Amulet', 1, 3000, 107),
('Gold Statue', NULL, 15000, 108);  -- артефакт без владельца

select * from dwarves
select * from tasks
select * from artifacts

select distinct dwarves.name, tasks.task_type from dwarves
inner join tasks on dwarves.id = tasks.dwarf_id

select distinct dwarves.name, tasks.task_type from dwarves
left join tasks on dwarves.id = tasks.dwarf_id

select  dwarves.name, tasks.completed from dwarves
left join tasks on dwarves.id = tasks.dwarf_id and completed = 1
-- Если не использовать and completed = 1 то пропадут все дварфы у которых нет заданий

select dwarves.name, count(tasks.task_type) as count_task from dwarves
left join tasks on dwarves.id = tasks.dwarf_id
group BY name
having count_task > 1
-- в последней строке сделали фильтр типа если больше одного задания то вывести


select artifacts.name, COALESCE(dwarves.name, 'No owner') from artifacts
left join dwarves on dwarves.id = artifacts.dwarf_id 


select distinct tasks.task_type, artifacts.name, dwarves.name  from tasks
left join dwarves on dwarves.id = tasks.dwarf_id 
left join artifacts on artifacts.dwarf_id = tasks.dwarf_id 

ALTER TABLE dwarves ADD COLUMN manager_id INT NULL;
UPDATE dwarves SET manager_id = NULL WHERE id = 1;
UPDATE dwarves SET manager_id = 1 WHERE id IN (2, 3, 5);
UPDATE dwarves SET manager_id = 3 WHERE id = 4;

SELECT d1.name AS dwarf_name, d2.name AS manager_name
FROM dwarves d1
LEFT JOIN dwarves d2 ON d1.manager_id = d2.id;

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

ALTER TABLE dwarves ADD COLUMN fortress_id INT NULL;
ALTER TABLE dwarves ADD FOREIGN KEY (fortress_id) REFERENCES fortresses(id);

INSERT INTO fortresses (name, difficulty, founding_year) VALUES
('Boatmurdered', 8, 105),
('Caveblazes', 5, 107),
('Silverhold', 3, 110);

UPDATE dwarves SET fortress_id = 1 WHERE id IN (1, 2, 3);
UPDATE dwarves SET fortress_id = 2 WHERE id IN (4, 5, 6, 7);
UPDATE dwarves SET fortress_id = 3 WHERE id IN (8, 9, 10);

select * from dwarves
select * from tasks
select * from artifacts
select * from fortresses

select * from dwarves
where id in (select dwarf_id from tasks)

select * from dwarves d
where exists (select 1 from tasks t where t.dwarf_id = d.id)

select name, happiness from dwarves d
where happiness > (
    select avg(happiness) as avg_happ from dwarves dd
    where dd.fortress_id = d.fortress_id
)

WITH art_count AS (
    SELECT dwarf_id, COUNT(*) AS artif_count 
    FROM artifacts
    GROUP BY dwarf_id
)
SELECT d.name, art.artif_count 
FROM dwarves d
INNER JOIN art_count art ON d.id = art.dwarf_id;

with high_happiness as (
    select name, happiness from dwarves
    where happiness > 70
)
select * from high_happiness

-- Добавим руководителей гномов
ALTER TABLE dwarves ADD COLUMN manager_id INT NULL;

-- Назначим руководителей
-- Urist (id=1) — главный
-- Dumat (id=2) подчиняется Urist
-- Inod (id=3) подчиняется Urist
-- Zon (id=4) подчиняется Dumat
-- Tosid (id=5) подчиняется Inod

UPDATE dwarves SET manager_id = NULL WHERE id = 1;
UPDATE dwarves SET manager_id = 1 WHERE id IN (2, 3);
UPDATE dwarves SET manager_id = 2 WHERE id = 4;
UPDATE dwarves SET manager_id = 3 WHERE id = 5;

WITH RECURSIVE hierarchy AS (
    -- Базовый запрос: начинаем с Urist
    SELECT id, name, manager_id, 1 AS level
    FROM dwarves
    WHERE id = 1
    
    UNION ALL
    
    -- Рекурсивный запрос: ищем подчинённых
    SELECT d.id, d.name, d.manager_id, h.level + 1
    FROM dwarves d
    JOIN hierarchy h ON d.manager_id = h.id
)
SELECT * FROM hierarchy;

with recursive hierarchy as (
    select id, name, manager_id, 1 as level from dwarves
    where id = 1

    UNION all

    select d.id, d.name, d.manager_id, h.level + 1 from dwarves d
    join hierarchy h on d.manager_id = h.id
)
select * from hierarchy
---

SELECT VERSION();
SELECT 
    name,
    profession,
    happiness,
    ROW_NUMBER() OVER (ORDER BY happiness DESC) AS happiness_rank
FROM dwarves;