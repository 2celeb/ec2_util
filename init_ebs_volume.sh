#!/bin/sh
# インスタンス起動時にEBSボリュームを自動作成する

export JAVA_HOME=/usr
export EC2_HOME=/usr
export EC2_CERT=/home/ubuntu/ec2_control_script/cert.pem
export EC2_PRIVATE_KEY=/home/ubuntu/ec2_control_script/pk.pem
mount_device=/dev/sdf
mount_dir=/ebs


case "$1" in
    start)
        zone=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
        region=`echo $zone  | sed -e 's/\([0-9]\)[a-z]/\1/'`
        volume_id=`/usr/bin/ec2-create-volume -z $zone -s 2 --region $region | awk '{print $2}'`
        instance_id=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`
        /usr/bin/ec2-attach-volume $volume_id  --region $region --instance $instance_id --device $mount_device
        sleep 60
        sudo /sbin/mkfs.ext3 -F $mount_device
        if [ -e /ebs ]; then
          echo "exist"
        else
          sudo /bin/mkdir $mount_dir
        fi
        /bin/mount $mount_device $mount_dir
        ;;
    *)
        $1
esac
exit 0
