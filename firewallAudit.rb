if (ARGV.count != 2)
	abort("Usage: ruby firewallAudit.rb <ACL File> <Mode>\r\n\t<ACL File> Text file with the ASA output of the \"show access-list <access-list name> command\"\r\n\t<Mode> 0: Searches for hitcnt=0 acls\r\n\t<Mode> 1: Searches for acls with a hitcnt\r\n")
end

ACLFile = ARGV[0]
Mode = ARGV[1]
hostPort = Array.new

File.open(ACLFile) do |f|
	f.each_line do |acl|
		acl.gsub! /line [0-9]+ /, ""
		acl.gsub! /0x.*$/,""
		fullAcl = acl.split " "
		host = fullAcl[fullAcl.index("eq") - 1] unless !acl.match(/eq/)
		port = fullAcl[fullAcl.index("eq") + 1] unless !acl.match(/eq/)
		if (host) && (port)
			if Mode == "0"
				puts "no #{acl}".gsub /\(hitcnt=0\).*/,"" if (acl['hitcnt=0']) && !acl.match(/^\s\s/) && !acl.match(/icmp/)
			end
			if Mode == "1"
				if !host.match(/any/)
					 hostPort.push("#{host} : #{port}") unless !acl.match(/eq/) || !host.match(/[0-9].+\.[0-9].+\.[0-9].+\.[0-9].+/)
				end
			end
		end
	end
end

if (hostPort)
	hostPort = hostPort.uniq
	hostPort.each do |hP|
		puts hP
	end
end