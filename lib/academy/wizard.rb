module Academy
class Wizard

	def initialize
		@main = Step.new self, :main
		@steps = { @main.name => @main }
		@upstream = {}
		@downstream = {}
	end

	def add_step_from_file fn
		step = Step.from_file self, fn
		@steps[step.name] = step
	end

	def step name
		@steps[name]
	end

	def add_dependency step, upstream_name, value
		@upstream[step.name] ||= {}
		@upstream[step.name][upstream_name] = value
		@downstream[upstream_name] ||= {}
		@downstream[upstream_name][step.name] = value
	end

	def my_downstream step
		@downstream[step.name] || {}
	end

	def run!
		



		@main.run
	end

end
end
