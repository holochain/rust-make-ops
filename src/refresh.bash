function _rmo_refresh {
  local _rmo="./.ops/cache/rmo.bash"

  if [ ${RMORELAUNCH:-} ]; then
    # never refresh if we've already relaunched
    # we don't want to cause an infinite loop
    return
  fi

  if [ ! -f ${_rmo} ] || [ $(( $(date +%s) - $(stat -c %Y ${_rmo}) )) -gt 86400 ];
  then
    echo "Refreshing ${_rmo}..."
    if [ ${RMOTESTLOCAL:-} ]; then
      cp ../dist/rmo.bash ${_rmo} || true
    else
      curl --proto '=https' --tlsv1.2 -lsSfo ${_rmo} https://raw.githubusercontent.com/holochain/rust-make-ops/${RMOGITREF}/dist/rmo.bash || true
    fi
    echo "Refreshed - Relaunching"
    export RMORELAUNCH=1
    /bin/bash ${0}
  fi
}

_rmo_refresh

