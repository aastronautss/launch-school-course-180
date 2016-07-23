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
