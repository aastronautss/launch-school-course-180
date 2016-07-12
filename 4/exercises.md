# Exercises: Course 180, Lesson 4

## Database Design

### 1.

9999.99

### 2.

-9999.99

### 3.

ALTER TABLE expenses ADD CONSTRAINT positive_amount CHECK (amount > 0);

## Displaying Help

### 1.

That's a HEREDOC, which allows us to create a string with multiple lines. The `<<~` indicates to Ruby that the whitespace before each line.

## Adding Expenses

### 1.

Our code doesn't escape apostrophes, so if the memo includes an apostrophe, the SQL statement won't run (or worse: execute commands that the user types in).

## Handling Parameters Safely

### 1.

A `ProtocolViolation` will be thrown.

### 2.

```ruby
@db.exec_params "INSERT INTO expenses (amount, memo) VALUES ($1, $2)", [amount, memo]
```

### 3.

The memo will be properly escaped.
