# Exercises: Course 180, Lesson 8

## Loading All Lists

### 1.

We'll get a `NoMethodError`, since we're trying to call `id` on the object representing the `todos` column (`todos` is defined since, as our block is not accepting any arguments, the block is evaluated within the context of an instance of a `VirtualRow` object. Therefore, we don't get a `NameError`).
