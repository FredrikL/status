require 'sys/uptime'
require 'paint'
require 'influxdb'
include Sys

@influxdb = InfluxDB::Client.new "umz_stats", :username => "root", :password => "root"

@disks = ["/dev/sdb", "/dev/sdc"]

def disk_temp 

	@disks.each do | dks |
		temp = `hddtemp #{dks} | awk -F: '{print $3}'`
    temp = temp.chomp[0..-3]
		#"#{dks} = #{temp}".chomp
    data = {
      :temp => temp.to_f,
      :disk => dks
    }

    @influxdb.write_point("disks", data)
	end
end

def mdhealth
	status = `cat /proc/mdstat`
	s = status.match(/(md[0-9]+)[\w\W]+?(\[[U_]+\])/s).captures
	"#{s[0]} -> #{s[1]}"
  data = {
    :status => s[1],
    :array=> s[0]
  }

  @influxdb.write_point("md", data)
end

def cpu_temp
	s = `sensors | grep Core | awk -F: '{print $2}'`
	s.split("\n").each_with_index do |line, index| 
		parts = line.split(' ')
		 temp = parts.first
     data = {
      :temp => temp[0..-3].to_f,
      :core => index+1
    }

    @influxdb.write_point("cpu", data)
	end 
end

def diskusage
	df = `df --total 2>/dev/null`
	lines = df.split("\n")
	points = [lines[1], lines[lines.length-2]]
	points.each do |p|
		parts = p.split(" ")
		"#{parts[5]} #{parts[2]} / #{parts[1]} (#{parts[4]})"
     data = {
      :usedp => parts[4][0..-2].to_i,
      :used => parts[2].to_i,
      :disk => parts[5]
    }

    @influxdb.write_point("space", data)
	end
end

def load
	l = `cat /proc/loadavg`
	p = l.split(" ")
	"#{p[0]} #{p[1]} #{p[2]}"
  data = {
    :one => p[0].to_f,
    :five => p[1].to_f,
    :fifteen => p[2].to_f
  }

  @influxdb.write_point("load", data)
end

def mem
	o = `free -b`
	pt = o.split(" ")
	total = pt[7].to_i / 1024
	used = pt[8].to_i / 1024
	"#{used}mb / #{total}mb"
  data = {
    :value => pt[15].to_i
  }

  @influxdb.write_point("mem", data)
end

disk_temp
diskusage
cpu_temp
mdhealth
load
mem
