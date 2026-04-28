SELECT COUNT(*)
FROM dwarves;

CREATE TABLE dwarves_backup LIKE dwarves;

INSERT INTO dwarves_backup
SELECT *
FROM dwarves;

SELECT COUNT(*)
FROM dwarves_backup;

DELETE FROM dwarves;

SELECT COUNT(*)
FROM dwarves;

-- должно быть 0