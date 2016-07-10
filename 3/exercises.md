# Exercises: Course 180, Lesson 3

## Database Diagrams: Levels of Schema

### 1.

Conceptual, Logical, Physical

### 2.

High-level data model, abstract. Identifies object and how they're related.

### 3.

The physical implementation of a conceptual schema: data types, rules about how they're related to each other

### 4.

One-to-one, one-to-many, many-to-many

## Database Diagrams: Cardinality and Modality

### 1.

Cardinality is the number of entities that can exist on both sides of a relationship (one-to-one, one-to-many, many-to-many).

### 2.

Modality is the lower limit for the number of entities that can exist on each side of the relationship (in other words, whether it's required or optional).

### 3.

One.

### 4.

Crow's foot notation.

## Working with Multiple Tables

### 1.

```
psql -d sql-course < theater_full.sql
```

### 2.

```sql
SELECT count(id) FROM tickets;
```

### 3.

```sql
SELECT count(DISTINCT customer_id) FROM tickets;
```

### 4.

```sql
SELECT count(DISTINCT t.customer_id) / count(DISTINCT c.id)::float * 100 AS percent
FROM tickets as t
RIGHT OUTER JOIN customers as c on c.id = t.customer_id;
```

### 5.

```sql
SELECT e.name, count(t.id) AS sales
  FROM events AS e
  INNER JOIN tickets AS t ON t.event_id = e.id
  GROUP BY e.name
  ORDER BY sales DESC;
```

### 6.

```sql
SELECT c.id, c.email, COUNT(DISTINCT t.event_id) AS event_count
  FROM customers AS c
  LEFT OUTER JOIN tickets AS t ON t.customer_id = c.id
  GROUP BY c.id HAVING COUNT(DISTINCT t.event_id) > 2;
```

### 7.

```sql
SELECT e.name AS event, e.starts_at, sections.name AS section, seats.row, seats.number AS seat
  FROM customers AS c
  INNER JOIN tickets AS t ON t.customer_id = c.id
  INNER JOIN events AS e ON t.event_id = e.id
  INNER JOIN ceats ON t.seat_id = seats.id
  INNER JOIN sections ON seats.section_id = sections.id
  WHERE c.email = 'gennaro.rath@mcdermott.co';
```

## Foreign Keys

### 1.

```
createdb foreign-keys
psql -d foreign-keys < products_orders1.sql
```

### 2.

```sql
INSERT INTO products (name) VALUES ('small bolt');
INSERT INTO products (name) VALUES ('large bolt');

INSERT INTO orders (quantity, product_id) VALUES (10, 1);
INSERT INTO orders (quantity, product_id) VALUES (25, 1);
INSERT INTO orders (quantity, product_id) VALUES (15, 2);
```

### 3.

```sql
SELECT o.quantity, p.name
  FROM orders AS o
  INNER JOIN products AS p ON o.product_id = p.id;
```

### 4.

In the current schema, yes.

### 5.

```sql
ALTER TABLE orders ALTER COLUMN product_id SET NOT NULL;
```

### 6.

```sql
DELETE FROM orders WHERE id = 4;
ALTER TABLE orders ALTER COLUMN product_id SET NOT NULL;
```

### 7.

```sql
CREATE TABLE reviews (
  id serial PRIMARY KEY,
  product_id integer REFERENCES products(id),
  review text NOT NULL
);
```

### 8.

```sql
INSERT INTO reviews (product_id, body) VALUES (1, 'a little small');
INSERT INTO reviews (product_id, body) VALUES (1, 'very round!');
INSERT INTO reviews (product_id, body) VALUES (2, 'could have been smaller');
```

### 9.

False.

## One-to-Many Relationships

### 1.

```sql
INSERT INTO calls ("when", duration, contact_id) VALUES ('2016-01-18 14:47:00', 632, 6);
```

### 2.

```sql
SELECT "when", duration, contacts.first_name
FROM calls
INNER JOIN contacts ON calls.contact_id = contacts.id
WHERE contacts.id != 6;
```

### 3.

```sql
INSERT INTO contacts (first_name, last_name, "number")
  VALUES ('Merve', 'Elk', '6343511126');
INSERT INTO calls ("when", duration, contact_id)
  VALUES ('2016-01-17 11:52:00', 175, 26);

INSERT INTO contacts (first_name, last_name, "number")
  VALUES ('Sawa', 'Fyodorov', '6125594874');
INSERT INTO calls ("when", duration, contact_id)
  VALUES ('2016-01-18 21:22:00', 79, 27);
```

### 4.

```sql
ALTER TABLE contacts ADD CONSTRAINT number_unique UNIQUE (number);
```

### 5.

```sql
INSERT INTO contacts (first_name, last_name, "number") VALUES ('Nivi', 'Petrussen', '6125594874');
```

```
ERROR:  duplicate key value violates unique constraint "number_unique"
DETAIL:  Key (number)=(6125594874) already exists.
```

### 6.

"When" is a reserved word in Postgres, so we need to quote it when using it as a column name.

### 7.

```
Calls ->--- Contact
```

## Many-to-Many Relationships

### 1.

```sql
SELECT b.id, b.author, string_agg(c.name, ', ') AS categories FROM books AS b
  INNER JOIN books_categories ON books_categories.book_id = b.id
  INNER JOIN categories AS c ON books_categories.category_id = c.id
  GROUP BY b.id;
```

### 2.

```sql
ALTER TABLE books ALTER COLUMN title TYPE text;

INSERT INTO books (author, title)
  VALUES ('Lynn Sherr', 'Sally Ride: America''s First Woman in Space');
INSERT INTO books (author, title)
  VALUES ('Charlotte Brontë', 'Jane Eyre');
INSERT INTO books (author, title)
  VALUES ('Meeru Dhalwala and Vikram Vij', 'Vij''s: Elegant and Inspired Indian Cuisine');

INSERT INTO categories (name)
  VALUES ('Cookbook');
INSERT INTO categories (name)
  VALUES ('South Asia');
INSERT INTO categories (name)
  VALUES ('Space Exploration');

INSERT INTO books_categories VALUES (4, 5);
INSERT INTO books_categories VALUES (4, 1);
INSERT INTO books_categories VALUES (4, 9);

INSERT INTO books_categories VALUES (5, 2);
INSERT INTO books_categories VALUES (5, 4);

INSERT INTO books_categories VALUES (6, 7);
INSERT INTO books_categories VALUES (6, 1);
INSERT INTO books_categories VALUES (6, 8);
```

### 3.

```sql
ALTER TABLE books_categories ADD UNIQUE (book_id, category_id);
```

### 4.

```sql
SELECT c.name, COUNT(b.id) AS book_count, STRING_AGG(b.title, ', ') AS book_titles
  FROM categories AS c
  INNER JOIN books_categories ON books_categories.category_id = c.id
  INNER JOIN books AS b ON books_categories.book_id = b.id
  GROUP BY c.name ORDER BY c.name;
```

## Converting a 1:M Relationship to a M:M Relationship

### 1.

```
psql -d films < films7.sql
```

### 2.

```sql
ALTER TABLE films ADD COLUMN id serial PRIMARY KEY;
```

### 3.

```sql
CREATE TABLE films_directors (
  id serial PRIMARY KEY,
  film_id integer REFERENCES films (id),
  director_id integer REFERENCES directors (id)
);
```

### 4.

```sql
INSERT INTO films_directors (film_id, director_id) VALUES (1, 1);
INSERT INTO films_directors (film_id, director_id) VALUES (2, 2);
INSERT INTO films_directors (film_id, director_id) VALUES (3, 3);
INSERT INTO films_directors (film_id, director_id) VALUES (4, 4);
INSERT INTO films_directors (film_id, director_id) VALUES (5, 5);
INSERT INTO films_directors (film_id, director_id) VALUES (6, 6);
INSERT INTO films_directors (film_id, director_id) VALUES (7, 3);
INSERT INTO films_directors (film_id, director_id) VALUES (8, 7);
INSERT INTO films_directors (film_id, director_id) VALUES (9, 8);
INSERT INTO films_directors (film_id, director_id) VALUES (10, 4);
```

### 5.

```sql
ALTER TABLE films DROP COLUMN director_id;
```

### 6.

```sql
SELECT f.title, d.name
  FROM films AS f
  INNER JOIN films_directors ON films_directors.film_id = f.id
  INNER JOIN directors AS d ON films_directors.director_id = d.id
  ORDER BY films.title ASC;
```

### 7.

```sql
INSERT INTO films (title, year, genre, duration) VALUES ('Fargo', 1996, 'comedy', 98);
INSERT INTO directors (name) VALUES ('Joel Coen');
INSERT INTO directors (name) VALUES ('Ethan Coen');
INSERT INTO films_directors (director_id, film_id) VALUES (9, 11);
INSERT INTO films_directors (director_id, film_id) VALUES (10, 11);

INSERT INTO films (title, year, genre, duration) VALUES ('No Country for Old Men', 2007, 'western', 122);
INSERT INTO films_directors (director_id, film_id) VALUES (9, 12);
INSERT INTO films_directors (director_id, film_id) VALUES (10, 12);

INSERT INTO films (title, year, genre, duration) VALUES ('Sin City', 2005, 'crime', 124);
INSERT INTO directors (name) VALUES ('Frank Miller');
INSERT INTO directors (name) VALUES ('Robert Rodriguez');
INSERT INTO films_directors (director_id, film_id) VALUES (11, 13);
INSERT INTO films_directors (director_id, film_id) VALUES (12, 13);

INSERT INTO films (title, year, genre, duration) VALUES ('Spy Kids', 2001, 'scifi', 88) RETURNING id;
INSERT INTO films_directors (director_id, film_id) VALUES (12, 14);
```

### 8.

```sql
SELECT d.name AS director, count(f.id) AS films
  FROM directors AS d
  INNER JOIN films_directors ON films_directors.director_id = d.id
  INNER JOIN films AS f ON films_directors.film_id = f.id
  GROUP BY d.name ORDER BY films DESC, d.name ASC;
```
