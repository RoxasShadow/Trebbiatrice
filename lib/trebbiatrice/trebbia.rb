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
  class Trebbia
    attr_accessor :working_on, :project

    def initialize(login_data)
      @harvest  = Harvest.new(login_data)
      @entry    = nil
      @tracking = false
    end

    def active_projects
      @harvest.projects.select do |project|
        project_name = project[:name].downcase
        matches = @working_on.split('/').select { |part| project_name.include?(part.downcase) }
        matches.reject(&:empty?).any?
      end
    end

    def get_task(name)
      @project.tasks.select { |t| t.name == name }.last
    end

    def track!(task = 'Development', notes = '')
      return if tracking?

      task_id = get_task(task)[:id]
      @entry  = @harvest.new_entry! notes: notes, hours: 0, spent_at: today, project_id: @project[:id], task_id: task_id

      @tracking = true
    end

    def stop_tracking!
      if @entry && tracking?
        @tracking = false
        @harvest.toggle!(@entry[:id])
        @entry = nil
      end
    end

    def tracking?
      !!@tracking
    end

    class << self
      def invoke!(*input)
        stdin, stdout, stderr = Open3.popen3(*input)

        response = unless stderr.read.chomp.strip.empty?
          { status: 'failure', contents: stderr }
        else
          { status: 'success', contents: stdout }
        end

        response[:contents] = response[:contents].read.each_line.map(&:chomp)
        response
      end
    end

  private

    def today
      Time.now.strftime('%Y/%m/%d')
    end
  end
end
