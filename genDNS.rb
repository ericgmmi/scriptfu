if ARGV.count != 2
	puts "USAGE: genDNS <FQDN> <IP>"
	abort("Need the FQDN and IP, brainiac...")
end

fqdn = ARGV[0].split(".")
ip = ARGV[1]
domain = "#{fqdn[0]}.#{fqdn[1]}"

puts domain
puts ip
date = Time.now
month = date.strftime("%m")

File.open(domain, 'a') {
	|file| 
		file.write("$TTL\t600\r\n")
		file.write("@\t\tIN SOA\tns2.moneymanagement.org.\t\tdomains (\r\n")
		file.write("\t\t\t\t#{date.year}#{month}#{date.day}01\t\t\t; serial\r\n")
		file.write("\t\t\t\t3H\t\t\t\t; refresh\r\n")
		file.write("\t\t\t\t15M\t\t\t\t; retry\r\n")
		file.write("\t\t\t\t1W\t\t\t\t; expiry\r\n")
		file.write("\t\t\t\t1D )\t\t\t\t; minimum\r\n")
		file.write("\r\n")
		file.write("@\t\t\tIN NS\tns2.moneymanagement.org.\r\n")
		file.write("@\t\t\tIN NS\tns1.moneymanagement.org.\r\n")
		file.write("@\t\t\tIN A\t#{ip}\r\n")
		file.write("www\t\t\tIN A\t#{ip}\r\n")
		file.write("*.#{domain}.\tIN A\t#{ip}\r\n")
}