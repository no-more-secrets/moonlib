tests := $(wildcard test/*.lua)

test:
	@lua moon/unit/main.lua $(tests)

.PHONY: test