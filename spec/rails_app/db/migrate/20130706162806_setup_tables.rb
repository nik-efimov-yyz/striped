class SetupTables < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string    :email, null: false
      t.string    :status
      t.datetime  :trial_ends_at
      t.string    :stripe_customer_id
      t.timestamps
    end

  end

  def down
    drop_table :users
  end

end
