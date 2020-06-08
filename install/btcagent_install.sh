#/bin/bash

printf "huobi-agent代理安装:\n"
AGENT_TYPE="btc"
SUBMIT_RESPONSES="false"
KEEP_DOWNLOADCONNECTION="true"
VERSION="v1.1"
USERNAME=""
REGION=""
PORT=""
CACHE=""
while getopts 'a:k:u:r:p:h:' c
do
  case $c in
    a) AGENT_TYPE="$OPTARG" ;;
    k) KEEP_DOWNLOADCONNECTION="$OPTARG" ;;
    u) USERNAME="$OPTARG" ;;
    r) REGION="$OPTARG" ;;
    p) PORT="$OPTARG" ;;
    h) CACHE="true" ;;
  esac
done

if [ "x$USERNAME" = "x" ] || [ "x$REGION" = "x" ] || [ "x$PORT" = "x" ]; then
    echo "Usage: $0 -a btc -u name -r bu -p 3330 -k true option:( -h 1)"
    exit
fi
if [ "x$CACHE" = "x" ];then
    wget https://github.com/wanyvic/btcagent-1/releases/download/1.1.0/huobi-btcagent-single_user-1.1.0-Linux.deb  --no-check-certificate
fi
sudo dpkg -i huobi-btcagent*.deb
sudo apt-get update
sudo apt-get -f install -y
sudo rm -rf /etc/supervisor/conf.d/btcagent-single_user.conf
sudo apt-get install -y supervisor

cat >/etc/btcagent/huobi-agent-$VERSION-$USERNAME.json << EOF
{
    "agent_type": $AGENT_TYPE,
    "always_keep_downconn":$KEEP_DOWNLOADCONNECTION,
    "disconnect_when_lost_asicboost": true,
    "use_ip_as_worker_name": false,
    "submit_response_from_server": $SUBMIT_RESPONSES,
    "agent_listen_ip": "0.0.0.0",
    "agent_listen_port": $PORT,
    "pools": [
        ["$REGION.huobipool.com", 1800, "$USERNAME"],
        ["$REGION.huobipool.com", 443, "$USERNAME"],
        ["$REGION.huobipool.com", 3333, "$USERNAME"]
    ]
}
EOF
sudo mkdir -p /var/log/btcagent/huobi-agent-$VERSION-$USERNAME
cat >/etc/supervisor/conf.d/huobi-agent-$VERSION-$USERNAME.conf << EOF 
[program:huobi-agent-$VERSION-$USERNAME]
directory=/var/log/btcagent/huobi-agent-$VERSION-$USERNAME
command=/usr/bin/btcagent -c /etc/btcagent/huobi-agent-$VERSION-$USERNAME.json -l /var/log/btcagent/huobi-agent-$VERSION-$USERNAME
autostart=true
autorestart=true
startsecs=3
startretries=2147483647

redirect_stderr=true
stdout_logfile_backups=5
stdout_logfile=/var/log/btcagent/huobi-agent-$VERSION-$USERNAME/agent_stdout.log
EOF
sudo supervisorctl update
sudo service supervisor restart
netstat -antp | grep btcagent
