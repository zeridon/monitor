FROM eclipse-mosquitto:1.6.9

RUN apk add --no-cache \
    	bash \
	bc \
	bluez \
	bluez-btmon \
	bluez-deprecated \
	coreutils \
	curl \
	dumb-init
	gawk \
	procps

ADD monitor.sh /opt/monitor/
ADD support/ /opt/monitor/support/
ADD docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /opt/monitor

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "dumb-init", "./monitor.sh", "-r", "-a", "-b", "-tadr", "-D", "/config" ]
