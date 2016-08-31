# docker-python-selenium-xvfb

Dockerfile for building MRTS/PYTHON-SELENIUM-XVFB image with Python, Selenium,
Chrome, XVFB, Requests and Records with PostgreSQL and Oracle support.

Have to use Chrome instead of Firefox because of a known
[Firefox/XVFB bug](https://github.com/seleniumhq/selenium-google-code-issue-archive/issues/5828).

# Usage

    docker build --tag=mrts/python-selenium-xvfb .
    docker tag mrts/python-selenium-xvfb:latest mrts/python-selenium-xvfb:v2.0
    docker login
    docker push mrts/python-selenium-xvfb
