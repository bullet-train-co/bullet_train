class AddStripeCustomerIdToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :stripe_customer_id, :string
  end
end
