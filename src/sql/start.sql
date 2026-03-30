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

SELECT name, position FROM employees
WHERE name like '%е%'


-- Посчитать общее количество сотрудников, у которых зарплата меньше 70000.

select count(*) from employees
where salary < 70000


-- Показать имена и зарплаты сотрудников, отсортированных по алфавиту (A-Z).--
select name, salary from employees
ORDER BY name desc

--Найти минимальную, максимальную и среднюю зарплату среди всех сотрудников.
select min(salary) as min_salary, max(salary) as max_salary, avg(salary) as avg_salary from employees

--Показать всех сотрудников, у которых дата найма (hire_date) не указана (NULL).
