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
  
  # for these tests to succeed, I expect the memory to have next values
  # address    value
  # 0x00       0x0000000f  
  # 0x01       0x000000ff  
  # 0x02       0x00000f5f        

  # lute's test cases:
  TEST_LUT_OP( 2,  lute, 0x0000000f, 0x00000000 );
  TEST_LUT_OP( 3,  lute, 0x000000ff, 0x00000001 );
  TEST_LUT_OP( 4,  lute, 0x00000f5f, 0x00000003 );



  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
