require 'sys/uptime'
include Sys

disks = ["/dev/sdb", "/dev/sdc"]

def disk_temp d
	d.each do | dks |
		temp = `hddtemp #{dks} | awk -F: '{print $3}'`
		puts "#{dks} = #{temp}"
	end
end

def mdhealth
	status = `cat /proc/mdstat`
	s = status.match(/(md[0-9]+)[\w\W]+?(\[[U_]+\])/s).captures
	puts "#{s[0]} -> #{s[1]}"
end

def cpu_temp
	s = `sensors | grep Core | awk -F: '{print $2}'`
	s.split("\n").each do |line| 
		parts = line.split(' ')
		puts parts.first
	end 
end

def uptime
	u = Uptime.dhms
	puts "#{u[0]} days, #{u[1]}:#{u[2]} "
end

def diskusage
	df = `df -h --total 2>/dev/null`
	lines = df.split("\n")
	points = [lines[1], lines[lines.length-2]]
	points.each do |p|
		parts = p.split(" ")
		puts "#{parts[5]} #{parts[2]}/#{parts[2]} (#{parts[4]})"
	end
end

disk_temp disks
mdhealth
cpu_temp
uptime
diskusage