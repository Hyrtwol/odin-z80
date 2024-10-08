#include <odintestgen.h>
#include "Z80.h"
#include <Z/types/integral.h>

#define zint16 ZInt16
#define zint32 ZInt32
#define zcontext void*

void verify_type_sizes(ofstream& out) {
	test_proc_begin();
    test_proc_comment("integral.h");
    expect_size(zusize);
    expect_size(zuint8);
    expect_size(zuint16);
    expect_size(zuint32);
    expect_size(zint16);
    expect_size(zint32);
    expect_size(zboolean);
    expect_size(zcontext);
    test_proc_comment("Z80.h");
    expect_value(Z80_MAXIMUM_CYCLES_PER_STEP);
    expect_value(Z80_MINIMUM_CYCLES_PER_STEP);
    expect_value(Z80_HOOK);
    expect_value(Z80_SF);
    expect_value(Z80_ZF);
    expect_value(Z80_YF);
    expect_value(Z80_HF);
    expect_value(Z80_XF);
    expect_value(Z80_PF);
    expect_value(Z80_NF);
    expect_value(Z80_CF);

	expect_size(Z80);

    expect_value(Z80_OPTION_OUT_VC_255);
    expect_value(Z80_OPTION_LD_A_IR_BUG);
    expect_value(Z80_OPTION_HALT_SKIP);
    expect_value(Z80_OPTION_XQ);
    expect_value(Z80_OPTION_IM0_RETX_NOTIFICATIONS);
    expect_value(Z80_OPTION_YQ);
    expect_value(Z80_MODEL_ZILOG_NMOS);
    expect_value(Z80_MODEL_ZILOG_CMOS);
    expect_value(Z80_MODEL_NEC_NMOS);
    expect_value(Z80_MODEL_ST_CMOS);
    expect_value(Z80_REQUEST_REJECT_NMI);
    expect_value(Z80_REQUEST_NMI);
    expect_value(Z80_REQUEST_INT);
    expect_value(Z80_REQUEST_SPECIAL_RESET);
    expect_value(Z80_RESUME_HALT);
    expect_value(Z80_RESUME_XY);
    expect_value(Z80_RESUME_IM0_XY);
    expect_value(Z80_HALT_EXIT_EARLY);
    expect_value(Z80_HALT_CANCEL);

	test_proc_end();
}

void test_z80(ofstream& out) {
    package_header();
    out << "import sut \"..\"" << endl;
    verify_type_sizes(out);
	//verify_macros(out);
}

int main(int argc, char* argv[]) {
	if (argc < 2) { cout << "Usage: " << path(argv[0]).filename().string() << " <odin-output-file>" << endl; return -1; }
	auto filepath = path(argv[1]);
	cout << "Writing " << filepath.string() << endl;
	ofstream out(filepath);
    test_z80(out);
	out.close();
}
