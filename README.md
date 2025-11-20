# [1] Start jobs as child processes:
### cmd 1: launch the right file
python3 -m taskmaster -f tests/01_test_child.yaml
### cmd 2: PID of taskmaster 
ps aux | grep taskmaster | grep -v grep
### cmd 3: PID of cmd
ps aux | grep "sleep 300" | grep -v grep
### cmd 4: see if PPID of cmd is taskmaster's one
ps -o pid,ppid,cmd -p <PID_CMD_3>


# [2] Keep child processes alive and restart:
### cmd 1:
python3 -m taskmaster -f tests/02_keep_child_processes_alive_and_restart.yaml
### check the logs -> child process is running & restart many times


# [3] Processes are alive or dead:
### cmd 1: (terminal 1)
python3 -m taskmaster -f tests/03_processes_are_alive_or_dead.yaml
### cmd 2: (check that the status is running) 
status
### cmd 3: (terminal 2)
ps aux | grep "sleep 300"
### cmd 4: (terminal 2) 
kill -9 <PID>
### cmd 5: (check that the status is now stopped) (terminal 1)
status

# [4] Configuration must be loaded at launch, and must be reloadable:
### cmd 1: 
python3 -m taskmaster -f tests/04_loaded_at_launch_and_must_be_reloadable.yaml
### comment: 
proof of launch by checking the logs file
### action required:
open the yaml file and add a new service above
### cmd 2: 
reload (should now be 2 services running instead of one)

# [5] Changing their monitoring conditions:
### cmd 1: 
python3 -m taskmaster -f tests/05_changing_their_monitoring_conditions.yaml
### action required:
- startretries: 5
- exitcodes: [0,1]
- autorestart: always
# [6] Changing their monitoring conditions:
### cmd 1:
python3 -m taskmaster -f tests/06_not_de_spawn.yaml
### action required:
- make a modification in the YAML file:
  modified_service:
    cmd: /bin/sleep 100
### cmd 2:
reload
### comment:
[!] Check in the logs that the PID only did changed for the service that ha've been modified

# [6] Changing their monitoring conditions:
### cmd 1: (terminal 1)
python3 -m taskmaster -f tests/06_not_de_spawn.yaml
### cmd 2: (take the PIDs) (terminal 2)
ps aux | grep "Je tourne tranquille"
### cmd 3: (terminal 1)
exit
### cmd 4: (nothing should appear anymore) (terminal 2)
ps aux | grep "Je tourne tranquille"

# [7] Stop time:
### cmd 1: (terminal 1)
python3 -m taskmaster -f tests/07_stoptime_validation.yaml
### cmd 2: (terminal 1) (wait 3 seconds)
stop stoptime_2sec
### cmd 3: (terminal 1) 
stop stoptime_5sec
### cmd 4: (terminal 1) 
stop stoptime_10sec
### action required:
check that the time took is right regarding the timestop

# [8] stderr & stdout redirect:
### cmd 1: (terminal 1)
python3 -m taskmaster -f tests/08_stdout_stderr_redirect.yaml
### cmd 2: (terminal 2)
cat /tmp/taskmaster_stdout.log
### cmd 3: (terminal 2)
cat /tmp/taskmaster_stderr.log
### cmd 4: (terminal 2)
cat /tmp/taskmaster_combined.log
### cmd 5: (terminal 2)
cat /tmp/taskmaster_only_stderr.log
### cmd 6: (terminal 2)
grep "This should disappear" /tmp/taskmaster_only_stderr.log

# [9] env:
### cmd 1:
python3 -m taskmaster -f tests/09_env.yaml
### cmd 2: check that env vars has been caried
cat /tmp/demo_env_output.log

# [10] working directory: 
### cmd 1:
python3 -m taskmaster -f tests/10_workingdir.yaml
### cmd 2:
cat /tmp/demo_workdir_output.log
### cmd 3:
ls /tmp/demo_file.txt

# [11] umask:
### cmd 1:
python3 -m taskmaster -f tests/11_umask.yaml
### cmd 2: (compare the 2 files)
ls -la /tmp/fichier_*.txt
### cmd 3: (regular file modification)
echo "TEST" > /tmp/fichier_normal.txt
cat /tmp/fichier_normal.txt
### cmd 4: (READONLY file modification)
echo "Attempt" > /tmp/fichier_readonly.txt
