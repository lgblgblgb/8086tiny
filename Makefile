# 8086tiny: a tiny, highly functional, highly portable PC emulator/VM
# Copyright 2013-14, Adrian Cable (adrian.cable@gmail.com) - http://www.megalith.co.uk/8086tiny
# Further developments in this fork (C)2017 Gabor Lenart - LGB (lgblgblgb@gmail.com) - http://github.lgb.hu/8086tiny/
#
# This work is licensed under the MIT License. See included LICENSE.TXT.

# 8086tiny builds with graphics and sound support
# 8086tiny_slowcpu improves graphics performance on slow platforms (e.g. Raspberry Pi)
# no_graphics compiles without SDL graphics/sound

ARCH			= POSIX

CC_POSIX		= gcc
STRIP_POSIX		= strip
OPTS_ALL_POSIX		= -O3 -fsigned-char -std=c99 -DPOSIX_OS
OPTS_SDL_POSIX		= $(shell sdl-config --cflags --libs)
OPTS_NOGFX_POSIX	= -DNO_GRAPHICS
OPTS_SLOWCPU_POSIX	= -DGRAPHICS_UPDATE_DELAY=25000
EXECEXT_POSIX		=
SUPPORTED_POSIX		= yes

# I plan to port 8086tiny to SDL2. I don't want to set an SDL1.2 development environment up,
# so till that, windows cross compiling is not supported - LGB

CC_WIN64		= x86_64-w64-mingw32-gcc
STRIP_WIN64		= x86_64-w64-mingw32-strip
OPTS_ALL_WIN64		= -O3 -fsigned-char -std=c99 -DWIN_OS -DWIN64_OS
OPTS_SDL_WIN64		= $(shell /usr/local/cross-tools/x86_64-w64-mingw32/bin/sdl2-config --cflags --libs | sed 's/-mwindows/-mconsole/g')
OPTS_NOGFX_WIN64	= -DNO_GRAPHICS -mconsole
OPTS_SLOWCPU_WIN64	= -DGRAPHICS_UPDATE_DELAY=25000
EXECEXT_WIN64		= .exe
SUPPORTED_WIN64		=

CC_WIN32		= i686-w64-mingw32-gcc
STRIP_WIN32		= i686-w64-mingw32-strip
OPTS_ALL_WIN32		= -O3 -fsigned-char -std=c99 -DWIN_OS -DWIN32_OS
OPTS_SDL_WIN32		= $(shell /usr/local/cross-tools/i686-w64-mingw32/bin/sdl2-config --cflags --libs | sed 's/-mwindows/-mconsole/g')
OPTS_NOGFX_WIN32	= -DNO_GRAPHICS -mconsole
OPTS_SLOWCPU_WIN32	= -DGRAPHICS_UPDATE_DELAY=25000
EXECEXT_WIN32		= .exe
SUPPORTED_WIN32		=

ifneq ($(SUPPORTED_$(ARCH)), yes)
$(error This ARCH "$(ARCH)" is not [yet?] supported)
endif

CC			= $(CC_$(ARCH))
OPTS_ALL		= $(OPTS_ALL_$(ARCH))
OPTS_SDL		= $(OPTS_SDL_$(ARCH))
OPTS_NOGFX		= $(OPTS_NOGFX_$(ARCH))
OPTS_SLOWCPU		= $(OPTS_SLOWCPU_$(ARCH))
EXECEXT			= $(EXECEXT_$(ARCH))
STRIP			= $(STRIP_$(ARCH))
PRG_BASENAME		= 8086tiny
SRC			= 8086tiny.c
PRG			= $(PRG_BASENAME)$(EXECEXT)
ALL_PRG			= $(PRG) $(PRG_BASENAME)_slowcpu$(EXECEXT) $(PRG_BASENAME)_nogfx$(EXECEXT)
BIOS_CDEF		= bios/bios_cdef.c

all:	$(PRG)

info:
	@echo "Selected target architecture (ARCH): $(ARCH)"
	@echo "C compiler                         : $(CC)"
	@echo "Generic compiler flags             : $(OPTS_ALL)"
	@echo "SDL specific compiler flags        : $(OPTS_SDL)"

$(PRG): $(SRC) $(BIOS_CDEF) Makefile
	${CC} $(SRC) ${OPTS_SDL} ${OPTS_ALL} -o $@
	strip $@

$(PRG)_slowcpu: $(SRC) $(BIOS_CDEF) Makefile
	${CC} 8086tiny.c ${OPTS_SDL} ${OPTS_ALL} ${OPTS_SLOWCPU} -o $@
	strip $@

$(PRG)_nogfx: $(SRC) $(BIOS_CDEF) Makefile
	${CC} $(SRC) ${OPTS_NOGFX} ${OPTS_ALL} -o $@
	strip $@

$(BIOS_CDEF):
	$(MAKE) -C bios

all-prg: $(ALL_PRG)

clean:
	rm -f $(ALL_PRG) *.o

.PHONY: clean all-prg info
