Practical 8 — Fingerprint Sensor Interfacing

Terminal commands
sudo apt update
sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-serial
pip3 install adafruit-circuitpython-fingerprint
sudo raspi-config
sudo reboot
ls -l /dev/serial0
python3 enroll.py
code:
import time
import board
import adafruit_fingerprint
import serial

# Initialize fingerprint sensor
uart = serial.Serial("/dev/ttyUSB0", baudrate=57600, timeout=1)
finger = adafruit_fingerprint.Adafruit_Fingerprint(uart)


# Function to search fingerprint
def get_fingerprint():
    print("Waiting for image...")

    while finger.get_image() != adafruit_fingerprint.OK:
        pass

    print("Templating...")

    if finger.image_2_tz(1) != adafruit_fingerprint.OK:
        return False

    print("Searching...")

    if finger.finger_search() != adafruit_fingerprint.OK:
        return False

    return True


# Function to enroll fingerprint
def enroll_finger(location):
    for fingerimg in range(1, 3):

        if fingerimg == 1:
            print("Place finger on sensor...", end="")
        else:
            print("Place same finger again...", end="")

        while True:
            i = finger.get_image()

            if i == adafruit_fingerprint.OK:
                print("Image taken")
                break

            elif i == adafruit_fingerprint.NOFINGER:
                print(".", end="")

            else:
                print("Other error")
                return False

        print("Templating...", end="")

        i = finger.image_2_tz(fingerimg)

        if i == adafruit_fingerprint.OK:
            print("Templated")
        else:
            print("Other error")
            return False

        if fingerimg == 1:
            print("Remove finger")
            time.sleep(1)

            while finger.get_image() != adafruit_fingerprint.NOFINGER:
                pass

    print("Creating model...", end="")

    i = finger.create_model()

    if i == adafruit_fingerprint.OK:
        print("Created")
    else:
        print("Error")
        return False

    print(f"Storing model #{location}...", end="")

    i = finger.store_model(location)

    if i == adafruit_fingerprint.OK:
        print("Stored")
    else:
        print("Error!")
        return False

    return True


# Function to get fingerprint ID
def get_num():
    i = 0

    while (i > 127) or (i < 1):
        try:
            i = int(input("Enter ID # from 1-127: "))
        except ValueError:
            pass

    return i


# Main program
while True:

    if finger.read_templates() != adafruit_fingerprint.OK:
        raise RuntimeError("Failed to read templates")

    print("Fingerprint templates:", finger.templates)
    print("e - To enroll")
    print("f - To find")
    print("d - To delete")
    print("q - To quit")

    c = input("> ")

    if c == "e":
        if enroll_finger(get_num()):
            print("Stored successfully!")
        else:
            print("Enrollment failed!")

    elif c == "f":
        if get_fingerprint():
            print("Detected #", finger.finger_id)
        else:
            print("Finger not found")

    elif c == "d":
        if finger.delete_model(get_num()) == adafruit_fingerprint.OK:
            print("Deleted!")
        else:
            print("Failed to delete")

    elif c == "q":
        print("Exiting program...")
        break