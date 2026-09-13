Args=("$@")

. virenv/s7isol/env.sh
python python/main.py "${Args[@]}"
