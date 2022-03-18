FROM debian:latest

CMD ["crond", "-f"]

#RUN echo -e "* * * * * cd /retropilot-server/; node -r esm worker.js\n* * * * * cd /retropilot-server; node -r esm server.js" > /etc/crontabs/root 

# Create the log file to be able to run tail
#RUN touch /var/log/cron.log

# Install dependencies
RUN apt update
RUN apt install -y git nodejs npm python3
# TODO maybe install nodejs-npm?

RUN npm config set python /usr/bin/python3

# Install Retropilot
RUN git clone "https://github.com/florianbrede-ayet/retropilot-server.git"; cd retropilot-server; npm install --build-from-source --python=/usr/bin/python3

# Install node packages, even though we should have it through retropilot...
RUN npm install --build-from-source --python=/usr/bin/python3 -g esm

RUN cd retropilot-server; npm i esm
# Remove build dependencies
#RUN apk del git

RUN cd retropilot-server; cp config.sample.js config.js

RUN cd retropilot-server; cp database.empty.sqlite database.sqlite

ADD start.sh /retropilot-server/
RUN chmod +x /retropilot-server/start.sh

CMD ["/retropilot-server/start.sh"]
