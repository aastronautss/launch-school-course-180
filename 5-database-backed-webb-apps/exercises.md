# Exercises: Course 180, Lesson 5

## Designing a Schema

### 1.

```sql
CREATE TABLE lists (
  id serial PRIMARY KEY,
  name text NOT NULL UNIQUE
);

CREATE TABLE todos (
  id serial PRIMARY KEY,
  list_id integer NOT NULL REFERENCES lists (id),
  name text NOT NULL,
  completed boolean NOT NULL DEFAULT false
);
```

### 2.

```
touch schema.sql
```

### 3.

```
createdb sinatra-todos
psql -d sinatra-todos < schema.sql
```

## Setting up a Database Connection

### 1.

`PG::Result` includes the `Enumerable` module, so we can call `map` on it just like any such object.
