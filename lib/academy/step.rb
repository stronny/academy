module Academy
class Step
	module Anything; end

	def self.from_file wizard, fn
		name = File.basename(fn, '.step').to_sym
		step = new wizard, name
		code = open(fn) {|fd| fd.read}
		step.instance_eval code, fn
		step
	end

	attr_reader :name, :result
	def initialize wizard, name
		@wizard = wizard
		@result = nil
		@name = name
		@step_result_block          = method :nil_result
		@new_dependency_value_block = method :nil_result
	end

	def run
		@result = @step_result_block.call
	end

	def result_matches? value
		return true if value == Anything
		return true if value === @result
		sv = (value.is_a? Symbol) ? value.to_s : value
		sr = (@result.is_a? Symbol) ? @result.to_s : @result
		sv == sr
	end

protected

	def nil_result
		nil
	end

	def anything
		Anything
	end

	def depends steps = {}
		steps.each do |name, value|
			@wizard.add_dependency self, name, value
		end
	end

	def step_result &block
		return unless block_given?
		@step_result_block = block
	end

	def new_dependency_value &block
		return unless block_given?
		@new_dependency_value_block = block
	end

end
end
