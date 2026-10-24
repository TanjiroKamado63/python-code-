RASPBERRY PI TERMINAL COMMANDS
sudo apt update
sudo raspi-config
# Interface Options -> SPI -> Enable
sudo reboot
sudo apt install -y python3-pip python3-spidev
pip3 install mfrc522
nano write.py
python3 write.py
nano read.py
python3 read.py
5A. Write data to RFID tag
import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
reader = SimpleMFRC522()
print("Looking for cards")
print("Press Ctrl+c to STOP")
try:
    text = input("Enter New Data: ")
    print("Now place your tag to write")
    reader.write(text)
    print("Data Written Successfully")
finally:
    GPIO.cleanup()
5B. Read data from RFID tag
import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
reader = SimpleMFRC522()
print("Looking for cards")
print("Press Ctrl+c to STOP")
try:
    tag_id, text = reader.read()
    print(tag_id)
    print(text)
finally:
    GPIO.cleanup()