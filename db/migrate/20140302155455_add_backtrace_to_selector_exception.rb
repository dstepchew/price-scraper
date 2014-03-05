class AddBacktraceToSelectorException < ActiveRecord::Migration
  def change
    add_column :selector_exceptions, :backtrace, :text
  end
end
