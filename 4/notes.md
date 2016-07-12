# Ruby and SQL

## Executing SQL Statements from Ruby

If we have a result object `result`:

```ruby
result.each do |tuple|
  puts "#{tuple["title"]} came out in #{tuple["year"]}"
end
```

The method passes the tuple as a hash, rather than an array. That way we can simply call each column by its name. If we want arrays to be passed to our block, we just use `each_row`:

```ruby
result.each_row do |row|
  puts "#{row[1]}"
end
```

We can use `result[2]` to get the third row (as a hash) from the results object.

Note that all data is in a string, so we'd need to coerce our objects to their right objects before performing any operations on them.

`field_values`:

```ruby
result.field_values('duration')
```

Returns the results from the column name 'duration' as an array.
