for i in $(seq 1 100); do
  curl -s -k -o /dev/null -w "%{http_code}\n" \
    -X POST "https://store.opechimil.online/wp-login.php" \
    --data "log=admin&pwd=wrong$i&wp-submit=Log+In"
done
