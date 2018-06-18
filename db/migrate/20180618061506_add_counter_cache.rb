class AddCounterCache < ActiveRecord::Migration[5.1]
  def change
    add_column :deliverers, :shifts_count, :integer, default: 0
    add_column :shifts, :deliverers_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE deliverers
             SET shifts_count = (SELECT count(*)
                                   FROM assignments
                                  WHERE assignments.deliverer_id = deliverers.id);
          UPDATE shifts
             SET deliverers_count = (SELECT count(*)
                                       FROM assignments
                                      WHERE assignments.shift_id = shifts.id);
        SQL
      end
    end
  end
end
