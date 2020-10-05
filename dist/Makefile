# Common Makefile for operations on Holochain rust projects.
# This bootstrap file pulls down and executes helper scripts.

RMOGITREF?=main
MAKECMDGOALS?=help
.PHONY: $(MAKECMDGOALS)
$(MAKECMDGOALS):
	@mkdir -p ./.ops/cache
	@if [ ! -f ./.ops/cache/rmo.bash ]; then \
		curl --proto '=https' --tlsv1.2 -lsSfo ./.ops/cache/rmo.bash https://raw.githubusercontent.com/holochain/rust-make-ops/$(RMOGITREF)/dist/rmo.bash; \
		RMOGITREF=$(RMOGITREF) /bin/bash ./.ops/cache/rmo.bash update; \
	fi
	@RMOGITREF=$(RMOGITREF) /bin/bash ./.ops/cache/rmo.bash $@
