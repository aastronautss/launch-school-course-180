# Exercises: Course 180, Lesson 2

## The SQL Language

### 1.

SQL is a special purpose language (as opposed to a general purpose language like Ruby or JavaScript), made for the purpose of interacting with data.

### 2.

*DDL - Data Definition Language:* SQL can modify the structure of the data in a database, using commands like `CREATE`, `DROP`, and `ALTER`.

*DML - Data Manipulation Language:* SQL can manipulate the data within a database. In general terms, this relates to CRUD operations on rows within a database. It uses commands like `SELECT`, `INSERT`, `UPDATE`, and `DELETE`.

*DCL - Data Control Language:* SQL can also control usage and access rights to the data within a database.

### 3.

```sql
'canoe'
'a long road'
'weren''t'
'"No way!"'
```

### 4.

```sql
||
```

### 5.

```sql
SELECT lower('FOO');

-- foo
```

### 6.

`t` and `f`.

### 7.

```sql
SELECT 4 * pi() * 26.3 ^ 2;
```

## PostgreSQL Data Types

### 1.

With `varchar`, we specifiy a maximum length when we define a column in a table. `varchar(35)` will give a maximum length of 35 characters (not padded by spaces, the way `char` does). `text` will give us unlimited characters.

### 2.

`integer`s are just that: integers. They come in three different flavors, depending on the maximum/minimum sizes fit the data better. `decimal`s are decimal numbers with a specified precision, and `real`s are variable-precision floating-point numbers. Due to the way `real`s are stored, the values are inexact and shouldn't be expected to be consistent.

All of these support both positive and negative values.

### 3.

2147483647

### 4.

`timestamp` columns store both the date and time, while `date` will only store the date.

### 5.

No, but there is a `timestamptz` colmn that stores this information.

## Working with a Single Table

### 1.

```sql
CREATE TABLE IF NOT EXISTS people (
  id serial,
  name VARCHAR(50) NOT NULL,
  age INTEGER NOT NULL,
  occupation VARCHAR(100)
);
```

### 2.

```sql
INSERT INTO people (name, age, occupation) VALUES ('Abby', 34, 'biologist');
INSERT INTO people (name, age) VALUES ('Mu''nisah', 26);
INSERT INTO people (name, age, occupation) VALUES ('Mirabelle', 40, 'contractor');
```

### 3.

```sql
SELECT * FROM people WHERE name = 'Mu''nisah';
SELECT * FROM people WHERE age = 26;
SELECT * FROM people WHERE occupation IS NULL;
```

### 4.

```sql
CREATE TABLE IF NOT EXISTS birds (
  name VARCHAR(225),
  length NUMERIC(4, 1),
  wingspan NUMERIC(4, 1),
  family VARCHAR(225),
  extinct BOOLEAN
);
```

### 5.

```sql
INSERT INTO birds (name, length, wingspan, family, extinct)
VALUES ('Spotted Towhee', 21.6, 26.7, 'Emberizidae', false);

INSERT INTO birds VALUES ('American Robin', 25.5, 36.0, 'Turdidae', false);

INSERT INTO birds VALUES ('Greater Koa Finch', 19.0, 24.0, 'Fringillidae', true);

INSERT INTO birds VALUES ('Carolina Parakeet', 33.0, 55.8, 'Psitticidae', true);

INSERT INTO birds VALUES ('Common Kestrel', 35.5, 73.5, 'Falconidae', false);
```

### 6.

```sql
SELECT name, family
FROM birds
WHERE extinct = false
ORDER BY length DESC;
```

### 7.

```sql
SELECT avg(wingspan) AS average, min(wingspan) AS min, max(wingspan) AS max
FROM birds;
```

### 8.

```sql
CREATE TABLE IF NOT EXISTS menu_items (
  item TEXT,
  prep_time INTEGER,
  ingredient_cost DECIMAL(4, 2),
  sales INTEGER,
  menu_price DECIMAL(4, 2)
);
```

### 9.

```sql
INSERT INTO menu_items ITEMS ('omelette', 10, 1.50, 182, 7.99);
INSERT INTO menu_items ITEMS ('tacos', 5, 2.00, 254, 8.99);
INSERT INTO menu_items ITEMS ('oatmeal', 1, 0.50, 79, 5.99);
```

### 10.

```sql
SELECT name, menu_price - ingredient_cost AS profit FROM menu_items
ORDER BY profit DESC LIMIT 1;
```

### 11.

```sql
SELECT name,
       (13.00 / 60.00 * prep_time) AS labor,
       menu_price - ingredient_cost - (13.00 / 60.00 * prep_time) AS profit
FROM menu_items
ORDER BY profit;
```

## Loading Database Dumps

### 1.

The file:

1. Drops any existing table called `films`.
2. Creates a table called `films` that has three columns.
3. Inserts three rows into the `films` table.

### 2.

```sql
SELECT * FROM films;
```

### 3.

```sql
SELECT * FROM films WHERE length(title) < 12;
```

### 4.

```sql
ALTER TABLE films ADD COLUMN director VARCHAR(255);
ALTER TABLE films ADD COLUMN duration INTEGER;
```

### 5.

```sql
UPDATE films SET director = 'John McTiernan', duration = 132 WHERE title = 'Die Hard';
UPDATE films SET director = 'Michael Curtiz', duration = 102 WHERE title = 'Casablanca';
UPDATE films SET director = 'Francis Ford Coppola', duration = 113 WHERE title = 'The Conversation';
```

### 6.

```sql
INSERT INTO films
VALUES ('1984', 1956, 'sfifi', 'Michael Anderson', 90);

INSERT INTO films
VALUES ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127);

INSERT INTO films
VALUES ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);
```

### 7.

```sql
SELECT title, EXTRACT(year from current_date) - year AS age
FROM films
ORDER BY age ASC;
```

### 8.

```sql
SELECT title, duration
FROM films
WHERE duration < 120
ORDER BY duration DESC;
```

### 9.

```sql
SELECT title
FROM films
ORDER BY duration DESC
LIMIT 1;
```

## More Single Table Queries

### 1.

```
createdb residents
```

### 2.

```
psql -d residents < residents_with_data.sql
```

### 3.

```sql
SELECT state, COUNT(id) FROM people GROUP BY state ORDER BY count DESC LIMIT 10;
```

### 4.

```sql
SELECT substr(email, strpos(email, '@') + 1) AS domain, count(id)
FROM people
GROUP BY domain
ORDER BY count DESC;
```

### 5.

```sql
DELETE FROM people
WHERE id = 3399;
```

### 6.

```sql
DELETE FROM people
WHERE state = 'CA';
```

### 7.

```sql
UPDATE people
SET given_name = UPPER(given_name)
WHERE email LIKE '%teleworm.us';
```

### 8.

```sql
DELETE FROM people;
```

## NOT NULL and Default Values

### 1.

NULL in, NULL out.

### 2.

```sql
ALTER TABLE employees ALTER COLUMN department SET DEFAULT 'unassigned';
UPDATE employees SET department = 'unassigned' WHERE department IS NULL;
ALTER TABLE employees ALTER COLUMN department SET NOT NULL;
```

### 3.

```sql
CREATE TABLE IF NOT EXISTS temperatures (
  date DATE DEFAULT NOW() NOT NULL,
  low INTEGER NOT NULL,
  high INTEGER NOT NULL
);
```

### 4.

```sql
INSERT INTO temperatures VALUES ('2016-03-01', 34, 43);
INSERT INTO temperatures VALUES ('2016-03-02', 32, 44);
INSERT INTO temperatures VALUES ('2016-03-03', 31, 47);
INSERT INTO temperatures VALUES ('2016-03-04', 33, 42);
INSERT INTO temperatures VALUES ('2016-03-05', 39, 46);
INSERT INTO temperatures VALUES ('2016-03-06', 32, 43);
INSERT INTO temperatures VALUES ('2016-03-07', 29, 32);
INSERT INTO temperatures VALUES ('2016-03-08', 23, 31);
INSERT INTO temperatures VALUES ('2016-03-09', 17, 28);
```

### 5.

```sql
SELECT date, (high + low) / 2 AS average
FROM temperatures
WHERE date BETWEEN '2016-03-02' AND '2016-03-08';
```

### 6.

```sql
ALTER TABLE temperatures
ADD COLUMN rainfall INTEGER DEFAULT 0;
```

### 7.

```sql
UPDATE temperatures
SET rainfall = ((high + low) / 2) - 35
WHERE (high + low) / 2 > 35;
```

### 8.

```sql
ALTER TABLE temperatures
ALTER COLUMN rainfall
TYPE NUMERIC(6, 3);

UPDATE temperatures
SET rainfall = rainfall * .039;
```

### 9.

```sql
ALTER TABLE temperatures
RENAME TO weather;
```

### 10.

```
\d weather
```

### 11.

```
pg_dump -d sql-course -t weather --inserts > dump.sql
```

## More Constraints

### 1.

```
psql -d sql-course < films2.sql
```

### 2.

```sql
ALTER TABLE films ALTER COLUMN title SET NOT NULL;
ALTER TABLE films ALTER COLUMN year SET NOT NULL;
ALTER TABLE films ALTER COLUMN genre SET NOT NULL;
ALTER TABLE films ALTER COLUMN director SET NOT NULL;
ALTER TABLE films ALTER COLUMN duration SET NOT NULL;
```

### 3.

`\d films` will show `NOT NULL` in the `modifiers` column.

### 4.

```sql
ALTER TABLE films ADD CONSTRAINT title_unique UNIQUE (title);
```

### 5.

The constraint will appear as an index.

### 6.

```sql
ALTER TABLE films DROP CONSTRAINT title_unique;
```

### 7.

```sql
ALTER TABLE films ADD CONSTRAINT title_length CHECK (length(title) >= 1);
```

### 8.

```sql
INSERT INTO films VALUES ('', 2016, 'drama', 'Tyler Guillen', 90);
```

Gives the following error:

```
ERROR:  new row for relation "films" violates check constraint "title_length"
DETAIL:  Failing row contains (, 2016, drama, Tyler Guillen, 90).
```

### 9.

```
Check constraints:
    "title_length" CHECK (length(title::text) >= 1)
```

### 10.

```sql
ALTER TABLE films DROP CONSTRAINT title_length;
```

### 11.

```sql
ALTER TABLE films ADD CONSTRAINT year CHECK (year BETWEEN 1900 AND 2100);
```

### 12.

```
Check constraints:
    "year" CHECK (year >= 1900 AND year <= 2100)
```

### 13.

```sql
ALTER TABLE films ADD CONSTRAINT director_format
CHECK (length(director) >= 3 AND position(' ' in director) > 0);
```

### 14.

```
Check constraints:
    "director_format" CHECK (length(director::text) >= 3 AND "position"(director::text, ' '::text) > 0)
    "year" CHECK (year >= 1900 AND year <= 2100)
```

### 15.

```sql
UPDATE films
SET director = 'Johnny'
WHERE title = 'Die Hard';
```

Throws:

```
ERROR:  new row for relation "films" violates check constraint "director_name"
DETAIL:  Failing row contains (Die Hard, 1988, action, Johnny, 132).
```

### 16.

Data type, NOT NULL, and constraints.

### 17.

```sql
CREATE TABLE test_table (
  test_column_1 INTEGER,
  test_column_2 INTEGER
);

ALTER TABLE test_table ADD CONSTRAINT test_column_size
CHECK (test_column > 0);

ALTER TABLE test_table ALTER COLUMN test_column
SET DEFAULT 0;

INSERT INTO test_table (test_column_2) VALUES (1);
```

throws:

```
ERROR:  new row for relation "test_table" violates check constraint "test_column_size"
DETAIL:  Failing row contains (0, 1).
```

### 18.

```
\d table_name
```

## Using Keys

