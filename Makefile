# This Makefile builds the rust-make-ops Makefile && supporting scripts.

MAKECMDGOALS?=help
.PHONY: $(MAKECMDGOALS)
$(MAKECMDGOALS):
	@(cd src; cat $$(cat MANIFEST) > ../dist/rmo.bash)
	@( \
		cd test-rust-crate; \
		mkdir -p .ops/cache; \
		cp ../dist/rmo.bash .ops/cache; \
		cp ../dist/Makefile .; \
		RMOTESTLOCAL=1 make $@; \
	)
