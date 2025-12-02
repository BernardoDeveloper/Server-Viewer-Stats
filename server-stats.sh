#!/bin/bash

# function to read the CPU usage
get_cpu_usage() {
	cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')
	echo -ne "\rUso de CPU: $cpu_usage   "
}

# main funcion
main() {
	get_cpu_usage
}

# verify the flag
if [[ "$1" == "--not-stop" ]]; then
	echo "Monitorando CPU em tempo real... (CTRL+C para parar)"

	while true; do
		main
		sleep 1
	done
else
	main
fi
