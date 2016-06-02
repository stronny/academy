module Academy

	def self.create_from_steps_near_me fn
		me = File.realpath fn
		mydir = File.dirname me
		steps = File.join mydir, 'steps'
		wizard = Wizard.new
		Dir.glob('%s/*.step' % steps) { |fn| wizard.add_step_from_file fn }
		wizard
	end

end

require 'academy/ui'
require 'academy/wizard'
require 'academy/step'
