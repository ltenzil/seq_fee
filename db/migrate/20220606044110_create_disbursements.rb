class CreateDisbursements < ActiveRecord::Migration[6.1]
  def change
    create_table :disbursements do |t|
      t.references :order, null: false, foreign_key: true
      t.references :merchant, null: false, foreign_key: true
      t.float :amount
      t.float :fee
      t.float :total_fee
      t.float :pay_merchant
      t.boolean :is_paid, default: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
