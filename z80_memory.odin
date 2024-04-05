package z80

address :: zuint16

size_16kb :: 0x04000
mask_16kb :: 0x03FFF
size_64kb :: 0x10000
mask_64kb :: 0x0FFFF

read16kb :: #type proc(address: address) -> zuint8
write16kb :: #type proc(address: address, b: zuint8)

bank16kb :: [size_16kb]zuint8
bank64kb :: [size_64kb]zuint8
ptr16kb :: ^bank16kb
ptr64kb :: ^bank64kb

// rom16kb :: [size_16kb]byte
// ram16kb :: [size_16kb]byte

//bank :: struct { read: ptr16kb, write: ptr16kb }
bank16 :: [2]ptr16kb
bank4x16 :: [4]bank16

p_bank_4  :: [4]ptr16kb
//bank_rw :: [2]bank_4
bank_rw :: struct { read: [4]ptr16kb, write: ptr64kb }

//ram_banks :: [4]bank16kb
//rom_banks :: [4]bank16kb

read :: #force_inline proc "contextless" (b: ^bank4x16, a: address) -> zuint8 {return b[(a >> 14)][0][a & mask_16kb]}
write :: #force_inline proc "contextless" (b: ^bank4x16, a: address, v: zuint8) {b[(a >> 14)][1][a & mask_16kb]=v}
