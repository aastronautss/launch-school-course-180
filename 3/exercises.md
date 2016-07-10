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
