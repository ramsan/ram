class CategoriesMemories < ActiveRecord::Migration
  def change
    create_table :categories_memories, :id => false do |t|
      t.references :category, :memory
    end
    add_index(:categories_memories, [:category_id, :memory_id], :unique => true)
  end
end
