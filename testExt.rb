require 'socket'
require 'timeout'
require 'colorize'

rules = ARGV[0]

File.open(rules) do |f|
	f.each_line do |line|
		line.gsub! "\r", ""
		line.strip!
		ipport = line.split(" : ")
		ip = ipport[0]
		port = ipport[1]
		begin
			timeout(3) do
				if s = TCPSocket.open(ip, port)
					puts "#{ip} connected on port #{port}".green
					s.close
				end
			end
		rescue
			Errno::ECONNREFUSED
			puts "#{ip} #{port} - DOWN".red
		end
		
	end
end
