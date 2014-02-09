#
# Copyright (c) Michael Tharp <gxti@partiallystapled.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


BIN := bin
C_SRCS = $(filter %.c,$(SRCS))
S_SRCS = $(filter %.s,$(SRCS))

# Targets
all: target.bin target.lst

clean:
	rm -f *.lst *.bin *.out *.map
	rm -rf $(BIN)


# Rules
OBJS =
define c_template
OBJS += $(1)
$(1): $(2)
	@mkdir -p $(dir $(1))
	$$(CC) $$(CFLAGS) $$< -c -o $$@
endef
$(foreach src,$(C_SRCS),$(eval $(call c_template,$(BIN)/$(src:.c=.o),$(src))))
define s_template
OBJS += $(1)
$(1): $(2)
	@mkdir -p $(dir $(1))
	$$(AS) $$(ASFLAGS) $$< -o $$@
endef
$(foreach src,$(S_SRCS),$(eval $(call s_template,$(BIN)/$(src:.s=.o),$(src))))

target.out: $(OBJS) $(linkscript)
	$(LD) $(LDFLAGS) $(OBJS) -Map $(@:.out=.map) -T$(linkscript) -o $@

%.bin: %.out
	$(CP) $(CPFLAGS) $< $@

%.lst: %.out
	$(OD) $(ODFLAGS) $< > $@
