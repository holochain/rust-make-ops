#!/bin/bash
# Common scripts for operations on Holochain rust projects.
# This bootstrap file pulls down additional script dependencies.

# sane bash errors
set -Eeuo pipefail

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

function _rmo_cmd_update {
  echo "Attempting to update to RMOGITREF = '${RMOGITREF}'..."
  curl --proto '=https' --tlsv1.2 -lsSfo Makefile https://raw.githubusercontent.com/holochain/rust-make-ops/${RMOGITREF}/dist/Makefile || true
  sed -i'' "s/^RMOGITREF.*/RMOGITREF?=${RMOGITREF}/" Makefile
  rm -rf ./.ops/cache
}
function _rmo_cmd_help {
  echo "      'make' or 'make help'    - display this usage info"
  echo "                'make fmt'     - run 'cargo fmt -- --check'"
  echo "                'make clippy'  - run 'cargo clippy'"
  echo "                'make test'    - run 'cargo test'"
  echo "                'make ci'      - run full ci fmt/clippy/test"
  echo "                'make update'  - update RMO scripts to '${RMOGITREF}'"
  echo "RMOGITREF='v42' 'make update'  - update RMO scripts to 'v42'"
  echo ""
}

function _rmo_cmd_fmt {
  cargo fmt -- --check
}

function _rmo_cmd_clippy {
  cargo clippy
}

function _rmo_cmd_test {
  cargo test --all-features
}

function _rmo_cmd_ci {
  _rmo_cmd_fmt
  _rmo_cmd_clippy
  _rmo_cmd_test
}

function _rmo_cmd {
  local _cmd="${1:-help}"
  echo ""
  echo "# make ${_cmd} #"
  echo ""
  case "${1:-help}" in
    fmt)
      _rmo_cmd_fmt
      ;;
    clippy)
      _rmo_cmd_clippy
      ;;
    test)
      _rmo_cmd_test
      ;;
    ci)
      _rmo_cmd_ci
      ;;
    update)
      _rmo_cmd_update
      ;;
    help|*)
      _rmo_cmd_help
      ;;
  esac
}

_rmo_cmd "${@}"

