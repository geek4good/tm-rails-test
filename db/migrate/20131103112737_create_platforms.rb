class CreatePlatforms < ActiveRecord::Migration
  def migrate(direction)
    super
    # Create default platforms
    Platform.create!(:name => 'Android') if direction == :up
    Platform.create!(:name => 'iOS') if direction == :up
  end

  def change
    create_table :platforms do |t|
      t.string :name

      t.timestamps
    end

    create_table :campaigns_platforms do |t|
      t.belongs_to :campaign
      t.belongs_to :platform
    end
  end
end
