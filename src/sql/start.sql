-- ======================================
-- МОЙ ПЕРВЫЙ SQL КОД
-- ======================================

-- 1. Создаём базу данных
CREATE DATABASE shop;

-- 2. Переключаемся на неё
USE shop;

-- 3. Создаём таблицу сотрудников
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(100),
    salary DECIMAL(10,2)
);

-- 4. Добавляем данные
INSERT INTO employees (name, position, salary) VALUES
('Иван Петров', 'Manager', 75000),
('Анна Сидорова', 'Developer', 65000);

-- 5. Смотрим результат
SELECT * FROM employees;