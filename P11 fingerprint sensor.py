Practical 11 — Fingerprint Sensor + 16×2 I2C LCD

Terminal commands
sudo apt-get update && sudo apt-get install -y i2c-tools python3-pip python3-serial
pip3 install RPLCD adafruit-circuitpython-fingerprint smbus2
i2cdetect -y 1
python3 enroll.py
python3 main_verify.py

import time
import serial
import adafruit_fingerprint

uart = serial.Serial("/dev/serial0", baudrate=57600, timeout=1)
finger = adafruit_fingerprint.Adafruit_Fingerprint(uart)
location = int(input("Enter Slot ID (1-127): "))

print("Place finger on sensor...")
while finger.get_image() != adafruit_fingerprint.OK:
    pass
finger.image_2_tz(1)

print("Remove finger...")
time.sleep(2)
while finger.get_image() == adafruit_fingerprint.OK:
    pass

print("Place SAME finger again...")
while finger.get_image() != adafruit_fingerprint.OK:
    pass
finger.image_2_tz(2)

if finger.create_model() == adafruit_fingerprint.OK:
    if finger.store_model(location) == adafruit_fingerprint.OK:
        print(f"Enrolled successfully at Slot {location}!")
    else:
        print("Error saving template.")
else:
    print("Fingerprint mismatch. Try again.")

Code 2 — Fingerprint verification with LCD

import time
import serial
import adafruit_fingerprint
from RPLCD.i2c import CharLCD

lcd = CharLCD("PCF8574", 0x27, cols=16, rows=2)
uart = serial.Serial("/dev/serial0", baudrate=57600, timeout=1)
finger = adafruit_fingerprint.Adafruit_Fingerprint(uart)

def show(line1, line2=""):
    lcd.clear()
    lcd.cursor_pos = (0, 0)
    lcd.write_string(line1[:16])
    lcd.cursor_pos = (1, 0)
    lcd.write_string(line2[:16])

show("System Ready", "Place Finger")

while True:
    if finger.get_image() == adafruit_fingerprint.OK:
        show("Processing...", "Please Wait")
        if finger.image_2_tz(1) == adafruit_fingerprint.OK:
            if finger.finger_search() == adafruit_fingerprint.OK:
                show("RFID UID MATCHED", f"ID: {finger.finger_id}")
                time.sleep(3)
            else:
                show("RFID UID", "UNMATCHED")
                time.sleep(1.5)
                show("Access Denied", "")
                time.sleep(2)
        show("Place Finger", "")
    time.sleep(0.1)