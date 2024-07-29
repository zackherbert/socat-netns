install:
	cp systemd/socat-netns@.service /etc/systemd/system/socat-netns@.service
	cp socat-netns /usr/local/bin/socat-netns
	cp socat-netns-service /usr/local/bin/socat-netns-service
	systemctl daemon-reload

uninstall:
	rm /etc/systemd/system/socat-netns@.service
	rm /usr/local/bin/socat-netns
	rm /usr/local/bin/socat-netns-service
