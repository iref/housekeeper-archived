class ChangeCircleDescription < ActiveRecord::Migration
  def change
    change_column :circles, :description, :text
  end
end
