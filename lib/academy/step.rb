module Academy
class Step
	module Anything; end

	def self.from_file wizard, fn
		name = File.basename(fn, '.step').to_sym
		step = new wizard, name
		code = open(fn) {|fd| fd.read}
		step.instance_eval code
		step
	end

	attr_reader :name, :depends, :result
	def initialize wizard, name
		@wizard = wizard
		@result = nil
		@name = name
#		@upstream = {}
#		@downstream = {}
		@step_result_block = method :nil_result
	end

#	def add_downstream step, value
#		@downstream[step] = value
#	end

	def run
		@result = @step_result_block.call
		@wizard.my_downstream(self).each { |name, value| @wizard.step(name).run if result_matches? value }
#		@downstream.each { |step, value| step.run if result_matches? value }
	end

protected

	def result_matches? value
		return true if value == Anything
		value === @result
	end

	def nil_result
		nil
	end

	def anything
		Anything
	end

	def depends steps = {}
		steps.each do |name, value|
			@wizard.add_dependency self, name, value
#			step = @wizard.step name
#			@upstream[step] = value
#			step.add_downstream self, value
		end
	end

	def step_result &block
		return unless block_given?
		@step_result_block = block
	end

end
end
