#!/bin/bash

# Install docker
sudo yum install -y docker > /tmp/docker.log
sudo systemctl start docker

# Run nginx
sudo docker run -d --name nginx -p 8080:80 nginx


# Run Wordpress
# sudo docker run --rm --name wordpress -e WORDPRESS_DB_HOST=db.internal.com -e WORDPRESS_DB_NAME=wordpress -e WORDPRESS_DB_USER=wordpresss -e WORDPRESS_DB_PASSWORD=badpassword -p 8080:80  wordpress 

