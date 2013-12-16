disks = ["/dev/sdb", "/dev/sdc"]


def disk_temp d
	d.each do | dks |
		temp = `hddtemp #{dks} | awk -F: '{print $3}'`
		puts "#{dks} = #{temp}"
	end
end


disk_temp disks


