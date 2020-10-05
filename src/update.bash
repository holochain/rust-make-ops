function _rmo_cmd_update {
  echo "Attempting to update to RMOGITREF = '${RMOGITREF}'..."
  curl --proto '=https' --tlsv1.2 -lsSfo Makefile https://raw.githubusercontent.com/holochain/rust-make-ops/${RMOGITREF}/dist/Makefile || true
  sed -i'' "s/^RMOGITREF.*/RMOGITREF?=${RMOGITREF}/" Makefile
  rm -rf ./.ops/cache
}
