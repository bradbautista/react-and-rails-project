class CreateOutcomes < ActiveRecord::Migration[8.0]
  def change
    create_table :outcomes do |t|
      t.text :result
      t.integer :scenario_id

      t.timestamps
    end

    # Add the foreign key constraint separately
    add_foreign_key :outcomes, :scenarios
  end
end
