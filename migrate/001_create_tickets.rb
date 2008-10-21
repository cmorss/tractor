class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.column :ticket_id, :integer
      t.column :repository_id, :integer
      t.column :created_date, :timestamp
      t.column :updated_date, :timestamp
      t.column :component, :text
      t.column :cc, :text
      t.column :totalhours, :text
      t.column :status, :text
      t.column :estimatedhours, :text
      t.column :billable, :text
      t.column :resolution, :text
      t.column :reporter, :text
      t.column :ticket_rank, :text
      t.column :type, :text
      t.column :priority, :text 
      t.column :version, :text
      t.column :summary, :text
      t.column :desc, :text
      t.column :owner, :text
      t.column :hours, :text
      t.column :milestone, :text
      t.column :keywords, :text
    end
    
    create_table :repositories do |t|
      t.column :name, :text
      t.column :host, :text
      t.column :username, :text
      t.column :password, :text
      t.column :tickets_last_synced_at, :timestamp
      t.column :metadata_last_synced_at, :timestamp
    end
    
    create_table :milestones do |t|
      t.column :repository_id, :integer
      t.column :name, :text
      t.column :desc, :text
      t.column :completed, :boolean
      t.column :due, :date
    end

    create_table :ticket_types do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end
    
    create_table :ticket_statuses do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end
    
    create_table :severities do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end
    
    create_table :resolutions do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end
    
    create_table :priorities do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end

    create_table :components do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end

    create_table :versions do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end

    create_table :reporters do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end

    create_table :owners do |t|
      t.column :repository_id, :integer
      t.column :name, :text
    end
  end

  def self.down
    drop_table :resolutions
    drop_table :repository
    drop_table :tickets
  end
end