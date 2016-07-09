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
