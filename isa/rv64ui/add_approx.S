# See LICENSE for license details.

#*****************************************************************************
# addax.S , derived from add.S
#-----------------------------------------------------------------------------
#
# Test approximate add instruction.
#

#include "riscv_test.h"
#include "test_macros_appr_scalar.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests with non-approximate instructions are done with
  #  TEST_RR_OP( testnum, inst, result, val1, val2 )
  #
  # So how do the macros work?
  # TEST_RR_OP defines one of several wrappers for the TEST_CASE macro,
  # defined in test_macros.h:
  #
  # TEST_RR_OP( testnum, inst, result, val1, val2 ) \
  #   TEST_CASE( testnum, x3, result, \
  #     li  x1, val1; \
  #     li  x2, val2; \
  #     inst x3, x1, x2; \
  #   )
  #
  # TEST_CASE( testnum, testreg, correctval, code... ) \
  # test_ ## testnum: \
  #     code; \
  #     li  x29, correctval; \
  #     li  TESTNUM, testnum; \
  #     bne testreg, x29, fail;
  #
  # By my understanding, TEST_CASE will execute the code from the wrapper
  # and compare the result of the code to the correct one given in the test
  # case.
  # 
  # To compile, add a new line to riscv-tests/isa/rv64ui/Makefrag:
  #         add_approx \
  #-------------------------------------------------------------

  #TEST_RR_OP( 2,  add, 0x00000000, 0x00000000, 0x00000000 );
  #TEST_RR_OP( 3,  add, 0x00000002, 0x00000001, 0x00000001 );
  #TEST_RR_OP( 4,  add, 0x0000000a, 0x00000003, 0x00000007 );

  #TEST_APPR_RR_OP( Test#, instruction type, lo, hi, val1, val2, neglect mask);
  # Acceptable levels of approximation:
  #   0x0000003f / 3e / 3c / 38 / 30 / 20 / 00

  # Mostafa's test cases:
  TEST_RR_OP( 2,  add, 0x0002223a, 0x0001d3e7, 0x00004e53 );
  TEST_APPR_RR_OP( 3,  add.approx, 0x0000004a, 0x0000004a, 0x00000034, 0x00000012, 0x0000003f);
  TEST_APPR_RR_OP( 4,  add.approx, 0x00000836, 0x00000836, 0x00000775, 0x000000c9, 0x0000003e);

  #TEST_RR_OP( 5,  add, 0xffffffffffff8000, 0x0000000000000000, 0xffffffffffff8000 );
  #TEST_RR_OP( 6,  add, 0xffffffff80000000, 0xffffffff80000000, 0x00000000 );
  #TEST_RR_OP( 7,  add, 0xffffffff7fff8000, 0xffffffff80000000, 0xffffffffffff8000 );

  #TEST_RR_OP( 8,  add, 0x0000000000007fff, 0x0000000000000000, 0x0000000000007fff );
  #TEST_RR_OP( 9,  add, 0x000000007fffffff, 0x000000007fffffff, 0x0000000000000000 );
  #TEST_RR_OP( 10, add, 0x0000000080007ffe, 0x000000007fffffff, 0x0000000000007fff );

  #TEST_RR_OP( 11, add, 0xffffffff80007fff, 0xffffffff80000000, 0x0000000000007fff );
  #TEST_RR_OP( 12, add, 0x000000007fff7fff, 0x000000007fffffff, 0xffffffffffff8000 );

  #TEST_RR_OP( 13, add, 0xffffffffffffffff, 0x0000000000000000, 0xffffffffffffffff );
  #TEST_RR_OP( 14, add, 0x0000000000000000, 0xffffffffffffffff, 0x0000000000000001 );
  #TEST_RR_OP( 15, add, 0xfffffffffffffffe, 0xffffffffffffffff, 0xffffffffffffffff );

  #TEST_RR_OP( 16, add, 0x0000000080000000, 0x0000000000000001, 0x000000007fffffff );

  #-------------------------------------------------------------
  # Source/Destination tests
  #-------------------------------------------------------------

  #TEST_RR_SRC1_EQ_DEST( 17, add, 24, 13, 11 );
  #TEST_RR_SRC2_EQ_DEST( 18, add, 25, 14, 11 );
  #TEST_RR_SRC12_EQ_DEST( 19, add, 26, 13 );

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  #TEST_RR_DEST_BYPASS( 20, 0, add, 24, 13, 11 );
  #TEST_RR_DEST_BYPASS( 21, 1, add, 25, 14, 11 );
  #TEST_RR_DEST_BYPASS( 22, 2, add, 26, 15, 11 );

  #TEST_RR_SRC12_BYPASS( 23, 0, 0, add, 24, 13, 11 );
  #TEST_RR_SRC12_BYPASS( 24, 0, 1, add, 25, 14, 11 );
  #TEST_RR_SRC12_BYPASS( 25, 0, 2, add, 26, 15, 11 );
  #TEST_RR_SRC12_BYPASS( 26, 1, 0, add, 24, 13, 11 );
  #TEST_RR_SRC12_BYPASS( 27, 1, 1, add, 25, 14, 11 );
  #TEST_RR_SRC12_BYPASS( 28, 2, 0, add, 26, 15, 11 );

  #TEST_RR_SRC21_BYPASS( 29, 0, 0, add, 24, 13, 11 );
  #TEST_RR_SRC21_BYPASS( 30, 0, 1, add, 25, 14, 11 );
  #TEST_RR_SRC21_BYPASS( 31, 0, 2, add, 26, 15, 11 );
  #TEST_RR_SRC21_BYPASS( 32, 1, 0, add, 24, 13, 11 );
  #TEST_RR_SRC21_BYPASS( 33, 1, 1, add, 25, 14, 11 );
  #TEST_RR_SRC21_BYPASS( 34, 2, 0, add, 26, 15, 11 );

  #TEST_RR_ZEROSRC1( 35, add, 15, 15 );
  #TEST_RR_ZEROSRC2( 36, add, 32, 32 );
  #TEST_RR_ZEROSRC12( 37, add, 0 );
  #TEST_RR_ZERODEST( 38, add, 16, 30 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
