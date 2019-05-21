all:
	./build.sh kernel
	sudo cp ../image/boot.img /usr/share/nginx/html/snapav/
