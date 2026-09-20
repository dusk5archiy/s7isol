Args=("$@")

. virenv/s7isol/env.sh
python "${Args[@]}"
