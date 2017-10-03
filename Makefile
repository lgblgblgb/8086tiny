# 8086tiny: a tiny, highly functional, highly portable PC emulator/VM
# Copyright 2013-14, Adrian Cable (adrian.cable@gmail.com) - http://www.megalith.co.uk/8086tiny
#
# This work is licensed under the MIT License. See included LICENSE.TXT.

# 8086tiny builds with graphics and sound support
# 8086tiny_slowcpu improves graphics performance on slow platforms (e.g. Raspberry Pi)
# no_graphics compiles without SDL graphics/sound

CC		= gcc
NASM		= nasm
OPTS_ALL	= -O3 -fsigned-char -std=c99
OPTS_SDL	= `sdl-config --cflags --libs`
OPTS_NOGFX	= -DNO_GRAPHICS
OPTS_SLOWCPU	= -DGRAPHICS_UPDATE_DELAY=25000
SRC		= 8086tiny.c
PRG		= 8086tiny
ALL_PRG		= $(PRG) $(PRG)_slowcpu $(PRG)_nogfx

$(PRG): $(SRC) bios Makefile
	${CC} $(SRC) ${OPTS_SDL} ${OPTS_ALL} -o $@
	strip $@

$(PRG)_slowcpu: $(SRC) bios Makefile
	${CC} 8086tiny.c ${OPTS_SDL} ${OPTS_ALL} ${OPTS_SLOWCPU} -o $@
	strip $@

$(PRG)_nogfx: $(SRC) bios Makefile
	${CC} $(SRC) ${OPTS_NOGFX} ${OPTS_ALL} -o $@
	strip $@

all-prg: $(ALL_PRG)

bios: bios_source/bios.asm
	$(NASM) -o $@ $<

clean:
	rm -f $(ALL_PRG) *.o

.PHONY: clean all-prg
