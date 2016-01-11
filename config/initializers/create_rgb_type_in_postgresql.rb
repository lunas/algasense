drop_type_sql   = 'DROP TYPE IF EXISTS rgb;'
create_type_sql = 'CREATE TYPE rgb AS ( red NUMERIC, green NUMERIC, blue NUMERIC );'

ActiveRecord::Base.connection_pool.with_connection do |con|
  con.exec_query drop_type_sql
  con.exec_query create_type_sql
end