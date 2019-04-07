ifeq ($(CC),cc)
CC = gcc
endif
ifeq ($(windir),)
EXE =
RM = rm -f
else
EXE = .exe
RM = del
endif

ifneq (,$(findstring darwin,$(CROSS_COMPILE)))
	UNAME_S := Darwin
else
	UNAME_S := $(shell uname -s)
endif
ifeq ($(UNAME_S),Darwin)
	LDFLAGS += -Wl,-dead_strip
else
	LDFLAGS += -Wl,--gc-sections -s
endif

all:mkbootfs$(EXE)

static:
	$(MAKE) LDFLAGS="$(LDFLAGS) -static"

mkbootfs$(EXE):mkbootfs.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ -L. $(LDFLAGS)

mkbootfs.o:mkbootfs.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -I. -Werror

clean:
	$(RM) mkbootfs
	$(RM) *.~ *.exe *.o
