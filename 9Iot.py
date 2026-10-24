RASPBERRY PI TERMINAL COMMANDS
sudo apt update
sudo apt install -y python3 python3-pip python3-serial
pip3 install adafruit-circuitpython-fingerprint
sudo raspi-config
# Enable hardware serial; disable serial login shell
sudo reboot
nano door_lock.py
python3 door_lock.py
Main door-lock verification program — source code

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
    uart = serial.Serial(
        "/dev/serial0",
        baudrate=57600,
        timeout=1
    )
    finger = adafruit_fingerprint.Adafruit_Fingerprint(uart)
    print("Fingerprint Door Lock System")
    print("Place Finger")
    while True:
        result = finger.get_image()
        if result == adafruit_fingerprint.OK:
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
                GPIO.output(RELAY_PIN, RELAY_OFF)
finally:
    GPIO.cleanup()