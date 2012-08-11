#!/bin/sh
date_path=`date "+%Y%m%d%H%M"`

mkdir /mnt/$date_path

# backup img
sudo /usr/bin/ec2-bundle-vol --debug -d /mnt/$date_path -k /home/ubuntu/ec2_control_script/pk.pem -c /home/ubuntu/ec2_control_script/cert.pem -u YOUR_ACOUNT_NUMBER
cd /mnt

# upload to s3
sudo /usr/bin/ec2-upload-bundle -b netschool-ami-prod/$date_path -m $date_path/image.manifest.xml -a YOUR_ACCESS_KEY -s YOUR_SECRET_KEY
EC2-register netschool-ami-prod/$date_path/image.manifest.xml -n ns$date_path --region ap-northeast-1 -K /home/ubuntu/ec2_control_script/pk.pem -C /home/ubuntu/ec2_control_script/cert.pem
