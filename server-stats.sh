#!/bin/bash

# function to read the CPU usage
get_cpu_usage() {
	cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')
	echo "CPU: $cpu_usage   "
}

# function to read the RAM usage
get_ram_usage() {
	mem_info=$(free -h)

	used_ram=$(echo "$mem_info" | awk 'NR==2{print $3}')
	total_ram=$(echo "$mem_info" | awk 'NR==2{print $2}')

  used_ram_percentage=$(free -m | awk '/^Mem:/ {printf "%.2f%\n", $3/$2*100}')

	echo "Used RAM: $used_ram - $used_ram_percentage"
	echo "Total RAM: $total_ram"
}

# function to get the disk usage
#get_disk_usage() {}

# main funcion
main() {
	get_cpu_usage
	get_ram_usage
}

# verify the flag
if [[ "$1" == "--real-time" ]]; then
	while true; do
	  echo "Showing stats in real time... (CTRL+C to stop)"
		main

		sleep 2
    clear
	done
else
	main
fi
