Practical 19 — Embedded RFID/Fingerprint Access Control

Terminal commands
sudo apt update
sudo apt install -y python3-pip python3-serial python3-rpi.gpio i2c-tools
pip3 install RPLCD adafruit-circuitpython-fingerprint mfrc522
sudo raspi-config
sudo i2cdetect -y 1
python3 rfid_test.py
python3 enroll.py
nano access_control.py
python3 access_control.py

import RPi.GPIO as GPIO
import time
import csv
import os
import serial
from datetime import datetime
from RPLCD.i2c import CharLCD
from mfrc522 import SimpleMFRC522
import adafruit_fingerprint

RELAY = 23
LED = 21

GPIO.setmode(GPIO.BCM)
GPIO.setup(RELAY, GPIO.OUT)
GPIO.setup(LED, GPIO.OUT)
GPIO.output(RELAY, GPIO.HIGH)
GPIO.output(LED, GPIO.LOW)

lcd = CharLCD(
    i2c_expander="PCF8574",
    address=0x27,
    port=1,
    cols=16,
    rows=2,
    charmap="A00",
    auto_linebreaks=True
)

reader = SimpleMFRC522()
WHITELIST = [123456789, 987654321]

uart = serial.Serial("/dev/serial0", baudrate=57600, timeout=1)
finger = adafruit_fingerprint.Adafruit_Fingerprint(uart)

LOG_FILE = "access_log.csv"

def log_event(method, result):
    new_file = not os.path.exists(LOG_FILE)

    with open(LOG_FILE, "a", newline="") as file:
        writer = csv.writer(file)

        if new_file:
            writer.writerow(["Time", "Method", "Result"])

        writer.writerow([
            datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            method,
            result
        ])

def show_message(line1, line2=""):
    lcd.clear()
    lcd.write_string(line1[:16])

    if line2:
        lcd.cursor_pos = (1, 0)
        lcd.write_string(line2[:16])

def unlock(method):
    show_message("ACCESS GRANTED", method)
    GPIO.output(LED, GPIO.HIGH)
    GPIO.output(RELAY, GPIO.LOW)
    log_event(method, "GRANTED")

    time.sleep(5)

    GPIO.output(RELAY, GPIO.HIGH)
    GPIO.output(LED, GPIO.LOW)

def deny(method):
    show_message("ACCESS DENIED", method)
    GPIO.output(LED, GPIO.LOW)
    log_event(method, "DENIED")
    time.sleep(2)

def check_fingerprint():
    show_message("Place Finger")
    start = time.time()

    while time.time() - start < 5:
        result = finger.get_image()

        if result == adafruit_fingerprint.OK:
            break

        if result == adafruit_fingerprint.NOFINGER:
            time.sleep(0.1)
            continue

        return False
    else:
        return False

    show_message("Processing...")

    if finger.image_2_tz(1) != adafruit_fingerprint.OK:
        return False

    return finger.finger_search() == adafruit_fingerprint.OK

try:
    show_message("ACCESS CONTROL", "SYSTEM READY")
    time.sleep(2)

    while True:
        show_message("Scan RFID", "or Fingerprint")

        card_id, text = reader.read_no_block()

        if card_id:
            if card_id in WHITELIST:
                unlock("RFID")
            else:
                deny("RFID")

            time.sleep(1)
            continue

        if check_fingerprint():
            unlock("FINGERPRINT")

        time.sleep(1)

except KeyboardInterrupt:
    print("\nProgram stopped")

finally:
    GPIO.output(RELAY, GPIO.HIGH)
    GPIO.output(LED, GPIO.LOW)
    GPIO.cleanup()
    lcd.clear()