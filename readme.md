Status.rb
====

Simple script that displays system health, gets info from lm-sensors, hddtemp, /proc/mdstat and other sources. Run during logon to highlight possible problems with system

Example output:
```
Uptime:  1 days, 22:12                   Loadavg:  0.01 0.04 0.05
Md health:  md0 -> [UU]                  Memusage:  2685mb / 3813mb
Cpu temp:  Core 1: +30.0°C Core 2: +34.0°C
Smart status: /dev/sdb =  29°C, /dev/sdc =  29°C
Diskusage: / 5,2G / 70G (8%), /data 297G / 1,9T (16%)
```

Prerequisites
==
Ruby (only tested with 2.0)  
[lm-sensors](http://lm-sensors.org/)  
[hddtemp](https://savannah.nongnu.org/projects/hddtemp/), make sure that [setuid](http://en.wikipedia.org/wiki/Setuid) flag is set

Run
==
bundle exec ruby status.rb

