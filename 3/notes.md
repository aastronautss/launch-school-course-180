# Notes: Course 180, Lesson 3

## Types of Schema

### Entity-relationship diagrams w/Conceptual schema

Dealing with entities (represented by rectangles, with the name inside).

Relationships described by lines between the boxes.

You refer to 'entities' as 'entities' rather than tables, since we're only concerned with the abstract entities. We might need to split an entity up into multiple tables.

### ERDs with w/Physical schema

When we have a one-to-many relation, we have a foreign key on the many table, pointing to a primary key to the one table.

When we have a many-to-many relation, we have an intermediate table (a 'join' table) with foreign keys pointing to the two linking tables.

## Cardinality and Modality

### Definitions

Cardinality: the number of objects on each side of the relationship:

(1:1, 1:M, M:M)

Modality: If the relationship is required (1) or optional (0). In other words, it's the lower bound on the number of relationships in the model.

### Crow's Feet

-|-o--- One/Optional

-|-|--- One/Required

->-o--- Many/Optional

->-|--- Many/Required

### Modality

Modality determines the business rules on how the application is going to operate. This is useful for thinking about how it's going to work rather than actual implementation.

### One-to-one schemas

We acutally use the same physical schema for a one-to-one schema as we do with a one-to-many schema. One entity has a foreign key pointing back to the other. However, it's ambiguous what direction that side is pointing to.

## Review of JOINS

### INNER JOINs

Example:

```sql
SELECT * FROM comments INNER JOIN users ON comments.user_id = users.id;
```

This selects only the rows from each joined table in which records exist on both tables.

### LEFT OUTER JOINs

This includes rows from the left table that don't have entries in the right table. For example, the following query...

```sql
SELECT * FROM comments LEFT OUTER JOIN users ON comments.user_id = users.id;
```

...will give us all entries in the `comments`, even if they don't have a user attached to them.

### RIGHT OUTER JOIN

This is the reverse of `LEFT OUTER JOIN`. The following query...

```sql
SELECT * FROM comments RIGHT OUTER JOIN users ON comments.user_id = users.id;
```

...will give us all entries from `users` even if they don't have comments. Comments without users are excluded.

### CROSS JOIN

```sql
SELECT * FROM comments CROSS JOIN users;
```

Note that we don't use an `ON` clause here. Here we get the cartesian product of the rows in both tables, or every possible combination of rows from each table.

### Other JOIN syntax

`JOIN` can be used in place of `INNER JOIN`

`LEFT JOIN` can be used in place of `LEFT OUTER JOIN`.

The following:

```sql
SELECT * FROM comments, users;
```

gives us the cross join.

```sql
SELECT * FROM comments, users WHERE comments.user_id = users.id;
```

gives us the inner join.

## Foreign Keys

Foreign keys can mean two things: a relationship between two rows by pointing to a specific row in another table using its primary key (A _foreign key column_), and a constraint that enforces certain rules about what values are permitted in a foreign key relationship (_foreign key constraint_).

Foreign key columns are just the column on a table, while a constraing refers to the constraint put on that column.

Constraint creation with table creation:

```sql
CREATE TABLE orders (
  id serial PRIMARY KEY,
  product_id integer REFERENCES products (id),
  quantity integer NOT NULL
);
```
Constraint creation post-hoc:

```sql
ALTER TABLE orders ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) products(id);
```


