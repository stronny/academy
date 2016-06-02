require 'open3'

module Academy
module UI

	def self.menu title, opts = {}
		return nil if opts.count < 1
		return opts.keys.first if opts.count < 2
		opt = whiptail [:menu, :nocancel, :notags], title, 0, 0, 0, *opts.flatten
	end

protected

	def self.whiptail opts, *args
		cmd = ['whiptail']
		cmd += opts.map { |o| '--%s' % o.to_s }
		cmd.push '--'
		cmd += args.map { |a| a.to_s }
#		el = Open3.popen3(*cmd) do |i, o, e, t|
#			t.value
#		end

#		p el

	end

end
end
