while :
do

for task in $(snapctl task list | grep "Disabled" | awk '{print $1}'); do snapctl task enable $task; snapctl task start $task; done

done

