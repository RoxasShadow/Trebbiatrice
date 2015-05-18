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
  class << self
    def run!(login_data, task, testata, frequency)
      trebbia = Trebbia.new(login_data)
      last_project, project = nil, nil

      listen_to_int!(trebbia)

      loop do
        response = Trebbia.invoke!(testata[:engine], testata[:name])

        trebbia.working_on = response[:contents].select do |content|
          trebbia.working_on = content
          trebbia.active_projects.any?
        end.last

        if response[:status] == 'failure' || !trebbia.working_on
          stop_tracking!(trebbia)

          last_project = nil
        else
          if trebbia.working_on && (last_project != trebbia.working_on || !trebbia.project)
            stop_tracking!(trebbia)

            trebbia.project = trebbia.active_projects.last
            trebbia.track! task

            last_project = trebbia.working_on
            puts "tracking #{trebbia.project[:name]}"
          end
        end

        sleep(frequency)
      end
    end

  private

    def stop_tracking!(trebbia)
      if trebbia.tracking?
        puts "stopping #{trebbia.project[:name]}" if trebbia.project
        trebbia.stop_tracking!
      end
    end

    def listen_to_int!(trebbia)
      trap('INT') do
        puts 'Stopping gracefully the trebbiatrice...'
        trebbia.stop_tracking! if trebbia.tracking?
        exit
      end
    end
  end
end
