#!/bin/bash

sodo yum install -y httpd
sudo chkconfig --level 345 httpd on

sudo cat <<EOF > /var/www/html/index.html
<html>
<body>
<p>hostname is: $(hostname)</p>
</body>
</html>
EOF
sudo chown -R apache:apache /var/www/html
sudo service httpd start
