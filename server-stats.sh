#!/bin/bash

# function to read the CPU usage
get_cpu_usage() {
	cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')
	echo "CPU: $cpu_usage   "
  echo
}

# function to read the RAM usage
get_ram_usage() {
	mem_info=$(free -h)

	used_ram=$(echo "$mem_info" | awk 'NR==2{print $3}')
	total_ram=$(echo "$mem_info" | awk 'NR==2{print $2}')

  used_ram_percentage=$(free -m | awk '/^Mem:/ {printf "%.2f%\n", $3/$2*100}')

	echo "Used RAM: $used_ram - $used_ram_percentage"
	echo "Total RAM: $total_ram"

  echo
}

# function to get the disk usage
get_disk_usage() {
  used_disk_percentage=$(df -h 2>/dev/null | grep drivers | awk '{print $5}') # 2>/dev/null -> ignore errors and only show the normal output
  echo "Used DISK main driver: $used_disk_percentage" 

  used_disk_memory=$(df -h 2>/dev/null | grep drivers | awk '{print $3}')
  echo "Total DISK: $used_disk_memory"

  echo
}

# get top 5 process
# parameter type: cpu || ram
get_top_proccess() {
  local type=$1

  if [[ "$type" == "cpu" ]]; then
    echo -e "TOP 5 CPU process\n"
    
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
  elif [[ "$type" == "ram" ]]; then
    echo -e "\n\nTOP 5 RAM process\n"

    ps aux --sort -%mem | head -n 6
  else
    echo "[error] in function get_top_proccess need use as parameter ram or cpu"
  fi
}

# main funcion
main() {
	get_cpu_usage
	get_ram_usage
  get_disk_usage

  echo -e "\n==============================================================\n"
  echo -e "\t\t\tTOP 5 PROCESS"
  echo -e "\n==============================================================\n"

  get_top_proccess cpu
  get_top_proccess ram
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
