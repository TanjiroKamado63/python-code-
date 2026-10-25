Practical 12 — Fingerprint Authenticated Door Lock

Terminal commandssudo apt update
sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-serial
pip3 install adafruit-circuitpython-fingerprint
sudo raspi-config
sudo reboot
ls -l /dev/serial0
python3 enroll.py
python3 door_lock.py

Code 1 — Enrollment
import serial
import time
import adafruit_fingerprint

uart = serial.Serial("/dev/serial0", baudrate=57600, timeout=1)
finger = adafruit_fingerprint.Adafruit_Fingerprint(uart)
finger_id = int(input("Enter fingerprint ID (1-127): "))

print("Place finger on sensor...")
while finger.get_image() != adafruit_fingerprint.OK:
    time.sleep(0.1)

if finger.image_2_tz(1) != adafruit_fingerprint.OK:
    print("Image conversion failed")
    raise SystemExit

print("Remove finger")
time.sleep(2)
print("Place the same finger again...")

while finger.get_image() != adafruit_fingerprint.OK:
    time.sleep(0.1)

if finger.image_2_tz(2) != adafruit_fingerprint.OK:
    print("Image conversion failed")
    raise SystemExit

if finger.create_model() != adafruit_fingerprint.OK:
    print("Fingerprints did not match")
    raise SystemExit

if finger.store_model(finger_id) == adafruit_fingerprint.OK:
    print("Fingerprint enrolled successfully")
else:
    print("Failed to store fingerprint")

Code 2 — Door lock verification
import serial
import time
import RPi.GPIO as GPIO
import adafruit_fingerprint

GPIO.setwarnings(False)
RELAY_PIN = 17
RELAY_ON = GPIO.LOW
RELAY_OFF = GPIO.HIGH

GPIO.setmode(GPIO.BCM)
GPIO.setup(RELAY_PIN, GPIO.OUT, initial=RELAY_OFF)

try:
    uart = serial.Serial("/dev/serial0", baudrate=57600, timeout=1)
    finger = adafruit_fingerprint.Adafruit_Fingerprint(uart)

    print("Fingerprint Door Lock System")
    print("Place Finger")

    while True:
        if finger.get_image() == adafruit_fingerprint.OK:
            print("Processing...")

            if finger.image_2_tz(1) != adafruit_fingerprint.OK:
                print("Fingerprint processing failed")
                time.sleep(1)
                continue

            if finger.finger_search() == adafruit_fingerprint.OK:
                print("Access Granted")
                GPIO.output(RELAY_PIN, RELAY_ON)
                print("Door Unlocked")
                time.sleep(5)
                GPIO.output(RELAY_PIN, RELAY_OFF)
                print("Door Locked")
            else:
                print("Access Denied")

            time.sleep(1)

except Exception as e:
    print("Communication error:", e)

finally:
    GPIO.output(RELAY_PIN, RELAY_OFF)
    GPIO.cleanup()