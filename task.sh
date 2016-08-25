#!/bin/bash
trap '' SIGINT SIGQUIT SIGTSTP
bld=$(tput bold); 
nrm=$(tput sgr0);
grn=$(tput setaf 2);
red=$(tput setaf 1);
dim=$(tput dim);

source /home/user/Desktop/loadgen/scenarios/c
source ~/.bash_aliases

TASK_PATH=/home/user/Desktop/loadgen/snap/tasks

shopt -s expand_aliases


task="nothing"
penalty=20
pass=0

while :
do
  clear
echo "${bld}====[ Snap Task Launcher v"$scenario_number".0 ]======================="${nrm}
echo "                                                      "
echo "${grn}${bld}- Type the two digit number from the white list"
echo "  below to send data to a Grafana dashboard.       ${nrm}${grn}"
echo
echo "${bld}- In questions 2 and 3 you may need to switch "
echo "  to a different Grafana dashboard from the "
echo "  drop-down and run a task."
echo "  ${nrm}"
echo "  ${red}For this game, a 20-second timer will start"
echo "  after you run each task. ${nrm}" 
echo
echo "${bld}----[ Service Tasks ]---------------------------------${nrm}"
echo 
echo "${bld}- Facial Recognition Monitoring Tasks:                ${nrm}"
echo "   01) facial_recognition-rabbitmq${dim}.json${nrm}              "
echo "   02) facial_recognition-mysql${dim}.json${nrm}                  "
echo "   03) facial_recognition-HAproxy${dim}.json${nrm}                "
echo   
echo "${bld}- Authentication Performance Monitoring Tasks:        ${nrm}"
echo "   04) authentication-login-counters${dim}.json${nrm}            "
echo "   05) authentication-test2${dim}.json${nrm}                      "
echo 
echo "${bld}- Recommendation Engine Tasks:                        ${nrm}"
echo "   06) rec_engine-cache-status${dim}.json${nrm}                  "
echo "   07) rec_engine-compute-stats${dim}.json${nrm}                 "
echo
echo "${bld}----[ Data Center Tasks ]-----------------------------${nrm}"
echo 
echo "${bld}- Data Center 1 Stats:                                ${nrm}"
echo "   08) dc1-compute-stats${dim}.json${nrm}                         "
echo "   09) dc1-nodemanager${dim}.json${nrm}                          "
echo "   10) dc1-memory-usage${dim}.json${nrm}                         "
echo "   11) dc1-network_util${dim}.json${nrm}                          "
echo "   12) dc1-storage_nodes${dim}.json${nrm}                        "
echo 
echo "${bld}- Data Center 2 Stats:                                ${nrm}"
echo "   13) dc2-cpu+meminfo${dim}.json${nrm}                           "
echo "   14) dc2-network_util${dim}.json${nrm}                          "
echo "   15) dc2-storage-performance${dim}.json${nrm}                   "
echo 
echo "${bld}- Data Center 3 Stats:                                ${nrm}"
echo "   16) dc3-cpu+meminfo${dim}.json${nrm}                          "
echo "   17) dc3-network_util${dim}.json${nrm}                         "
echo "   18) dc3-storage-performance${dim}.json${nrm}                  " 
echo 
echo " Last task: [$task]."
echo
echo -n "${bld}- Enter the two-digit number of the Snap task to run: "${nrm}
  read -t 0.01 -n 1000 discard
echo
  read -n 2 -e
  echo
  case "$REPLY" in
  "01") task="Facial Recognition RabbitMQ Stats"; echo "  "$task;snaptask $TASK_PATH/fr_rmq.json;;
  "02") task="Facial Recognition MySQL Stats"; echo "  "$task;snaptask $TASK_PATH/fr_mysql.json;;
  "03") task="Facial Recognition HAProxy Stats"; echo "  "$task;snaptask $TASK_PATH/fr_ha.json;;
  "04") task="Auth Service Login Counters"; echo "  "$task;snaptask $TASK_PATH/au_srv1.json;;
  "05") task="Auth Service Test ";echo "  "$task;snaptask $TASK_PATH/au_srv2.json;;
  "06") task="Recommendation Engine Cache Status"; echo "  "$task;snaptask $TASK_PATH/re_srv1.json;;
  "07") task="Recommendation Engine Compute Time"; echo "  "$task;snaptask $TASK_PATH/re_srv2.json;;
  "08") task="Datacenter # 1 CPU Stats"; echo "  "$task;snaptask $TASK_PATH/fr_cpu.json;;
  "09") task="Datacenter # 1 Node Manager";echo "  "$task;snaptask $TASK_PATH/fr_node.json;;
  "10") task="Datacenter # 1 Memory Stats" echo "  "$task;snaptask $TASK_PATH/fr_mem.json;;
  "11") task="Datacenter # 1 Network Stats"; echo "  "$task;snaptask $TASK_PATH/fr_net.json;;
  "12") task="Datacenter # 1 Storage Stats"; echo "  "$task;snaptask $TASK_PATH/fr_disk.json;;
  "13") task="Datacenter # 2 CPU and Memory usage"; echo "  "$task;snaptask $TASK_PATH/dc2_cpumem.json;;
  "14") task="Datacenter # 2 Network Utilization"; echo "  "$task;snaptask $TASK_PATH/dc2_net.json;;
  "15") task="Datacenter # 2 Storage Performance"; echo "  "$task;snaptask $TASK_PATH/dc2_disk.json;;
  "16") task="Datacenter # 3 CPU and Memory usage"; echo "  "$task;snaptask $TASK_PATH/dc3_cpumem.json;;
  "17") task="Datacenter # 3 Network Utilization"; echo "  "$task;snaptask $TASK_PATH/dc3_net.json;;
  "18") task="Datacenter # 3 Storage Performance"; echo "  "$task;snaptask $TASK_PATH/dc3_disk.json;;
  "q!") break;;
  "**") scenario_number=0; cp scenarios/0 scenarios/c;pass=1;;
  "k!") snap/influxdb-grafana/kill.sh;;
  "r!") scenario_number=$(shuf -i 1-4 -n 1);cp scenarios/$scenario_number scenarios/c;pass=1;;
  *) echo;echo    "Invalid option";pass=1;sleep 1;;
  esac
echo

stty -echo
if [ $pass = 0 ]; then
   echo ${bld}"Task started. Data will be visible in the appropriate dashboard."${nrm}
for i in {1..20}
 do
   echo -ne ${red}"Please wait $(($penalty-$i)) seconds for the game timer.\033[0K\r"${nrm}
   sleep 1
done
fi
pass=0
stty echo

done
