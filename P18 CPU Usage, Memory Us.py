Practical 18 — CPU Usage, Memory Usage and CPU Temperature

Terminal commands
sudo apt update
sudo apt install python3-psutil
nano test.py
python3 test.py


import psutil
import time

def get_cpu_temperature():
    """Read Raspberry Pi CPU temperature."""
    try:
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as file:
            temp = int(file.read()) / 1000.0
        return temp
    except (FileNotFoundError, ValueError):
        return None

while True:
    cpu_usage = psutil.cpu_percent(interval=1)
    memory_usage = psutil.virtual_memory().percent
    cpu_temp = get_cpu_temperature()

    print("--------------------------------")
    print(f"CPU Usage        : {cpu_usage:.1f}%")
    print(f"Memory Usage     : {memory_usage:.1f}%")

    if cpu_temp is not None:
        print(f"CPU Temperature : {cpu_temp:.1f} °C")
    else:
        print("CPU Temperature : Not available")

    print("--------------------------------")
    time.sleep(1)