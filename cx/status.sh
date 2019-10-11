nodetool netstats | egrep 'Mode:|Receiving' |\
awk '{total+=$4; recv+=$11} END{ printf("%.2f%\n", recv/total*100) }'
