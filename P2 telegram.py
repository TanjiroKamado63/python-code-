Practical 2 — Telegram Control of GPIO

Terminal commands:

sudo apt-get install idle
python3 -m pip install telepot
nano test.py
python3 test.py

import time
import datetime
import RPi.GPIO as GPIO
import telepot
from telepot.loop import MessageLoop

green = 2
yellow = 3
red = 4
blue = 17

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

for pin in [blue, yellow, red, green]:
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin, GPIO.LOW)

def action(msg):
    chat_id = msg["chat"]["id"]
    command = msg["text"].lower()
    print("Received: {}".format(command))

    if "on" in command:
        message = "On "
        if "blue" in command or "all" in command:
            GPIO.output(blue, GPIO.HIGH)
            message += "blue "
        if "yellow" in command or "all" in command:
            GPIO.output(yellow, GPIO.HIGH)
            message += "yellow "
        if "red" in command or "all" in command:
            GPIO.output(red, GPIO.HIGH)
            message += "red "
        if "green" in command or "all" in command:
            GPIO.output(green, GPIO.HIGH)
            message += "green "
        telegram_bot.sendMessage(chat_id, message + "light(s)")

    elif "off" in command:
        message = "Off "
        if "blue" in command or "all" in command:
            GPIO.output(blue, GPIO.LOW)
            message += "blue "
        if "yellow" in command or "all" in command:
            GPIO.output(yellow, GPIO.LOW)
            message += "yellow "
        if "red" in command or "all" in command:
            GPIO.output(red, GPIO.LOW)
            message += "red "
        if "green" in command or "all" in command:
            GPIO.output(green, GPIO.LOW)
            message += "green "
        telegram_bot.sendMessage(chat_id, message + "light(s)")

telegram_bot = telepot.Bot("YOUR_BOT_TOKEN")
MessageLoop(telegram_bot, action).run_as_thread()

try:
    while True:
        time.sleep(10)
except KeyboardInterrupt:
    GPIO.cleanup()