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
//bank4  :: [4]ptr16kb
//p_bank4  :: [4]ptr16kb
//p_bank_rw :: [2]p_bank4

//bank_rw :: struct { read: [4]ptr16kb, write: ptr64kb }
//bank16_rw :: struct { read: ptr16kb, write: ptr16kb }
bank16_rw :: struct { read: read16kb, write: write16kb }
bank4x16_rw :: [4]bank16_rw
//ram_banks :: [4]bank16kb
//rom_banks :: [4]bank16kb

get_bank16 :: #force_inline proc "contextless" (a: address) -> address {return a >> 14}
adr_bank16 :: #force_inline proc "contextless" (a: address) -> address {return a & mask_16kb}

// bank_read :: #force_inline proc "contextless" (b: ^bank4x16, a: address) -> zuint8 {return b[get_bank16(a)][0][adr_bank16(a)]}
// bank_write :: #force_inline proc "contextless" (b: ^bank4x16, a: address, v: zuint8) {b[get_bank16(a)][1][adr_bank16(a)]=v}

bank_read :: #force_inline proc (banks: ^bank4x16_rw, a: address) -> zuint8 {return banks[get_bank16(a)].read(adr_bank16(a))}
bank_write :: #force_inline proc (banks: ^bank4x16_rw, a: address, v: zuint8) {banks[get_bank16(a)].write(adr_bank16(a), v)}
