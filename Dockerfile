FROM eclipse-mosquitto:1.6.9

RUN apk --no-cache add --virtual build-deps \
	git && \
	git clone --depth=1 https://github.com/zeridon/monitor.git /opt/monitor && \
	apk del build-deps

RUN apk add --no-cache \
    	bash \
	bc \
	bluez \
	bluez-btmon \
	bluez-deprecated \
	coreutils \
	curl \
	dumb-init \
	gawk \
	procps

WORKDIR /opt/monitor

ENTRYPOINT [ "/opt/monitor/docker-entrypoint.sh" ]

CMD [ "dumb-init", "./monitor.sh", "-r", "-a", "-b", "-tadr", "-D", "/config" ]
