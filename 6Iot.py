RASPBERRY PI TERMINAL COMMANDS
sudo apt update
sudo apt install -y i2c-tools python3-smbus python3-pip
sudo raspi-config
# Interface Options -> I2C -> Enable
sudo reboot
i2cdetect -y 1
pip3 install RPLCD
nano lcd_test.py
python3 lcd_test.py
LCD test code
code:
from RPLCD.i2c import CharLCD
from time import sleep
lcd = CharLCD('PCF8574', 0x27)  # Change to 0x3F if needed
lcd.write_string("Hello from Pi 400!")
sleep(3)
lcd.clear()
