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
