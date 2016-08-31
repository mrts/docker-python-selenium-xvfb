# Dockerfile with Python, Selenium, Chrome, XVFB, Requests and Records with
# PostgreSQL and Oracle support

FROM ubuntu:xenial

# Install Ubuntu packages, libaio is required for Oracle drivers
# (as each RUN commits the layer to image, need to chain commands and
# clean up in the end to keep the image small)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        libaio1 libaio-dev \
        python-certifi \
        python-psycopg2 \
        python-setuptools \
        xvfb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Install chromdriver
RUN mkdir /root/chromedriver && cd /root/chromedriver && \
    curl -O http://chromedriver.storage.googleapis.com/2.23/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    chmod +x chromedriver && \
    mv chromedriver /usr/local/bin && \
    rm chromedriver_linux64.zip

# Install Oracle drivers for Records, see README in debs/
RUN mkdir /root/debs && cd /root/debs && \
    curl -O https://media.githubusercontent.com/media/mrts/docker-python-selenium-xvfb/master/debs/oracle-instantclient12.1-basic_12.1.0.1.0-2_amd64.deb && \
    curl -O https://media.githubusercontent.com/media/mrts/docker-python-selenium-xvfb/master/debs/oracle-instantclient12.1-devel_12.1.0.1.0-2_amd64.deb && \
    dpkg -i *.deb && \
    rm *.deb

# Oracle library configuration
ENV ORACLE_HOME /usr/lib/oracle/12.1/client64
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.1/client64/lib
RUN echo "/usr/lib/oracle/12.1/client64/lib" > /etc/ld.so.conf.d/oracle.conf
RUN ldconfig

# Install Chrome and Python packages
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list && \
    curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    mkdir -p /usr/share/icons/hicolor && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        google-chrome-stable && \
    apt-get install -y \
        python-pip && \
    pip install \
        cx_oracle \
        records \
        requests \
        selenium \
        unittest2 \
        xvfbwrapper && \
    apt-get purge -y python-pip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Verify that everything works
COPY test.py /root/
RUN python /root/test.py
