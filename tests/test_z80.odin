package test_z80

import z ".."
import "core:fmt"
import "core:testing"

expectf :: testing.expectf
expect_value :: testing.expect_value

@(private)
expect_size :: proc(t: ^testing.T, $act: typeid, exp: int, loc := #caller_location) {
	expectf(t, size_of(act) == exp, "size_of(%v) should be %d was %d", typeid_of(act), exp, size_of(act), loc = loc)
}

@(test)
verify_flags :: proc(t: ^testing.T) {
	exp, act: u32
	exp, act = 255, z.Z80_SF | z.Z80_ZF | z.Z80_YF | z.Z80_HF | z.Z80_XF | z.Z80_PF | z.Z80_NF | z.Z80_CF
	expect_value(t, act, exp)
}

@(test)
verify_options :: proc(t: ^testing.T) {
	exp, act: u32
	exp, act = 63, z.Z80_OPTION_OUT_VC_255 | z.Z80_OPTION_LD_A_IR_BUG | z.Z80_OPTION_HALT_SKIP | z.Z80_OPTION_XQ | z.Z80_OPTION_IM0_RETX_NOTIFICATIONS | z.Z80_OPTION_YQ
	expect_value(t, act, exp)
}

@(test)
verify_consts_max_cycles :: proc(t: ^testing.T) {
	act: z.zusize = z.Z80_MAXIMUM_CYCLES
	exp: z.zusize = 18446744073709551585
	expectf(t, act == exp, "%v (should be: %v)", act, exp)
}

_64kb :: 1 << 16
_16kb :: 1 << 14

@(test)
verify_z80_memory :: proc(t: ^testing.T) {
	expect_value(t, z.size_64kb, _64kb)
	expect_value(t, z.size_16kb, _16kb)
	expect_value(t, len(z.bank16kb), _16kb)
	expect_value(t, size_of(z.bank16kb), _16kb)

	ram: [4]z.bank16kb = ---
	rom: [2]z.bank16kb = ---

	read, write: [4]z.ptr16kb

	write = {&ram[0], &ram[1], &ram[2], &ram[3]}
	read = {&rom[0], &ram[1], &ram[2], &rom[1]}

	banks: z.bank4x16 = {{&ram[0], &rom[0]}, {&ram[1], &ram[1]}, {&ram[2], &ram[2]}, {&ram[3], &rom[1]}}
	banks[1][0][666] = 0xCD
	expect_value(t, banks[1][0][666], 0xCD)
}

@(test)
get_bank :: proc(t: ^testing.T) {
	expect_value(t, z.get_bank16(0x0000), 0)
	expect_value(t, z.get_bank16(0x3FFF), 0)
	expect_value(t, z.get_bank16(0x4000), 1)
	expect_value(t, z.get_bank16(0x7FFF), 1)
	expect_value(t, z.get_bank16(0x8000), 2)
	expect_value(t, z.get_bank16(0xBFFF), 2)
	expect_value(t, z.get_bank16(0xC000), 3)
	expect_value(t, z.get_bank16(0xFFFF), 3)
}

@(test)
bank_io :: proc(t: ^testing.T) {

	read16kb :: proc(address: z.address) -> z.zuint8 {
		fmt.println(#procedure, address)
		return 0
	}
	write16kb :: proc(address: z.address, b: z.zuint8) {
	}

	banks: z.bank4x16
	_ = banks

	bank_rw := z.bank16_rw{}
	_ = bank_rw
}
