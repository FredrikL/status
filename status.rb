disks = ["/dev/sdb", "/dev/sdc"]

def disk_temp d
	d.each do | dks |
		temp = `hddtemp #{dks} | awk -F: '{print $3}'`
		puts "#{dks} = #{temp}"
	end
end

def mdhealth

end

def cpu_temp
	s = `sensors | grep Core | awk -F: '{print $2}'`
	s.split("\n").each do |line| 
		parts = line.split(' ')
		puts parts.first
	end 
end


disk_temp disks
mdhealth
cpu_temp

