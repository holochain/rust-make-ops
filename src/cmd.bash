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

