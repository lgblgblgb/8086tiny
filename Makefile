# 8086tiny: a tiny, highly functional, highly portable PC emulator/VM
# Copyright 2013-14, Adrian Cable (adrian.cable@gmail.com) - http://www.megalith.co.uk/8086tiny
# Further developments in this fork (C)2017 Gabor Lenart - LGB (lgblgblgb@gmail.com) - http://github.lgb.hu/8086tiny/
#
# This work is licensed under the MIT License. See included LICENSE.TXT.

# 8086tiny builds with graphics and sound support
# 8086tiny_slowcpu improves graphics performance on slow platforms (e.g. Raspberry Pi)
# no_graphics compiles without SDL graphics/sound

ARCH			= posix
ARCH_SYS		= $(shell echo $(ARCH) | tr '[a-z]' '[A-Z]')

CC_POSIX		= gcc
STRIP_POSIX		= strip
OPTS_ALL_POSIX		= -O3 -fsigned-char -fno-common -ffast-math -std=c99 -DPOSIX_SYS
OPTS_SDL_POSIX		= -DHAVE_SDL $(shell sdl2-config --cflags --libs)
OPTS_NOGFX_POSIX	=
OPTS_SLOWCPU_POSIX	= -DGRAPHICS_UPDATE_DELAY=25000
EXECEXT_POSIX		=
CLEAN_EXTRA_POSIX	=
SUPPORTED_POSIX		= yes

CC_WIN64		= x86_64-w64-mingw32-gcc
STRIP_WIN64		= x86_64-w64-mingw32-strip
OPTS_ALL_WIN64		= -O3 -fsigned-char -fno-common -ffast-math -std=c99 -DWIN_SYS -DWIN64_SYS
OPTS_SDL_WIN64		= -DHAVE_SDL $(shell /usr/local/cross-tools/x86_64-w64-mingw32/bin/sdl2-config --cflags --libs | sed 's/-mwindows/-mconsole/g')
OPTS_NOGFX_WIN64	= -mconsole
OPTS_SLOWCPU_WIN64	= -DGRAPHICS_UPDATE_DELAY=25000
EXECEXT_WIN64		= _win64.exe
CLEAN_EXTRA_WIN64	=
SUPPORTED_WIN64		= yes

CC_WIN32		= i686-w64-mingw32-gcc
STRIP_WIN32		= i686-w64-mingw32-strip
OPTS_ALL_WIN32		= -O3 -fsigned-char -fno-common -ffast-math -std=c99 -DWIN_SYS -DWIN32_SYS
OPTS_SDL_WIN32		= -DHAVE_SDL $(shell /usr/local/cross-tools/i686-w64-mingw32/bin/sdl2-config --cflags --libs | sed 's/-mwindows/-mconsole/g')
OPTS_NOGFX_WIN32	= -mconsole
OPTS_SLOWCPU_WIN32	= -DGRAPHICS_UPDATE_DELAY=25000
EXECEXT_WIN32		= _win32.exe
CLEAN_EXTRA_WIN32	=
SUPPORTED_WIN32		= yes

# Wannabe 'just try it' in-the-browser version ...
# It's not enabled target since it does not work yet, for multiple reasons - LGB

CC_JS			= emcc
STRIP_JS		= @echo Stripping output file is not possible with JS output, it is normal:
OPTS_ALL_JS		= -O3 -fsigned-char -std=c99 -DJS_SYS -fno-common -ffast-math -s NO_EXIT_RUNTIME=1 -s USE_SDL=2 -DHAVE_SDL --memory-init-file 1 -s ERROR_ON_UNDEFINED_SYMBOLS=1 -s EXPORTED_FUNCTIONS='["_main"]'
OPTS_SDL_JS		=
OPTS_NOGFX_JS		=
OPTS_SLOWCPU_JS		=
EXECEXT_JS		= .html
CLEAN_EXTRA_JS		= .js .html.mem
SUPPORTED_JS		= no

ifneq ($(SUPPORTED_$(ARCH_SYS)), yes)
$(error This ARCH "$(ARCH_SYS)" is not [yet?] supported)
endif

CC			= $(CC_$(ARCH_SYS))
OPTS_ALL		= $(OPTS_ALL_$(ARCH_SYS))
OPTS_SDL		= $(OPTS_SDL_$(ARCH_SYS))
OPTS_NOGFX		= $(OPTS_NOGFX_$(ARCH_SYS))
OPTS_SLOWCPU		= $(OPTS_SLOWCPU_$(ARCH_SYS))
EXECEXT			= $(EXECEXT_$(ARCH_SYS))
STRIP			= $(STRIP_$(ARCH_SYS))
PRG_BASENAME		= 8086tiny
SRC			= 8086tiny.c
PRG			= $(PRG_BASENAME)$(EXECEXT)
ALL_PRG			= $(PRG) $(PRG_BASENAME)_slowcpu$(EXECEXT) $(PRG_BASENAME)_nogfx$(EXECEXT)
BIOS_CDEF		= bios/bios_cdef.c
CLEAN_LIST		= $(ALL_PRG) $(foreach x, $(CLEAN_EXTRA_$(ARCH_SYS)), $(addsuffix $(x), $(PRG_BASENAME)))

all:	$(PRG)

info:
	@echo "Selected target architecture (ARCH): $(ARCH)"
	@echo "C compiler                         : $(CC)"
	@echo "Generic compiler flags             : $(OPTS_ALL)"
	@echo "SDL specific compiler flags        : $(OPTS_SDL)"
	@echo "Clean target file list             : $(CLEAN_LIST)"

$(PRG): $(SRC) $(BIOS_CDEF) Makefile
	$(CC) -o $@ $(SRC) $(OPTS_ALL) $(OPTS_SDL)
	$(STRIP) $@

$(PRG)_slowcpu: $(SRC) $(BIOS_CDEF) Makefile
	$(CC) -o $@ $(SRC) $(OPTS_ALL) $(OPTS_SLOWCPU) $(OPTS_SDL)
	$(STRIP) $@

$(PRG)_nogfx: $(SRC) $(BIOS_CDEF) Makefile
	$(CC) -o $@ $(SRC) $(OPTS_ALL) $(OPTS_NOGFX)
	$(STRIP) $@

$(BIOS_CDEF):
	$(MAKE) -C bios

all-prg: $(ALL_PRG)

clean:
	rm -f $(CLEAN_LIST) *.o

.PHONY: clean all-prg info
