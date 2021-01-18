<<<<<<< HEAD
#!/usr/bin/env bash
while ! grep "Cloud-init .* finished" /var/log/cloud-init.log; do
    echo "$(date -Ins) Waiting for cloud-init to finish"
    sleep 2
done
=======
#!/usr/bin/env bash
while ! grep "Cloud-init .* finished" /var/log/cloud-init.log; do
    echo "$(date -Ins) Waiting for cloud-init to finish"
    sleep 2
done
>>>>>>> upstream/main
