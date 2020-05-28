#!/usr/bin/env python3

from math import ceil, log2
from copy import deepcopy

CACHE_BLOCK_SIZE = 4    # number of words per cache line
CACHE_BLOCK_COUNT = 8
CACHE_SET_COUNT = 8
addresses = "1F296FFC 378D3F41 1F296FFD 378D3F42 1F297002 378D6653 1F296FFF 378DB471 1F297000 378D8D81 1F296FFE 378D6651 1F297003 378D8D84 1F297001 378DB475".split(" ")

A1_CACHE = [ ["378D3F,010"], ["1D5496,111"], ["2AA013,000"], [''], ['378D66,110'], ['378DB4,011'], ['123456,000'], ['1F296E,111'] ]
A3_CACHE = [["23AB511,01", "378D3F4,00"], [], [], [], [], [], [], []]


INITIAL_CACHE = A1_CACHE


########################################################
# Everything below is calculated from the values above #
########################################################


# calculate block offset and index length 
INDEX_LEN = int(log2(CACHE_SET_COUNT))
BLOCK_OFFSET = int(log2(CACHE_BLOCK_SIZE))

# number of halfbytes (hex chars) to cut from the end
HBYTES_REMOVED = ceil((INDEX_LEN + BLOCK_OFFSET) / 4)

# bits appended to the end of the 
BITS_APPENDED = (HBYTES_REMOVED * 4) - (INDEX_LEN + BLOCK_OFFSET)

# calculate set size
CACHE_SET_SIZE = int(CACHE_BLOCK_COUNT / CACHE_SET_COUNT)

# this holds our cache
cache_history = list()

print({
    'CACHE_BLOCK_SIZE' : CACHE_BLOCK_SIZE,
    'CACHE_BLOCK_COUNT' : CACHE_BLOCK_COUNT,
    'CACHE_SET_COUNT' : CACHE_SET_COUNT,
    'INDEX_LEN' : INDEX_LEN,
    'BLOCK_OFFSET' : BLOCK_OFFSET,
    'HBYTES_REMOVED' : HBYTES_REMOVED,
    'BITS_APPENDED' : BITS_APPENDED,
    'CACHE_SET_SIZE' : CACHE_SET_SIZE,
})

def conv_mem_to_entry(mem):
    return mem[0: - HBYTES_REMOVED] + "," + hex_to_bin(mem[-HBYTES_REMOVED:], BITS_APPENDED)

def hex_to_bin(hex, len, offset = 0):
    return format(int(hex, 16), f"#0{HBYTES_REMOVED*4 + 2}b")[2 + offset:2 + len + offset]

def process_address(prev_cache, address):
    mem_str = conv_mem_to_entry(mem)
    index = hex_to_bin(mem[-HBYTES_REMOVED:], INDEX_LEN, offset=BITS_APPENDED)
    index = int(index, 2) if INDEX_LEN > 0 else 0

    new_cache = deepcopy(prev_cache)

    # if we have a cache hit
    if mem_str in new_cache[index]:
        # remove the old item from it (we add it later on top)
        new_cache[index].remove(mem_str)
        print("HIT")
    else:
        print(f"MISS {mem_str} not in {new_cache[index]}")

    # add to cache at first position
    new_cache[index].insert(0, mem_str)
    
    # pop old items from cache if set is full
    if len(new_cache[index]) > CACHE_SET_SIZE:
        new_cache[index].pop()
    
    return new_cache
    
def prep_initial_cache(cache):
    for i in range(CACHE_SET_COUNT):
        while len(cache[i]) < CACHE_SET_SIZE:
            cache[i].append('')
    return cache

if __name__ == "__main__":
    curr_cache = prep_initial_cache(INITIAL_CACHE)
    cache_history.append(curr_cache)

    for mem in addresses:
        curr_cache = process_address(curr_cache, mem)
        cache_history.append(curr_cache)

flatten = lambda l: [item for sublist in l for item in sublist]

# convert to latex

table_spec="|r|c||"
cycle_row = [""]
data_rows = [ [f"{int(n/CACHE_SET_SIZE)}"] if n % CACHE_SET_SIZE == 0 else [""] for n in range(CACHE_BLOCK_COUNT) ]

print(data_rows)

cycle = 0
for cache in cache_history:
    cycle_row.append(f"{cycle}")
    if cycle >= 1:
        table_spec += 'c|'

    cycle += 1
    
    for i, entry in enumerate(flatten(cache)):
        data_rows[i].append(f"{entry}")

print("LaTeX code:")
print(f"\\begin{{tabular}}{{{table_spec}}}\\hline")
print("\t" + " & ".join(cycle_row) + "\\\\ \\hline")
for i, row in enumerate(data_rows):
    line = ""
    if (i + 1) % CACHE_SET_SIZE == 0:
        line = " \\hline"
    print("\t" + " & ".join(row) + " \\\\" + line)
print("\end{tabular}")
