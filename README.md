## [0] Setup Docker environment:
### cmd 1:
```bash
docker-compose up -d
```

### cmd 2:
```bash
docker exec -it taskmaster bash
```

### cmd 3:
```bash
python3 -m venv ./venv
```
### cmd 4:
```bash
source ./venv/bin/activate
```

### cmd 5:
```bash
pip install -r ./requirements.txt
```

<br>

## [1] Start jobs as child processes:

### cmd 1: launch the right file
```bash
python3 -m taskmaster -f tests/01_test_child.yaml
```
### cmd 2: PID of taskmaster
```bash
ps aux | grep taskmaster | grep -v grep
```
### cmd 3: PID of cmd
```bash
ps aux | grep "sleep 300" | grep -v grep
```
### cmd 4: see if PPID of cmd is taskmaster's one
```bash
ps -o pid,ppid,cmd -p <PID_CMD_3>
```

<br>

## [2] Keep child processes alive and restart:

### cmd 1:
```bash
python3 -m taskmaster -f tests/02_keep_child_processes_alive_and_restart.yaml
```
> check the logs -> child process is running & restart many times

<br>

## [3] Processes are alive or dead:

### cmd 1: (terminal 1)
```bash
python3 -m taskmaster -f tests/03_processes_are_alive_or_dead.yaml
```

### cmd 2: (check that the status is running) 
```bash
status
```

### cmd 3: (terminal 2)
```bash
ps aux | grep "sleep 300"
```

### cmd 4: (terminal 2) 
```bash
kill -9 <PID>
```

### cmd 5: (check that the status is now stopped) (terminal 1)
```bash
status
```

<br>

## [4] Configuration must be loaded at launch, and must be reloadable:

### cmd 1: 
```bash
python3 -m taskmaster -f tests/04_loaded_at_launch_and_must_be_reloadable.yaml
```
> proof of launch by checking the logs file

Open the yaml file and add a new service above

### cmd 2: 
```bash
reload # (should now be 2 services running instead of one)
```

<br>

## [5] Changing their monitoring conditions:
### cmd 1: 
```bash
python3 -m taskmaster -f tests/05_changing_their_monitoring_conditions.yaml
```

### action required:
- startretries: 5
- exitcodes: [0,1]
- autorestart: always

<br>

## [6] Changing their monitoring conditions:

### cmd 1:
```bash
python3 -m taskmaster -f tests/06_not_de_spawn.yaml
```

### action required:
- make a modification in the YAML file:
  modified_service:
    cmd: /bin/sleep 100

### cmd 2:
```bash
reload
```
> [!] Check in the logs that the PID only did changed for the service that ha've been modified

<br>

## [6] Changing their monitoring conditions:

### cmd 1: (terminal 1)
```bash
python3 -m taskmaster -f tests/06_not_de_spawn.yaml
```

### cmd 2: (take the PIDs) (terminal 2)
```bash
ps aux | grep "Je tourne tranquille"
```

### cmd 3: (terminal 1)
```bash
exit
```

### cmd 4: (nothing should appear anymore) (terminal 2)
```bash
ps aux | grep "Je tourne tranquille"
```

<br>

## [7] Stop time:

### cmd 1: (terminal 1)
```bash
python3 -m taskmaster -f tests/07_stoptime_validation.yaml
```

### cmd 2: (terminal 1) (wait 3 seconds)
```bash
stop stoptime_2sec
```

### cmd 3: (terminal 1) 
```bash
stop stoptime_5sec
```

### cmd 4: (terminal 1) 
```bash
stop stoptime_10sec
```
> check that the time took is right regarding the timestop

<br>

## [8] stderr & stdout redirect:

### cmd 1: (terminal 1)
```bash
python3 -m taskmaster -f tests/08_stdout_stderr_redirect.yaml
```

### cmd 2: (terminal 2)
```bash
cat /tmp/taskmaster_stdout.log
```

### cmd 3: (terminal 2)
```bash
cat /tmp/taskmaster_stderr.log
```

### cmd 4: (terminal 2)
```bash
cat /tmp/taskmaster_combined.log
```

### cmd 5: (terminal 2)
```bash
cat /tmp/taskmaster_only_stderr.log
```

### cmd 6: (terminal 2)
```bash
grep "This should disappear" /tmp/taskmaster_only_stderr.log
```

<br>

## [9] env:

### cmd 1:
```bash
python3 -m taskmaster -f tests/09_env.yaml
```

### cmd 2: check that env vars has been caried
```bash
cat /tmp/demo_env_output.log
```

<br>

## [10] working directory: 

### cmd 1:
```bash
python3 -m taskmaster -f tests/10_workingdir.yaml
```

### cmd 2:
```bash
cat /tmp/demo_workdir_output.log
```

### cmd 3:
```bash
ls /tmp/demo_file.txt
```

<br>

## [11] umask:

### cmd 1:
```bash
python3 -m taskmaster -f tests/11_umask.yaml
```

### cmd 2: (compare the 2 files)
```bash
ls -la /tmp/fichier_*.txt
```

### cmd 3: (regular file modification)
```bash
echo "TEST" > /tmp/fichier_normal.txt
cat /tmp/fichier_normal.txt
```

### cmd 4: (READONLY file modification)
```bash
echo "Attempt" > /tmp/fichier_readonly.txt
```
