package z80emulator

import "core:fmt"
import "core:os"
import "core:runtime"
import "core:path/filepath"
import z80 "../.."

dump_cpu :: false
cycles_per_tick :: 100
mem_size :: 0x10000
memory: [mem_size]u8
running: bool = false

z_fetch_opcode :: proc(zcontext: rawptr, address: z80.zuint16) -> z80.zuint8 {
	//fmt.printf("fetch_opcode[%d]=0x%2X\n", address, memory[address])
	return memory[address]
}

z_fetch :: proc(zcontext: rawptr, address: z80.zuint16) -> z80.zuint8 {
	//fmt.printf("fetch[%d]=0x%2X\n", address, memory[address])
	return memory[address]
}

z_read :: proc(zcontext: rawptr, address: z80.zuint16) -> z80.zuint8 {
	//fmt.printf("read[%d]=0x%2X\n", address, memory[address])
	return memory[address]
}

z_write :: proc(zcontext: rawptr, address: z80.zuint16, value: z80.zuint8) {
	//fmt.printf("write[0x%4X]=0x%2X\n", address, value)
	memory[address] = value
}

z_in :: proc(zcontext: rawptr, address: z80.zuint16) -> z80.zuint8 {
	port := address & 0xFF
	value: z80.zuint8 = 0
	switch port {
	case 1:
		value = 1
	case:
		fmt.printf("in[0x%2X]=0x%2X", port, value)
		if value >= 32 {fmt.printf(" '%v'", rune(value))}
		fmt.println()
	}
	return value
}

z_out :: proc(zcontext: rawptr, address: z80.zuint16, value: z80.zuint8) {
	port := address & 0xFF
	switch port {
	case 1:
		switch value {
			case '\n': fmt.println(flush = true) /* Line Feed */
			case '\f': /*skip Form Feed*/
			case '\r': /*skip Carriage Return*/
			case: fmt.print(rune(value))
		}
	case:
		{
			fmt.printf("out[0x%2X]=0x%2X", port, value)
			if value >= 32 {fmt.printf(" '%v'", rune(value))}
			fmt.print("\n")
		}
	}
}

z_halt :: proc(zcontext: rawptr, signal: z80.zuint8) {
	fmt.printf("\nhalt %d\n", signal)
	running = false
}

z_reti :: proc(zcontext: rawptr) {
	fmt.print("reti\n")
}

z_retn :: proc(zcontext: rawptr) {
	fmt.print("retn\n")
}

z_illegal :: proc(zcpu: z80.PZ80, opcode: z80.zuint8) -> z80.zuint8 {
	context = runtime.default_context()
	fmt.printf("illegal %d\n", opcode)
	return 10
}

reset :: proc() {
	fmt.print("memory reset\n")
	runtime.memset(&memory, 0, mem_size)
}

load_rom :: proc(filename: string) {
	reset()

	fmt.printf("loading rom %v\n", filename)

	data, ok := os.read_entire_file(filename)
	defer delete(data)

	if ok {
		rom_size := len(data)
		for i in 0 ..< rom_size {
			memory[i] = data[i]
		}
	} else {
		panic(fmt.tprintf("Unable to load rom %v\n", filename))
	}
}

main :: proc() {
	fmt.print("Z80 Emulator\n")

	load_rom(filepath.clean("../../data/hello.rom"))

	cpu: z80.Z80 = {
		fetch_opcode = z_fetch_opcode,
		fetch        = z_fetch,
		read         = z_read,
		write        = z_write,
		in_          = z_in,
		out          = z_out,
		halt         = z_halt,
		context_     = nil,
		nop          = nil,
		nmia         = nil,
		inta         = nil,
		int_fetch    = nil,
		ld_i_a       = nil,
		ld_r_a       = nil,
		reti         = z_reti,
		retn         = z_retn,
		hook         = nil,
		illegal      = z_illegal,
		options      = 0,
	}

	z80.z80_power(&cpu, true)
	z80.z80_instant_reset(&cpu)

	//cycles :: 4000
	//res := z80.z80_run(&cpu, cycles)
	//fmt.printf("\nRun %v\n", res)

	running = true
	total: z80.zusize = 0
	reps := 0
	for running {
		total += z80.z80_run(&cpu, cycles_per_tick)
		reps += 1
	}
	fmt.printf("total %v (%v)\n", total, reps)

	if dump_cpu {fmt.printf("CPU %v\n", cpu)}

	fmt.println("Done.")
}
