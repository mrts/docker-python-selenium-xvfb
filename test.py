from xvfbwrapper import Xvfb
from selenium import webdriver

import requests

import psycopg2
import cx_Oracle
import records


def main():
    with Xvfb(width=3880, height=1189, colordepth=24) as xvfb:
        browser = webdriver.Chrome()
        browser.get('http://google.com/')


if __name__ == '__main__':
    main()

