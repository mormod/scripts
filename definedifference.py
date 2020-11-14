import re

cfg_original_path = r"/home/mormod/projects/i11/i11_code/stm32-chibios/demos/STM32/RT-STM32F767ZI-NUCLEO144/cfg/"
hal_original_path = cfg_original_path + r"halconf.h"
mcu_original_path = cfg_original_path + r"mcuconf.h"
ch_original_path  = cfg_original_path + r"chconf.h"

original_path = hal_original_path
old_path = r"/home/mormod/projects/i11/i11_code/stm32-projects/LevelControl/cfg/halconf.h"

original_cfg = dict()
old_cfg = dict()

file = open(original_path, "r")
for line in file:
    if re.search('#define', line):
        split_line = line.split()
        if len(split_line) > 2:
            original_cfg[split_line[1]] = split_line[2]

file.close()

file = open(old_path, "r")
for line in file:
    if re.search('#define', line):
        split_line = line.split()
        if len(split_line) > 2:
            old_cfg[split_line[1]] = split_line[2]

print("=====MISSING DEFINES=====")
for key in original_cfg.keys():
    if key not in old_cfg:
        print(f"#define {key:30} {original_cfg[key]:20}")

print("\n=====DEFINES TO CHANGE=====")
for key in original_cfg.keys():
    if key in old_cfg:
        if original_cfg[key] != old_cfg[key]:
            print(f"#define {key:30} {old_cfg[key]:20}")