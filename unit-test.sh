#! /bin/bash

resp=$(curl http://app:8885/ -Is | grep -c "HTTP/1.1 200")
while [[ resp -ne 1 ]]
do
    if [[ resp -eq 1 ]]; then
		echo "pass"
		exit 0
	fi
    sleep 2
	resp=$(curl http://app:8885/ -Is | grep -c "HTTP/1.1 200")
done