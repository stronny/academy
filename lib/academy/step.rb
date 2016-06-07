module Academy
class Wizard
class Step

	class InvalidInput < Exception; end

	def self.from_file wizard, fn
		name = File.basename(fn, '.step')
		step = new wizard, name
		code = open(fn) {|fd| fd.read}
		step.instance_eval code, fn
		step
	end

	attr_reader :name, :result
	def initialize wizard, name
		@wizard = wizard
		@result = Nothing
		@name = name
	end

	def init
	end

	def new_dependency_values values = {}
		set_instance_values values
	end

	def run
		input = step_result
		post_input = postprocess input
		raise InvalidInput, invalid_input_message unless (valid? post_input rescue false)
		@result = post_input
	rescue InvalidInput
		UI.alert $!.message
		retry
	end

	def result_matches? value
		return false if @result == Nothing
		return true if value == Anything
		return true if value === @result
		sv = (value.is_a? Symbol) ? value.to_s : value
		sr = (@result.is_a? Symbol) ? @result.to_s : @result
		sv == sr
	end

protected

	def anything
		Anything
	end

	def depends steps = {}
		steps.each do |name, value|
			@wizard.add_dependency self, name, value
		end
	end

	def step_result
		nil
	end

	def postprocess input
		input
	end

	def valid? post_input
		true
	end

	def invalid_input_message
		'Please enter a valid value'
	end

	def set_instance_values values = {}
		values.each do |k,v|
			name = '@%s' % k
			instance_variable_set name.to_sym, v
		end
	end

end
end
end
