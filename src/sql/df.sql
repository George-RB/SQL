SELECT *
FROM dwarves
WHERE profession = 'miner';

SELECT name,
    profession
FROM dwarves
WHERE profession != 'blacksmith';

SELECT name,
    happiness
FROM dwarves
ORDER BY happiness DESC
LIMIT 3;

SELECT name
FROM dwarves
WHERE name LIKE 'U%';

SELECT name,
    happiness
FROM dwarves
WHERE happiness BETWEEN 40 AND 71;

SELECT name,
    happiness
FROM dwarves
WHERE profession = 'miner'
    AND happiness < 30;

SELECT *
FROM dwarves
ORDER BY profession ASC,
    happiness DESC;

SELECT name,
    profession,
    happiness
FROM dwarves
ORDER BY happiness ASC
LIMIT 3;

-- Список имён шахтёров в одной строке;
SELECT profession,
    GROUP_CONCAT (name) AS all_names
FROM dwarves
GROUP BY profession;

SELECT profession,
    AVG(happiness) AS avg_happiness
FROM dwarves
GROUP BY profession WITH ROLLUP;

SELECT count(name) AS count_dwarves,
    avg(happiness) AS avg_happ,
    max(happiness) AS max_happ,
    min(happiness) AS min_happ
FROM dwarves
SELECT count(*),
    profession AS prof
FROM dwarves
GROUP BY profession
SELECT avg(happiness) AS avg_happ,
    profession
FROM dwarves
GROUP BY profession
SELECT count(name) AS count,
    profession,
    avg(happiness) AS avg_happ,
    max(happiness) AS max_happ,
    min(happiness) AS min_happ
FROM dwarves
GROUP BY profession
SELECT count(*) AS compl,
    dwarf_id
FROM tasks
WHERE completed = TRUE
GROUP BY dwarf_id
SELECT profession
FROM dwarves
GROUP BY profession
HAVING count(*) > 2
SELECT profession,
    avg(happiness) AS avg_happ
FROM dwarves
GROUP BY profession
HAVING avg(happiness) < 50
SELECT profession,
    GROUP_CONCAT (name)
FROM dwarves
GROUP BY profession -- Гномы (уже есть)
SELECT *
FROM dwarves;

-- Задания (уже есть)
SELECT *
FROM tasks;

-- артефакт без владельца
SELECT *
FROM dwarves
SELECT *
FROM tasks
SELECT *
FROM artifacts
SELECT DISTINCT dwarves.name,
    tasks.task_type
FROM dwarves
    INNER JOIN tasks ON dwarves.id = tasks.dwarf_id
SELECT DISTINCT dwarves.name,
    tasks.task_type
FROM dwarves
    LEFT JOIN tasks ON dwarves.id = tasks.dwarf_id
SELECT dwarves.name,
    tasks.completed
FROM dwarves
    LEFT JOIN tasks ON dwarves.id = tasks.dwarf_id
    AND completed = 1 -- Если не использовать and completed = 1 то пропадут все дварфы у которых нет заданий
SELECT dwarves.name,
    count(tasks.task_type) AS count_task
FROM dwarves
    LEFT JOIN tasks ON dwarves.id = tasks.dwarf_id
GROUP BY name
HAVING count_task > 1 -- в последней строке сделали фильтр типа если больше одного задания то вывести
SELECT artifacts.name,
    COALESCE(dwarves.name, 'No owner')
FROM artifacts
    LEFT JOIN dwarves ON dwarves.id = artifacts.dwarf_id
SELECT DISTINCT tasks.task_type,
    artifacts.name,
    dwarves.name
FROM tasks
    LEFT JOIN dwarves ON dwarves.id = tasks.dwarf_id
    LEFT JOIN artifacts ON artifacts.dwarf_id = tasks.dwarf_id
ALTER TABLE dwarves
ADD COLUMN manager_id INT NULL;

UPDATE dwarves
SET manager_id = NULL
WHERE id = 1;

UPDATE dwarves
SET manager_id = 1
WHERE id IN (2, 3, 5);

UPDATE dwarves
SET manager_id = 3
WHERE id = 4;

SELECT d1.name AS dwarf_name,
    d2.name AS manager_name
FROM dwarves d1
    LEFT JOIN dwarves d2 ON d1.manager_id = d2.id;

SELECT *
FROM dwarves
SELECT *
FROM tasks
SELECT *
FROM artifacts
SELECT *
FROM fortresses
SELECT *
FROM dwarves
WHERE id IN (
        SELECT dwarf_id
        FROM tasks
    )
SELECT *
FROM dwarves d
WHERE EXISTS (
        SELECT 1
        FROM tasks t
        WHERE t.dwarf_id = d.id
    )
SELECT name,
    happiness
FROM dwarves d
WHERE happiness > (
        SELECT avg(happiness) AS avg_happ
        FROM dwarves dd
        WHERE dd.fortress_id = d.fortress_id
    ) WITH art_count AS (
        SELECT dwarf_id,
            COUNT(*) AS artif_count
        FROM artifacts
        GROUP BY dwarf_id
    )
SELECT d.name,
    art.artif_count
FROM dwarves d
    INNER JOIN art_count art ON d.id = art.dwarf_id;

WITH high_happiness AS (
    SELECT name,
        happiness
    FROM dwarves
    WHERE happiness > 70
)
SELECT *
FROM high_happiness -- Добавим руководителей гномов
ALTER TABLE dwarves
ADD COLUMN manager_id INT NULL;

WITH RECURSIVE hierarchy AS (
    -- Базовый запрос: начинаем с Urist
    SELECT id,
        name,
        manager_id,
        1 AS LEVEL
    FROM dwarves
    WHERE id = 1
    UNION ALL
    -- Рекурсивный запрос: ищем подчинённых
    SELECT d.id,
        d.name,
        d.manager_id,
        h.level + 1
    FROM dwarves d
        JOIN hierarchy h ON d.manager_id = h.id
)
SELECT *
FROM hierarchy;

WITH recursive hierarchy AS (
    SELECT id,
        name,
        manager_id,
        1 AS LEVEL
    FROM dwarves
    WHERE id = 1
    UNION ALL
    SELECT d.id,
        d.name,
        d.manager_id,
        h.level + 1
    FROM dwarves d
        JOIN hierarchy h ON d.manager_id = h.id
)
SELECT *
FROM hierarchy ---
SELECT VERSION ();

SELECT name,
    profession,
    happiness,
    ROW_NUMBER() OVER (
        ORDER BY happiness DESC
    ) AS happiness_rank
FROM dwarves;

SELECT name,
    profession,
    happiness,
    row_number() over (
        ORDER BY happiness DESC
    ) AS avg_by_profession
FROM dwarves;

SELECT *
FROM dwarves;

SELECT d.name AS dwarf_name,
    m.name AS manager_name
FROM dwarves d
    JOIN dwarves m ON d.manager_id = m.id;

SELECT d.name as dwarf,
    b.name as boss
FROM dwarves d
    join dwarves b on d.manager_id = b.id
    AND d.happiness > b.happiness;

select name,
    profession,
    happiness,
    avg(happiness) over (partition by profession) as avg_by_profession
from dwarves;

-- Накопительная сумма (ранжирование)
SELECT name,
    happiness,
    SUM(happiness) OVER (
        ORDER BY happiness
    ) as running_total
FROM dwarves;

-- Скользящее среднее за 3 строки (текущая + предыдущая + следующая)
SELECT name,
    happiness,
    AVG(happiness) OVER (
        ORDER BY happiness ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) as sliding_avg
FROM dwarves;

SELECT name,
    profession,
    row_number() over(
        ORDER BY happiness DESC
    ) as happ
FROM dwarves;

SELECT name,
    profession,
    row_number() over(
        PARTITION BY profession
        ORDER BY happiness DESC
    ) as happ
FROM dwarves;

SELECT name,
    profession,
    rank() over(
        ORDER BY profession DESC
    ) as prof
FROM dwarves;

---Для каждого гнома покажи счастье предыдущего (по списку счастья)
SELECT name,
    happiness,
    lag(happiness) over (
        ORDER BY happiness
    ) as prev
FROM dwarves;

---Покажи разницу в счастье с предыдущим гномом
SELECT name,
    happiness,
    happiness - lag(happiness) over (
        ORDER BY happiness
    ) as prev
FROM dwarves;

---Для каждого гнома покажи самого счастливого в его профессии
SELECT name,
    profession,
    happiness,
    first_value(name) over (
        PARTITION BY profession
        ORDER BY happiness DESC
    ) as happinest_in_prof
FROM dwarves;

---Разбей гномов на 3 группы по уровню счастья
SELECT name,
    happiness,
    ntile(3) over (
        ORDER BY happiness
    ) as group_num
FROM dwarves;