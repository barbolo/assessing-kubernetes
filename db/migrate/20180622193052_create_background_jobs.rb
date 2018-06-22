class CreateBackgroundJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :background_jobs do |t|
      t.string :hostname, index: true

      t.timestamps
    end
  end
end
