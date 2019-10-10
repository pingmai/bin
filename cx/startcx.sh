set -e

nodetool status > /dev/null 2>&1 && {
	echo "can't do anything b/c cassandra is running"
	exit 1
}

DATADIR=/var/lib/cassandra/data
echo "checking directories..."

if [ -d $DATADIR/system -a -d $DATADIR/system_traces -a \
    $(ls -1 $DATADIR | wc -l) -eq 2 ]; then
    echo "system, system_traces exist & are only listings in $DATADIR"
    echo "clearing out directories..."
    sudo rm -rf /var/lib/cassandra/{data,commitlog,saved_caches}/*
else
    echo "nothing to do."
fi

NOW=`date +%s`
logfile="/var/log/cassandra/system.log"
sudo service cassandra start
n=0
max=30
while [ $n -lt $max ]; do
    read x x date t x << @EOF
`
    grep "Executing streaming plan for Bootstrap" $logfile | tail -1
`
@EOF
    time=`echo $t | cut -d, -f1`
	if [ -n "$date" -a -n "$time" ]; then
        timestamp=`date -d "$date $time" +%s`
        if [ $timestamp -gt $NOW ]; then
          echo "cassandra started"
          break
        fi
	fi
    echo "waiting for cassandra to start"
    sleep 10
    n=`expr $n + 1`
done
if [ $n -eq $max ]; then
    echo "cassandra failed to bootstrap"
    exit 1
else
    echo "cassandra started"
fi
nodetool setcompactionthroughput 0
