rm -rf /home/isense/hyperledger/* || true

ps aux | grep 'fabric' | awk '{print $2}' | while read pid; do
  echo "Killing ca process: $pid"
  kill $pid
done
ps aux | grep 'peer' | awk '{print $2}' | while read pid; do
  echo "Killing peer process: $pid"
  kill $pid
done
ps aux | grep 'orderer' | awk '{print $2}' | while read pid; do
  echo "Killing orderer process: $pid"
  kill $pid
done