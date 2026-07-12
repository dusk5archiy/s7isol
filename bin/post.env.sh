if [[ -f "$S7ISOL/.post.env" ]]; then
  source "$S7ISOL/.post.env"
else
  source "$S7ISOL/default.post.env"
fi

# ------------------------------------------------------------------------------

for file in "$S7ISOL/env"/*.sh; do
  source "$file"
done
