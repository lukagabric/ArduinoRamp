#
# embedXcode
# ----------------------------------
# Embedded Computing on Xcode
#
# Copyright © Rei VILO, 2010-2016
# http://embedxcode.weebly.com
# All rights reserved
#
#
# Last update: Nov 25, 2016 release 5.3.9



include $(MAKEFILE_PATH)/About.mk

# TinyCircuits SAMD specifics
# ----------------------------------
#
PLATFORM         := TinyCircuits
PLATFORM_TAG      = ARDUINO=10610 EMBEDXCODE=$(RELEASE_NOW) TINYCIRCUITS
APPLICATION_PATH := $(ARDUINO_CC_PATH)
PLATFORM_VERSION := SAMD $(TINYCIRCUITS_SAMD_RELEASE) for Arduino $(ARDUINO_CC_RELEASE)

HARDWARE_PATH     = $(TINYCIRCUITS_SAMD_PATH)/hardware/samd/$(TINYCIRCUITS_SAMD_RELEASE)
TOOL_CHAIN_PATH   = $(ARDUINO_SAMD_PATH)/tools/arm-none-eabi-gcc/4.8.3-2014q1
CMSIS_PATH        = $(ARDUINO_SAMD_PATH)/tools/CMSIS/4.0.0-atmel
OTHER_TOOLS_PATH  = $(ARDUINO_CC_PACKAGES_PATH)/arduino/tools

BUILD_CORE       = samd
BOARDS_TXT      := $(HARDWARE_PATH)/boards.txt
#BUILD_CORE       = $(call PARSE_BOARD,$(BOARD_TAG),build.core)

# Uploader
#
USB_RESET        = python $(UTILITIES_PATH)/reset_1200.py
UPLOADER         = bossac
UPLOADER_PATH    = $(OTHER_TOOLS_PATH)/bossac/$(BOSSAC_RELEASE)
UPLOADER_EXEC    = $(UPLOADER_PATH)/bossac
UPLOADER_PORT    = $(subst /dev/,,$(AVRDUDE_PORT))
UPLOADER_OPTS    = -i -d --port=$(UPLOADER_PORT) -U $(call PARSE_BOARD,$(BOARD_TAG),upload.native_usb) -i -e -w -v $(TARGET_BIN) -R

APP_TOOLS_PATH   := $(TOOL_CHAIN_PATH)/bin
CORE_LIB_PATH    := $(HARDWARE_PATH)/cores/arduino
APP_LIB_PATH     := $(HARDWARE_PATH)/libraries


# Core files
# Crazy maze of sub-folders
#
CORE_C_SRCS          = $(shell find $(CORE_LIB_PATH) -name \*.c)
tiny1300             = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS        = $(filter-out %/$(EXCLUDE_LIST),$(tiny1300))
CORE_AS1_SRCS        = $(shell find $(CORE_LIB_PATH) -name \*.S)
CORE_AS1_SRCS_OBJ    = $(patsubst %.S,%.S.o,$(filter %.S, $(CORE_AS1_SRCS)))
CORE_AS2_SRCS        = $(shell find $(CORE_LIB_PATH) -name \*.s)
CORE_AS2_SRCS_OBJ    = $(patsubst %.s,%.s.o,$(filter %.s, $(CORE_AS_SRCS)))

CORE_OBJ_FILES       = $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
CORE_OBJS            = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))

CORE_LIBS_LOCK       = 1

# Two locations for libraries
# First from package
#
APP_LIB_PATH     := $(HARDWARE_PATH)/libraries

tiny1000    = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
tiny1000   += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
tiny1000   += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
tiny1000   += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
tiny1000   += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
tiny1000   += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))
tiny1000   += $(HARDWARE_PATH)/libraries/RedBear_Duo/src
tiny1000   += $(HARDWARE_PATH)/libraries/RedBear_Duo/src/utility

APP_LIB_CPP_SRC = $(foreach dir,$(tiny1000),$(wildcard $(dir)/*.cpp)) # */
APP_LIB_C_SRC   = $(foreach dir,$(tiny1000),$(wildcard $(dir)/*.c)) # */
APP_LIB_S_SRC   = $(foreach dir,$(tiny1000),$(wildcard $(dir)/*.S)) # */
APP_LIB_H_SRC   = $(foreach dir,$(tiny1000),$(wildcard $(dir)/*.h)) # */

APP_LIB_OBJS     = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS    += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

BUILD_APP_LIBS_LIST = $(subst $(BUILD_APP_LIB_PATH)/, ,$(APP_LIB_CPP_SRC))

# Second from Arduino.CC
#
BUILD_APP_LIB_PATH     = $(APPLICATION_PATH)/libraries

tiny1100    = $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
tiny1100   += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
tiny1100   += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
tiny1100   += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
tiny1100   += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
tiny1100   += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

BUILD_APP_LIB_CPP_SRC = $(foreach dir,$(tiny1100),$(wildcard $(dir)/*.cpp)) # */
BUILD_APP_LIB_C_SRC   = $(foreach dir,$(tiny1100),$(wildcard $(dir)/*.c)) # */
BUILD_APP_LIB_H_SRC   = $(foreach dir,$(tiny1100),$(wildcard $(dir)/*.h)) # */

BUILD_APP_LIB_OBJS     = $(patsubst $(APPLICATION_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(BUILD_APP_LIB_CPP_SRC))
BUILD_APP_LIB_OBJS    += $(patsubst $(APPLICATION_PATH)/%.c,$(OBJDIR)/%.c.o,$(BUILD_APP_LIB_C_SRC))

APP_LIBS_LOCK = 1


# Sketchbook/Libraries path
# wildcard required for ~ management
# ?ibraries required for libraries and Libraries
#
ifeq ($(USER_LIBRARY_DIR)/Arduino15/preferences.txt,)
    $(error Error: run Arduino or panStamp once and define the sketchbook path)
endif

ifeq ($(wildcard $(SKETCHBOOK_DIR)),)
    SKETCHBOOK_DIR = $(shell grep sketchbook.path $(wildcard ~/Library/Arduino15/preferences.txt) | cut -d = -f 2)
endif

ifeq ($(wildcard $(SKETCHBOOK_DIR)),)
    $(error Error: sketchbook path not found)
endif

USER_LIB_PATH   = $(wildcard $(SKETCHBOOK_DIR)/?ibraries)

VARIANT         = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH    = $(HARDWARE_PATH)/variants/$(VARIANT)
LDSCRIPT_PATH   = $(VARIANT_PATH)
LDSCRIPT        = $(VARIANT_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),menu.BuildOption.normal.build.ldscript)
VARIANT_CPP_SRCS    = $(wildcard $(VARIANT_PATH)/*.cpp) # */
VARIANT_OBJ_FILES   = $(VARIANT_CPP_SRCS:.cpp=.cpp.o)
VARIANT_OBJS        = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))


# Rules for making a c++ file from the main sketch (.pde)
#
PDEHEADER      = \\\#include \"WProgram.h\"


# Tool-chain names
#
CC      = $(APP_TOOLS_PATH)/arm-none-eabi-gcc
CXX     = $(APP_TOOLS_PATH)/arm-none-eabi-g++
AR      = $(APP_TOOLS_PATH)/arm-none-eabi-ar
OBJDUMP = $(APP_TOOLS_PATH)/arm-none-eabi-objdump
OBJCOPY = $(APP_TOOLS_PATH)/arm-none-eabi-objcopy
SIZE    = $(APP_TOOLS_PATH)/arm-none-eabi-size
NM      = $(APP_TOOLS_PATH)/arm-none-eabi-nm
# ~
GDB     = $(APP_TOOLS_PATH)/arm-none-eabi-gdb
# ~~

MCU_FLAG_NAME    = mcpu
MCU              = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
F_CPU            = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)
OPTIMISATION    ?= -Os -g3

# TinyCircuits USB PID VID
#
USB_VID     := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
USB_PID     := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)
USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
USB_VENDOR  := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)

ifneq ($(USB_VID),)
    USB_FLAGS    = -DUSB_VID=$(USB_VID)
    USB_FLAGS   += -DUSB_PID=$(USB_PID)
    USB_FLAGS   += -DUSBCON
    USB_FLAGS   += -DUSB_MANUFACTURER='$(USB_VENDOR)'
    USB_FLAGS   += -DUSB_PRODUCT='$(USB_PRODUCT)'
endif

INCLUDE_PATH     = $(CORE_LIB_PATH) $(APP_LIB_PATH) $(VARIANT_PATH) $(HARDWARE_PATH)
INCLUDE_PATH    += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH    += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC) $(BUILD_APP_LIB_H_SRC)))
INCLUDE_PATH    += $(OBJDIR)
INCLUDE_PATH    += $(CMSIS_PATH)/CMSIS/Include
INCLUDE_PATH    += $(CMSIS_PATH)/Device/ATMEL

D_FLAGS          = $(PLATFORM_TAG) ARDUINO_SAMD_ZERO ARDUINO_ARCH_SAMD __SAMD21G18A__

FIRST_O_IN_A     = $$(find . -name pulse_asm.S.o)


# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common CPPFLAGS for gcc, g++, assembler and linker
#
CPPFLAGS     = $(OPTIMISATION) $(WARNING_FLAGS)
CPPFLAGS    += -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU)
CPPFLAGS    += -mthumb -ffunction-sections -fdata-sections -nostdlib
CPPFLAGS    += --param max-inline-insns-single=500 -MMD
CPPFLAGS    += $(addprefix -D, $(PLATFORM_TAG) $(D_FLAGS))
CPPFLAGS    += $(addprefix -I, $(INCLUDE_PATH))

# Specific CFLAGS for gcc only
# gcc uses CPPFLAGS and CFLAGS
#
CFLAGS       = -std=gnu11

# Specific CXXFLAGS for g++ only
# g++ uses CPPFLAGS and CXXFLAGS
#
CXXFLAGS     = -std=gnu++11 -fno-threadsafe-statics -fno-rtti -fno-exceptions

# Specific ASFLAGS for gcc assembler only
# gcc assembler uses CPPFLAGS and ASFLAGS
#
ASFLAGS      = -x assembler-with-cpp

LDFLAGS      = $(OPTIMISATION) $(WARNING_FLAGS) -Wl,--gc-sections -save-temps
LDFLAGS     += -$(MCU_FLAG_NAME)=$(MCU) --specs=nano.specs --specs=nosys.specs
LDFLAGS     += -T $(LDSCRIPT) -mthumb
LDFLAGS     += -Wl,--cref -Wl,-Map,Builds/embeddedcomputing.map # Output a cross reference table.
LDFLAGS     += -Wl,--check-sections -Wl,--gc-sections
LDFLAGS     += -Wl,--unresolved-symbols=report-all
LDFLAGS     += -Wl,--warn-common -Wl,--warn-section-align

# Specific OBJCOPYFLAGS for objcopy only
# objcopy uses OBJCOPYFLAGS only
#
OBJCOPYFLAGS  = -v -Obinary

# Target 
#
TARGET_HEXBIN = $(TARGET_BIN)

USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.use_1200bps_touch)
ifeq ($(USB_TOUCH),true)
    USB_RESET  = python $(UTILITIES_PATH)/reset_1200.py
endif


# Commands
# ----------------------------------
# Link command
#
COMMAND_LINK    = $(CC) -L$(OBJDIR) $(LDFLAGS) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) -Wl,--start-group -lm $(TARGET_A) -Wl,--end-group

# Upload command
#
COMMAND_UPLOAD  = $(UPLOADER_EXEC) $(UPLOADER_OPTS)
DELAY_BEFORE_UPLOAD = 3
DELAY_AFTER_UPLOAD = 3

