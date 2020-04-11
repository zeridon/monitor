FROM eclipse-mosquitto:1.6.9

RUN apk update && \
    apk add \
    	bash \
	bluez-btmon \
	bluez-deprecated \
	bc \
	coreutils \
	bluez \
	procps \
	curl \
	gawk

ADD monitor.sh /opt/monitor/
ADD support/ /opt/monitor/support/
ADD docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /opt/monitor

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "/bin/bash", "./monitor.sh", "-r", "-a", "-b", "-tadr", "-D", "/config" ]
