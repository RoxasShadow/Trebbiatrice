#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Trebbiatrice
  class Harvest
    def initialize(login_data)
      @harvest = ::Harvest.hardy_client(login_data)
    end

    def projects
      @harvest.time.trackable_projects
    end

    def new_entry!(entry_data, find = true)
      if find
        project_id = entry_data[:project_id].to_s
        entry = @harvest.time.all.select { |entry| entry[:project_id].to_s == project_id }.last

        if entry
          toggle!(entry[:id])
          entry
        else
          new_entry!(entry_data, false)
        end
      else
        @harvest.time.create(entry_data)
      end
    end

    def toggle!(entry_id)
      @harvest.time.toggle(entry_id)
    end
  end
end
