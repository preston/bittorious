class BigintFix < ActiveRecord::Migration[5.0]
    def change
        change_column	:peers,	:uploaded,	:bigint
        change_column	:peers,	:downloaded,	:bigint
        change_column	:peers,	:left,	:bigint
        change_column	:peers,	:volunteer_affinity_offset,	:bigint
        change_column	:peers,	:volunteer_affinity_length,	:bigint
    end
end
