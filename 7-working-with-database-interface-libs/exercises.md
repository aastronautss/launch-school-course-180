# Exercises: Course 180, Lesson 7

## Working with a Single Table

### 1.

```
createdb sequel-single-table
```

### 2.

```ruby
require 'sequel'

DB = Sequel.connect "postgres://#{ENV['PSQL_USER']}:#{ENV['PSQL_PASSWORD']}@#{ENV['PSQL_HOST']}:#{ENV['PSQL_PORT']}/sequel-single-table"
```

### 3.

```ruby
DB.create_table(:people) do
  primary_key :id
  String :name
  Fixnum :age
  String :occupation, null: true
end
```

### 4.

```ruby
DB.tables
```

### 5.

```ruby
DB.schema :people
```

### 6.

```ruby
DB[:people].insert name: "Abby", age: 34, occupation: "biologist"
DB[:people].insert name: "Mu'nisah", age: 26
DB[:people].insert name: "Mirabelle", age: 40, occupation: "contractor"
```

### 7.

```ruby
DB[:people].where(name: 'Abby').first
DB[:people].where(age: 34).first
DB[:people].where(occupation: nil).first
```

### 8.

`Hash`.

### 9.

`Array`.

### 10.

```ruby
DB.create_table(:birds) do
  primary_key :id
  String :name, null: false
  Float :length, null: false
  Float :wingspan, null: false
  String :family, null: false
  Boolean :extinct, null: false
end
```

### 11.

```ruby
DB[:birds].insert name: 'Spotted Towhee', length: 21.6, wingspan: 26.7, family: 'Emberizidae', extinct: false
DB[:birds].insert name: 'American Robin', length: 25.5, wingspan: 36.0, family: 'Turdidae', extinct: false
DB[:birds].insert name: "Greater Koa Finch", length: 19.0, wingspan: 24.0, family: "Fringillidae", extinct: true
DB[:birds].insert name: "Carolina Parakeet", length: 33.0, wingspan: 55.8, family: "Psittacidae", extinct: true
DB[:birds].insert name: "Common Kestrel", length: 35.5, wingspan: 73.5, family: "Falconidae", extinct: false
```

### 12.

```ruby
DB[:birds].all
```

### 13.

```ruby
DB[:birds].select(:name, :family).where(extinct: false).order(Sequel.desc(:wingspan)).all
```

###14

```sql
SELECT name, family
  FROM birds
  WHERE extinct IS FALSE
  ORDER BY wingspan DESC
```

### 15.

```ruby
DB[:birds].select do
  [avg(wingspan), min(wingspan), max(wingspan)]
end
```

### 16.

```ruby
DB.create_table(:menu_items) do
  primary_key :id
  String :item, unique: true, null: false
  Integer :prep_time, null: false
  Numeric :ingredient_cost, size: [4, 2], null: false
  Integer :sales, null: false
  Numeric :menu_price, size: [4, 2], null: false
end
```

### 17.

```ruby
DB[:menu_items].insert item: 'omelette', prep_time: 10, ingredient_cost: 1.50, sales: 182, menu_price: 7.99
DB[:menu_items].insert item: "tacos", prep_time: 5, ingredient_cost: 2, sales: 254, menu_price: 8.99
DB[:menu_items].insert item: "oatmeal", prep_time: 1, ingredient_cost: 0.5, sales: 79, menu_price: 5.99
```

### 18.

```ruby
DB[:menu_items].select do
  [ item,
    (menu_price - ingredient_cost).as(profit) ]
end.order(Sequel.desc(:profit)).first
```

### 19.

```sql
SELECT item, (menu_price - ingredient_cost) AS profit
  FROM menu_items
  ORDER BY profit DESC
  LIMIT 1
```

### 20

```ruby
require 'sequel'

def format_money(numeric)
  format("$%0.2f", numeric)
end

DB = Sequel.connect "postgres://#{ENV['PSQL_USER']}:#{ENV['PSQL_PASSWORD']}@#{ENV['PSQL_HOST']}:#{ENV['PSQL_PORT']}/sequel-single-table"

data = DB[:menu_items].select do
  labor_calc = prep_time / 60.0 * 12
  profit_calc = menu_price - ingredient_cost - labor_calc
  [ item,
    menu_price,
    labor_calc.as(labor),
    profit_calc.as(profit) ]
end

data.each do |item|
  puts item[:item]
  puts "menu_price: #{format_money item[:menu_price]}"
  puts "ingredient cost: #{format_money item[:ingredient_cost]}"
  puts "labor: #{format_money item[:labor]}"
  puts "profit: #{format_money item[:profit]}"
end
```

## Working with Multiple Tables

### 1.

```
createdb sequel_multiple_tables
```

### 2.

```
psql -h 192.168.1.2 -p 5432 < theater_full.sql
```

### 3.

```ruby
require 'sequel'

DB = Sequel.connect "postgres://#{ENV['PSQL_USER']}:#{ENV['PSQL_PASSWORD']}@#{ENV['PSQL_HOST']}:#{ENV['PSQL_PORT']}/sequel_multiple_tables"
```

### 4.

```ruby
DB[:tickets].count
```

### 5.

```ruby
DB[:tickets].distinct(:customer_id).count
```

### 6.

```ruby
DB[:tickets].select do
  (count(tickets__customer_id).distinct / count(customers__id).distinct.cast(Float) * 100).as(:percent)
end.right_outer_join(:customers, id: :customer_id).first
```

### 7.

```ruby
DB[:events].select do
  [ events__name,
    count(tickets__id).as(:sales) ]
end.inner_join(:tickets, event_id: :id).
    group(:events__id).
    order(Sequel.desc(:sales)).
    all
```

### 8.

```ruby
DB[:customers].select do
  [ customers__id,
    customers__email,
    count(tickets__event_id).distinct ]
end.
  left_outer_join(:tickets, customer_id: :id).
  group(:customers__id).
  having { count(tickets__event_id).distinct >= 3 }.
  all
```

### 9.

```ruby
DB[:tickets].select do
  [ events__name.as(:event_name),
    events__starts_at,
    sections__name.as(:section),
    seats__row,
    seats__number.as(:seat_number) ]
end.
  join(:events, id: :event_id).
  join(:customers, id: :tickets__customer_id).
  join(:seats, id: :tickets__seat_id).
  join(:sections, id: :seats__section_id).
  where(customers__email: 'gennaro.rath@mcdermott.co').
  all
```
