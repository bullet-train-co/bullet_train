# Hopefully this monkey patch will be temporary. The story for why it's here:
# - This PR to Rails changed it so that columns would be alphabetically ordered in schema.rb
#   https://github.com/rails/rails/pull/53281
#   That has some undersirable side-effcts.
#     1) It makes database table structure unpredictable because the order of columns in the
#     physical database will differ depending on whether the database wascreated by loading the
#     schema or by running migrations in series.
#     2) It breakes our automatic detection of the "first defined string column" which we use in BT if
#     a model doesn't explicitly define a `label_attribute`.
# - If/when this Rails PR is merged we can get rid of this monkey patch:
#   https://github.com/rails/rails/pull/56842
# - Or maybe they'll choose to merge this one instead, in which case we'll need to adjust some configs when
#   we drop this monkey patch:
#   https://github.com/rails/rails/pull/55414

module ActiveRecord
  class SchemaDumper

    private
      def table(table, stream)
        columns = @connection.columns(table)
        begin
          self.table_name = table

          tbl = StringIO.new

          # first dump primary key column
          pk = @connection.primary_key(table)

          tbl.print "  create_table #{relation_name(remove_prefix_and_suffix(table)).inspect}"

          case pk
          when String
            tbl.print ", primary_key: #{pk.inspect}" unless pk == "id"
            pkcol = columns.detect { |c| c.name == pk }
            pkcolspec = column_spec_for_primary_key(pkcol)
            unless pkcolspec.empty?
              if pkcolspec != pkcolspec.slice(:id, :default)
                pkcolspec = { id: { type: pkcolspec.delete(:id), **pkcolspec }.compact }
              end
              tbl.print ", #{format_colspec(pkcolspec)}"
            end
          when Array
            tbl.print ", primary_key: #{pk.inspect}"
          else
            tbl.print ", id: false"
          end

          table_options = @connection.table_options(table)
          if table_options.present?
            tbl.print ", #{format_options(table_options)}"
          end

          tbl.puts ", force: :cascade do |t|"

          # then dump all non-primary key columns
          columns.each do |column|
            raise StandardError, "Unknown type '#{column.sql_type}' for column '#{column.name}'" unless @connection.valid_type?(column.type)
            next if column.name == pk

            type, colspec = column_spec(column)
            if type.is_a?(Symbol)
              tbl.print "    t.#{type} #{column.name.inspect}"
            else
              tbl.print "    t.column #{column.name.inspect}, #{type.inspect}"
            end
            tbl.print ", #{format_colspec(colspec)}" if colspec.present?
            tbl.puts
          end

          indexes_in_create(table, tbl)
          remaining = check_constraints_in_create(table, tbl) if @connection.supports_check_constraints?
          exclusion_constraints_in_create(table, tbl) if @connection.supports_exclusion_constraints?
          unique_constraints_in_create(table, tbl) if @connection.supports_unique_constraints?

          tbl.puts "  end"

          if remaining
            tbl.puts
            tbl.print remaining.string
          end

          stream.print tbl.string
        rescue => e
          stream.puts "# Could not dump table #{table.inspect} because of following #{e.class}"
          stream.puts "#   #{e.message}"
          stream.puts
        ensure
          self.table_name = nil
        end
      end
  end
end

