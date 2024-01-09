import queue
import subprocess
import sys
import threading
from time import sleep

ARGS = sys.argv[1]

def startExe(q):
    print("Thread_exe started")
    process = subprocess.Popen(["D:/TAD/bds-ui/BDS/bedrock_server.exe"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.PIPE, shell=True)
    print("Process started")
    
    def read_output(process_local):
        while True:
            line = process_local.stdout.readline()
            if line == None:
                break
            else:
                print(line.decode("utf-8").strip())

    def write_input(process_local):
        print("Thread_write started")
        while True:
            cmd = q.get()
            if cmd == "stop":
                process_local.stdin.write(b"stop\n")
                process_local.stdin.flush()  # Ensure the command is sent immediately
                break

    # Start threads for reading output and writing input
    threading.Thread(target=read_output, args=(process,)).start()
    threading.Thread(target=write_input, args=(process,)).start()

def getInput(q):
    print("Thread_input started")
    while True:
        user_input = input("")
        if user_input == "stop":
            q.put("stop")
            sleep(0.5)
            break

def main():
    match ARGS:
        
    
    
main()