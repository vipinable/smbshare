#!/bin/ash
#Function to send emails
notify() {
        aws ses send-email --from vipinablewifi@comcast.net --destination '{"ToAddresses":  ["vipinable@gmail.com"] }' --subject "rclone check on ${1} found errors" --text "$(cat /tmp/rclone.check)"
}

#Sync personal documents folder
lc=$(wc -l /smbdrive/rclone.log|cut -d\  -f1)
rclone check -v synchost:/home/ubuntu/datavol/PersonalDocX /smbdrive/PersonalDocX --one-way --log-file /smbdrive/rclone.log
lcn=$(wc -l /smbdrive/rclone.log|cut -d\  -f1)
tail -$(expr $lcn - $lc) /smbdrive/rclone.log > /tmp/rclone.check
t=$(grep errors /tmp/rclone.check |wc -l)
if [ $t -eq 0 ];then
        rclone sync -v /smbdrive/PersonalDocX synchost:/home/ubuntu/datavol/PersonalDocX --log-file /smbdrive/rclone.log
else
        notify "PersonalDocX"
fi

#Sync media folder
lc=$(wc -l /smbdrive/rclone.log|cut -d\  -f1)
rclone check -v synchost:/home/ubuntu/datavol/Videos /smbdrive/Videos --one-way --log-file /smbdrive/rclone.log
lcn=$(wc -l /smbdrive/rclone.log|cut -d\  -f1)
tail -$(expr $lcn - $lc) /smbdrive/rclone.log > /tmp/rclone.check
t=$(grep errors /tmp/rclone.check |wc -l)
if [ $t -eq 0 ];then
        rclone sync -v /smbdrive/Videos synchost:/home/ubuntu/datavol/Videos --log-file /smbdrive/rclone.log
else
        notify "media"
fi

LOG_ENTRY="$(hostname) $(uptime | tr -d ',')" 
/usr/bin/aws logs put-log-events --log-group-name healthcheck-healthchecklg51B22FD0-5U1gCWp2fGkk --log-stream-name defaultlogstream --log-events timestamp=$(date +%s%3N),message="${LOG_ENTRY}"
