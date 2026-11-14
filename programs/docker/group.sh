Main() {
  local User && User=$(whoami)
  sudo groupadd docker || true
  sudo usermod -aG docker "$User"
}

Main
