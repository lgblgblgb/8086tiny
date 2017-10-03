# 8086tiny - Further developments in this fork (C)2017 Gabor Lenart - LGB (lgblgblgb@gmail.com) - http://github.lgb.hu/8086tiny/

NASM		= nasm
BIOS_ASM_SRC	= bios.asm
BIOS_BIN	= bios.bin
BIOS_CDEF	= bios_cdef.c

all:	$(BIOS_CDEF)

$(BIOS_BIN): $(BIOS_ASM_SRC) Makefile
	$(NASM) -o $@ $<

$(BIOS_CDEF): $(BIOS_BIN) Makefile
	od -t x1 -v -A n < $< | awk 'BEGIN { OFS=",0x" ; com=" " ; print "/* Generated file, do not edit. */\nstatic const unsigned char rom_bios[] = {" } { $$1="\t" com "0x" $$1 ; print $$0 ; com="," } END { print "};" }' > $@
