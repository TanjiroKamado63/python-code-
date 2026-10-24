RASPBERRY PI TERMINAL COMMANDS
sudo raspi-config
# Interface Options -> Serial Port
# Login shell over serial: No
# Enable serial hardware: Yes
sudo reboot
ls -l /dev/serial0
sudo apt update
sudo apt install -y minicom python3-serial
minicom -D /dev/serial0 -b 9600
Basic serial/NMEA reader
import serial
import time
gps = serial.Serial("/dev/serial0", baudrate=9600, timeout=1)
try:
    while True:
        line = gps.readline().decode("ascii", errors="replace").strip()
        if line:
            print(line)
        time.sleep(0.1)
finally:
    gps.close()