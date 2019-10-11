nodetool setcompactionthroughput \
`sed -n 's/^compaction_throughput_mb_per_sec: \(.*\)/\1/p' \
/etc/cassandra/cassandra.yaml`
