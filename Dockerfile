# Dockerfile with Python, Selenium, Firefox, XVFB, Requests and Records with
# PostgreSQL and Oracle support

FROM ubuntu:xenial

# Latest Firefox
RUN echo 'deb http://ppa.launchpad.net/mozillateam/firefox-next/ubuntu xenial main' > /etc/apt/sources.list.d/mozillateam-firefox-next-xenial.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE49EC21 

# Install Ubuntu packages, libaio is required for Oracle drivers
RUN apt-get update
RUN apt-get install -y python-setuptools python-certifi libaio1 libaio-dev python-psycopg2 firefox xvfb
RUN apt-get autoremove
RUN apt-get clean

# Install Oracle drivers for Records, see README in debs/
ADD debs/ /root/debs/
RUN dpkg -i /root/debs/*.deb
RUN rm /root/debs/*.deb

# Oracle library configuration
ENV ORACLE_HOME /usr/lib/oracle/12.1/client64
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.1/client64/lib
RUN echo "/usr/lib/oracle/12.1/client64/lib" > /etc/ld.so.conf.d/oracle.conf
RUN ldconfig

# Install Python packages
RUN easy_install selenium xvfbwrapper unittest2 cx_oracle records requests
