#!/bin/python
# -*- coding: utf-8 -*-

# Procedure
# Surf to https://openweathermap.org/city
# Fill in your CITY
# e.g. Antwerp Belgium
# Check url
# https://openweathermap.org/city/2803138
# you will the city code at the end
# create an account on this website
# create an api key (free)
# LANG included thanks to krive001 on discord


import requests

CITY = "2946447"
API_KEY = "756edce7e9d4c385ef9499a53492678c"
UNITS = "Metric"
UNIT_KEY = "C"
#UNIT_KEY = "F"
LANG = "de"
#LANG = "nl"
#LANG = "hu"

REQ = requests.get("http://api.openweathermap.org/data/2.5/weather?id={}&lang={}&appid={}&units={}".format(CITY, LANG,  API_KEY, UNITS))
try:
    # HTTP CODE = OK
    if REQ.status_code == 200:
        CURRENT = REQ.json()["weather"][0]["description"].capitalize()
        TEMP = int(float(REQ.json()["main"]["temp"]))
        if CURRENT == "Klarer himmel":
            CURRENT = ""
        elif CURRENT == "Bedeckt":
            CURRENT = ""
        elif CURRENT == "Mäßig bewölkt":
            CURRENT = ""
        elif CURRENT == "Überwiegend bewölkt":
            CURRENT = ""
        elif CURRENT == "Gewitter":
            CURRENT = ""
        elif CURRENT == "Sonnig":
            CURRENT = ""

        print("{} {} °{}".format(CURRENT, TEMP, UNIT_KEY))
    else:
        print("Error: BAD HTTP STATUS CODE " + str(REQ.status_code))
except (ValueError, IOError):
    print("Error: Unable print the data")
