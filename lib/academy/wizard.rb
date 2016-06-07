module Academy
class Wizard
	module Nothing; end
	module Anything; end
	module Back; end

	def initialize
		@steps = {}
		@ustream = {}
		@dstream = {}
		@initialized = []
		@results_changed = {} # child => [parent, ...]
	end

	def add_step_from_file fn
		step = Step.from_file self, fn
		@steps[step.name] = step
	end

	def add_dependency step, u_name, value
		d = step.name
		u = u_name.to_s
		@ustream[d] ||= {}
		@ustream[d][u] = value
		@dstream[u] ||= {}
		@dstream[u][d] = value
	end

	def run!
		step = next_step
		while step do
			if not @initialized.include? step then
				step.init
				@initialized.push step
			end
			if @results_changed[step.name] then
				values = {}
				@results_changed.delete(step.name).each { |name| values[name] = name2result(name) }
				step.new_dependency_values values
			end
			r_old = step.result
			step.run
			if r_old != step.result then
				@dstream.fetch(step.name, {}).each do |name, value|
					next unless step.result_matches? value
					@results_changed[name] ||= []
					@results_changed[name].push step.name
				end
			end
			step = next_step
		end

#@steps.each { |name, step| p [name, step.result] }

#	rescue UI::Back
	end

protected

	def next_step
		@steps.each do |name, step|
			next unless step.result == Nothing
			return step if deps(step).map { |k,v| name2step(k).result_matches? v }.all?
		end
		nil
	end

	def name2step name
		@steps[name.to_s]
	end

	def name2result name
		name2step(name).result
	end

	def deps arg
		arg = arg.name if arg.is_a? Step
		@ustream.fetch arg, {}
	end

end
end
