# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

EXAMPLES = $(patsubst examples/%,%,$(wildcard examples/*))
$(info Examples: $(EXAMPLES))

.PHONY: all build_examples
all: build_examples

define build_example_board =
.PHONY: build_$1_$2
build_$1_$2:
	@echo === Building $1 for $2 ===
	BOARD=$2 $(MAKE) -C examples/$1

build_$1: build_$1_$2
endef

define build_example =
$(eval BOARDS_$1 := $(shell $(MAKE) -C examples/$1 describe | grep SUPPORTED_BOARDS | cut -d= -f2))
$(foreach BOARD,$(BOARDS_$1),$(eval $(call build_example_board,$1,$(BOARD))))
.PHONY: build_$1
build_examples: build_$1
endef

#define built_example =
#.PHONY: build_$1
#build_$1:
#	$(MAKE) -C examples/$1
#
#build_examples: build_$1
#endef

$(foreach EXAMPLE,$(EXAMPLES),$(eval $(call build_example,$(EXAMPLE))))

test_%:
	$(MAKE) -C examples/blinky test