class AddLinkAndPriceToMemory < ActiveRecord::Migration
  def change
    add_column :memories, :sale_link, :string
    add_column :memories, :sale_price, :decimal, :precision => 8, :scale => 2
  end
end
