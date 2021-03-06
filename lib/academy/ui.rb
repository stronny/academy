module Academy
module UI

	class Back < Exception; end

	def self.menu title, opts = {}
		return nil if opts.count < 1
		return opts.keys.first if opts.count < 2
		whiptail [:menu, :notags, 'ok-button=Next', 'cancel-button=Back'], title, 0, 0, 0, *opts.flatten
	end

	def self.input title, default = nil
		args = [title, 0, 0]
		args += default if default
		whiptail [:inputbox, 'ok-button=Next', 'cancel-button=Back'], *args
	end

	def self.alert text
		whiptail [:msgbox], text, 0, 0
	end

protected

	def self.whiptail opts, *args
		cmd = ['whiptail']
		cmd += opts.map { |o| '--%s' % o.to_s }
		cmd.push '--'
		cmd += args.map { |a| a.to_s }

		status, out = IO.pipe do |r, w|
			pid = spawn *cmd, err: w
			w.close
			out = r.read
			pid, status = Process.wait2 pid
			[status, out]
		end

		raise Back if status.exitstatus > 0
		out
	end

end
end
