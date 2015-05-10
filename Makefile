PROJECT = kinetis_blinky
TARGET = $(PROJECT).elf
CC = arm-none-eabi-gcc
GDB = arm-none-eabi-gdb
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size
OCD = /usr/local/bin/openocd
#OCD = /usr/bin/openocd

CFLAGS += -mlittle-endian -mcpu=cortex-m0plus -mthumb
CFLAGS += -Wall -std=gnu99 -Os -funsigned-char -funsigned-bitfields -fpack-struct
CFLAGS +=	-fshort-enums -ffunction-sections -fdata-sections -fno-delete-null-pointer-checks
CFLAGS += -fno-builtin
CFLAGS += -MD -MP -MT $(*F).o -MF $(@F).d 
CFLAGS += -I./

STD_PERIPH_LIB = ext_lib
CFLAGS += -I ./cmsis/
CFLAGS += -I ./cmsis/MKL05Z4
CFLAGS += -I ./src
CFLAGS += -DTOOLCHAIN_GCC_ARM
CFLAGS += -DNDEBUG

ASFLAGS = $(COMMON)
ASFLAGS += $(CFLAGS)
ASFLAGS += -x assembler-with-cpp

LDFLAGS = $(COMMON) 
#-lm
#-lgcc -lc -lm -lnosys -specs=nano.specs
LDFLAGS += -Wl,-Map=$(PROJECT).map,--gc-sections
LDFLAGS += -nostdlib -T./MKL05Z4.ld

SOURCES := $(wildcard ./cmsis/*.c)
SOURCES := $(wildcard ./cmsis/MKL05Z4/*.c)
SOURCES += $(wildcard ./src/*.c)

ASSOURCES = ./cmsis/MKL05Z4/startup_MKL05Z4.s
ASSOURCES += ./cmsis/crt0.s

OBJECTS = $(patsubst %.c, %.o, $(SOURCES))
ASOBJECTS = $(patsubst %.s, %.o, $(ASSOURCES))

DEPS=$(patsubst %.o, %.o.d, $(notdir $(OBJECTS)))
DEPS+=$(patsubst %.o, %.o.d, $(notdir $(ASOBJECTS)))


all: $(TARGET) $(PROJECT).bin $(PROJECT).lss size

$(PROJECT).bin: $(TARGET)
	$(OBJCOPY) -O binary  $< $@

$(PROJECT).lss: $(TARGET)
	$(OBJDUMP) -h -S $< > $@

$(TARGET): $(OBJECTS) $(ASOBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(ASOBJECTS) -o $@

$(OBJECTS): %.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(ASOBJECTS): %.o: %.s
	$(CC) $(ASFLAGS) -c $< -o $@

size: ${TARGET}
	@echo
	@$(SIZE) ${TARGET}

## Clean target
.PHONY: clean program

program:
	echo "not implemented yet"
	$(OCD) -f flash.cfg
#sudo st-flash --reset write $(PROJECT).bin 0x8000000

clean:
	rm $(OBJECTS) $(ASOBJECTS) $(PROJECT).bin $(PROJECT).elf $(PROJECT).map $(PROJECT).lss $(DEPS)
