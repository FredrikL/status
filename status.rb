require 'sys/uptime'
require 'paint'
include Sys

@disks = ["/dev/sdb", "/dev/sdc"]

def disk_temp 
	@disks.map do | dks |
		temp = `hddtemp #{dks} | awk -F: '{print $3}'`
		"#{dks} = #{temp}".chomp
	end
end

def mdhealth
	status = `cat /proc/mdstat`
	s = status.match(/(md[0-9]+)[\w\W]+?(\[[U_]+\])/s).captures
	"#{s[0]} -> #{s[1]}"
end

def cpu_temp
	s = `sensors | grep Core | awk -F: '{print $2}'`
	s.split("\n").map do |line| 
		parts = line.split(' ')
		parts.first
	end 
end

def uptime
	u = Uptime.dhms
	"#{u[0]} days, #{u[1]}:#{u[2]} "
end

def diskusage
	df = `df -h --total 2>/dev/null`
	lines = df.split("\n")
	points = [lines[1], lines[lines.length-2]]
	points.map do |p|
		parts = p.split(" ")
		"#{parts[5]} #{parts[2]} / #{parts[1]} (#{parts[4]})"
	end
end

def load
	l = `cat /proc/loadavg`
	p = l.split(" ")
	"#{p[0]} #{p[1]} #{p[2]}"
end

def mem
	o = `free`
	pt = o.split(" ")
	total = pt[7].to_i / 1024
	used = pt[8].to_i / 1024
	"#{used}mb / #{total}mb"
end

def banner
	u = "#{Paint["Uptime: ", :blue]} #{uptime}"
	u += (" " * (50-u.length))
	u += "#{Paint["Loadavg: ", :blue]} #{load}"
	puts u

	m = "#{Paint["Md health: ", :blue]} #{mdhealth}"
	m += (" " * (50-m.length))
	m += "#{Paint["Memusage: ", :blue]} #{mem}"
	puts m

	c = "#{Paint["Cpu temp: ", :blue]} "
	cpu_temp.each_with_index {|t, i| c+= "Core #{(i+1)}: #{t} " }
	puts c

	s = "#{Paint["Smart status: ", :blue]}"
	s += disk_temp.join(", ")
	puts s

	d = "#{Paint["Diskusage: ", :blue]}"
	d += diskusage.join(", ")
	puts d
end

banner