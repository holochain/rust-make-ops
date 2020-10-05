function _rmo_cmd_update {
  echo "Attempting to update to RMOGITREF = '${RMOGITREF}'..."

  echo "Downloading new Makefile..."
  curl --proto '=https' --tlsv1.2 -lsSfo Makefile.new https://raw.githubusercontent.com/holochain/rust-make-ops/${RMOGITREF}/dist/Makefile || true

  echo "Downloading new rmo.bash..."
  curl --proto '=https' --tlsv1.2 -lsSfo rmo.bash.new https://raw.githubusercontent.com/holochain/rust-make-ops/${RMOGITREF}/dist/rmo.bash || true

  echo "Configuring makefile to use RMOGITREF '${RMOGITREF}'..."
  sed -i'' "s/^RMOGITREF.*/RMOGITREF?=${RMOGITREF}/" Makefile.new

  echo "Clearing .ops/cache..."
  rm -rf .ops/cache || true
  mkdir -p .ops/cache

  echo "Moving new rmo.bash into cache..."
  mv rmo.bash.new .ops/cache/rmo.bash

  echo "Placing new Makefile..."
  rm Makefile
  mv Makefile.new Makefile

  echo "Verifying .gitignore of .ops/cache..."
  if [ ! $(grep --quiet .ops/cache .gitignore) ]; then
    echo ".ops/cache" >> .gitignore
  fi

  echo "RMO update complete!"
}

