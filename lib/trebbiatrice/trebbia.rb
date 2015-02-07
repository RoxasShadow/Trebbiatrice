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
    attr_accessor :working_on

    def initialize(login_data)
      @harvest  = Harvest.new(login_data)
      @entry    = nil
      @tracking = false
    end

    def get_task(name)
      @project = active_projects.last unless @project

      @project.tasks.select { |t| t.name == name }.last
    end

    def track!(task = 'Development', notes = '')
      return if tracking?

      if @entry
        @harvest.toggle!(@entry[:id])
      else
        task_id = get_task(task)[:id]
        @entry  = @harvest.new_entry! notes: notes, hours: 0, spent_at: today, project_id: @project[:id], task_id: task_id
      end

      @tracking = true
    end

    def stop_tracking!
      if @entry && tracking?
        @tracking = false
        @harvest.toggle!(@entry[:id])
      end
    end

    def tracking?
      !!@tracking
    end

    def active_projects
      @harvest.projects.select { |project| /#{project[:name]}/i.match(@working_on) }
    end

    def run!(task, testata, frequency)
      last_project, project = nil

      loop do
        response = Trebbia.invoke!(testata[:engine], testata[:name])
        @working_on = response[:contents].select do |content|
          @working_on = content
          active_projects.any?
        end.last

        if response[:status] == 'failure' || !@working_on
          if tracking?
            p "stopping #{project[:name]}" if project
            stop_tracking!
          end

          last_project = nil
          sleep frequency
        else
          if @working_on && (last_project != @working_on || !project)
            last_project = @working_on
            track!(task)

            project = active_projects.last
            p "tracking #{project[:name]}"
          end

          sleep frequency
        end
      end
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