#!bin/bin/bash
#script2 due 15 febmidnight
echo "Witn the script"
#for 1st thread variable called step1 will contain the hostname.
step1=$(hostname)
#for 2nd thread variable called step2 will contain the fully qualified domain name.
step2=$(hostname -f)
#in step3 we will obtain all the ip address information of the hostname
step3=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2- | tr -d '""' )
#moving toards 4th command, In step 4, a variable will supply the hostname's IP address.
step4=$(hostname -I)
#step5 will provide us with system details
step5=$(df --output=avail / | awk 'NR==2{print $1}')
cat <<EQF
echo "the hostname's details are"
Report for:$step1
=================================
echo "The details of FQDM are"
FQDN:$step2
Operating System name and version:$step3
IP Address:$step4
Root Filesystem Free Space:$step5
================================
EQF
