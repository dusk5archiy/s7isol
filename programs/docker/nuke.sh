sudo docker system prune -a -f --volumes
sudo docker image prune -a -f
echo "[-- done --] ${BASH_SOURCE[0]}"
