#!/bin/bash
	#shell script to turn off linux system from remote #dropbox #cron
	# v 1.1 | git.sbamin.com
	#Adapted from source: http://www.webupd8.org/2010/05/script-to-close-dropbox-after.html
	#Original script at https://github.com/hur1can3/dotfiles/blob/master/scripts/check-dropbox.sh

echo "Initiate shutdown script for LinuxBox"
echo "$(date) $line"
status=$(dropbox status)

sleep 2

if [ "$status" = "Dropbox isn't running!" ]
then
	dropbox start

	declare -i attempt=0
	declare -i ATTEMPT_MAX=900	# 900 attempts gives us about 2 minutes
					# to get a connection. Also used to debug.
	sleep 5

	# Withing 5 seconds of invoking 'dropbox start', the status should be
	# at least 'Connecting...' or beyond. In this loop, we give dropbox 2
	# minutes to leave that state, otherwise we assume a problem and exit.
	while test "$status" = 'Connecting...'

	do
	  (( attempt++ ))
	  status=$(dropbox status)
	  echo $attempt
	  if [ "$attempt" -eq "$ATTEMPT_MAX" ]
	  then
	    dropbox stop
	    killall dropbox
	    echo "No connection after 2 minutes of trying.. giving up."
	    echo "$(date) $line"
	    exit 0
	  fi
	done

	sleep 2

	# After the 'Connecting...' phase, many other status' are possible.
	# Instead of testing for them all, we just wait for 'Idle'. But to
	# be safe, we also need to check for 'Connecting...', 'Dropbox isn't
	# running!' or 'Dropbox isn't responding!'  as dropbox can regress
	# if it doesn't connect. For these latter cases we want to exit also. 
	status=$(dropbox status)
	attempt=0
	echo "Waiting on Idle status"
	while test "$status" != 'Idle'

	do
	  ((   attempt++ ))			#Just used for debugging.
	  status=$(dropbox status)
	  if [ "$status" = 'Connecting...' ]
	  then
	      dropbox stop
	      killall dropbox
	      echo "No connection.. giving up."
	      echo "$(date) $line"
	      exit 0
	  elif [ "$status" = "Dropbox isn't running!" ]
	  then
	    dropbox stop
	    killall dropbox
	    echo "Dropbox not running - reported."
	    echo "$(date) $line"
	    exit 0
	  elif [ "$status" = "Dropbox isn't responding!" ]
	  then
	    killall dropbox
	    echo "Dropbox isn't responding to us anymore. Exiting.."
	    echo "$(date) $line"
	    exit 0
	  fi
	  echo "$attempt"
	done

	sleep 2
	echo "Invoking conditional system shutdown..."

	sleep 2

	if [ -f /home/user/Dropbox/begin_shutdown.txt ];
	then
		echo "Shutdown command found, system will shut down after 2 minutes"
		echo "$(date) $line"
		notify-send -u critical -t 10000 -i /home/user/Pictures/caution.png "System will poweroff in 2 minute. To override, make ~/Dropbox/stop.txt"
		sleep 60
		notify-send -u critical -t 10000 -i /home/user/Pictures/caution.png "System will poweroff in 1 minute. To override, make ~/Dropbox/stop.txt"
		sleep 60
			if [ -f /home/user/Dropbox/stop.txt ];
			then
				echo "Shutdown command aborted, now exiting cron job"
				echo "$(date) $line"
				cp /home/user/shutdown_log.txt /home/user/Dropbox/shutdown_log.txt
				exit 0
			else
				echo "Now powering off the system"
				echo "$(date) $line"
				echo "Good bye!"
				cp /home/user/shutdown_log.txt /home/user/Dropbox/shutdown_log.txt
				cp /home/user/Dropbox/begin_shutdown.txt /home/user/Dropbox/stop.txt
				sleep 5
				echo "$(date) $line" | mutt -s "shudown status - `date`" user@domain -a /home/user/shutdown_log.txt
				sleep 5
				sudo poweroff
			fi		
	else
		echo "Shutdown command not executed, now exiting cron job"
		echo "$(date) $line"
		cp /home/user/shutdown_log.txt /home/user/Dropbox/shutdown_log.txt
		exit 0
	fi
else
	declare -i attempt=0
	declare -i ATTEMPT_MAX=900

	status=$(dropbox status)
	attempt=0
	echo "Waiting on Idle status"
	while test "$status" != 'Idle'

	do
	  ((   attempt++ ))			#Just used for debugging.
	  status=$(dropbox status)
	  if [ "$status" = 'Connecting...' ]
	  then
	      dropbox stop
	      killall dropbox
	      echo "No connection.. giving up."
	      echo "$(date) $line"
	      exit 0
	  elif [ "$status" = "Dropbox isn't running!" ]
	  then
	    dropbox stop
	    killall dropbox
	    echo "Dropbox not running - reported."
	    echo "$(date) $line"
	    exit 0
	  elif [ "$status" = "Dropbox isn't responding!" ]
	  then
	    killall dropbox
	    echo "Dropbox isn't responding to us anymore. Exiting.."
	    echo "$(date) $line"
	    exit 0
	  fi
	  echo "$attempt"
	done

	sleep 2
	echo "Invoking conditional system shutdown..."

	sleep 2

	if [ -f /home/user/Dropbox/begin_shutdown.txt ];
	then
		echo "Shutdown command found, system will shut down after 2 minutes"
		echo "$(date) $line"
		notify-send -u critical -t 10000 -i /home/user/Pictures/caution.png "System will poweroff in 2 minute. To override, make ~/Dropbox/stop.txt"
		sleep 60
		notify-send -u critical -t 10000 -i /home/user/Pictures/caution.png "System will poweroff in 1 minute. To override, make ~/Dropbox/stop.txt"
		sleep 60
			if [ -f /home/user/Dropbox/stop.txt ];
			then
				echo "Shutdown command aborted, now exiting cron job"
				echo "$(date) $line"
				cp /home/user/shutdown_log.txt /home/user/Dropbox/shutdown_log.txt
				exit 0
			else
				echo "Now powering off the system"
				echo "$(date) $line"
				echo "Good bye!"
				cp /home/user/shutdown_log.txt /home/user/Dropbox/shutdown_log.txt
				cp /home/user/Dropbox/begin_shutdown.txt /home/user/Dropbox/stop.txt
				sleep 5
				echo "$(date) $line" | mutt -s "shudown status - `date`" user@domain -a /home/user/shutdown_log.txt
				sleep 5
				sudo poweroff
			fi		
	else
		echo "Shutdown command not executed, now exiting cron job"
		echo "$(date) $line"
		cp /home/user/shutdown_log.txt /home/user/Dropbox/shutdown_log.txt
		exit 0
	fi
fi
#end
