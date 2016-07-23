require 'sequel'

class SequelPersistence
  def initialize(logger)
    @db = Sequel.connect "postgres://#{ENV['PSQL_USER']}:#{ENV['PSQL_PASSWORD']}@#{ENV['PSQL_HOST']}:#{ENV['PSQL_PORT']}/sinatra-todos"
    @db.loggers << logger
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def find_list(id)
    all_lists.first( lists__id: id)
  end

  def all_lists
    @db[:lists].
      left_join(:todos, list_id: :id).
      select_all(:lists).
      select_append do
        [ count(todos__id).as(todos_count),
          count(nullif(todos__completed, true)).as(todos_remaining_count) ]
      end.
      group(:lists__id).
      order(:lists__name)
  end

  def create_list(list_name)
    @db[:lists].insert name: list_name
  end

  def remove_list(id)
    @db[:todos].where(list_id: id).delete
    @db[:lists].where(id: id).delete
  end

  def update_list_name(id, new_name)
    @db[:lists].where(id: id).update(name: new_name)
  end

  def create_new_todo(list_id, todo_name)
    @db[:todos].insert name: todo_name, list_id: list_id
  end

  def delete_todo_from_list(list_id, todo_id)
    @db[:todos].where(list_id: list_id, todo_id: todo_id).delete
  end

  def update_todo_status(list_id, todo_id, new_status)
    @db[:todos].
      where(list_id: list_id, todo_id: todo_id).
      update(completed: new_status)
  end

  def mark_all_todos_as_completed(list_id)
    @db[:todos].where(list_id: list_id).update(completed: true)
  end

  def get_todos_for_list(list_id)
    @db[:todos].where list_id: list_id
  end

  private

  def tuple_to_list_hash(tuple)
    { id: tuple['id'].to_i,
      name: tuple['name'],
      todos_count: tuple['todos_count'].to_i,
      todos_remaining_count: tuple['todos_remaining_count'].to_i }
  end
end
