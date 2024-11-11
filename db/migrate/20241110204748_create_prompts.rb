class CreatePrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :prompts do |t|
      t.string :prompt_type
      t.text :content

      t.timestamps
    end
  end
end
