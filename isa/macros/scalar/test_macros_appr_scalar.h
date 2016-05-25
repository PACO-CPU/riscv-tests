#ifndef __TEST_MACROS_APPR_SCALAR_H
#define __TEST_MACROS_APPR_SCALAR_H


# To test approximate instructions, we compare to lower and upper bound
# instead of correct value.

#define APPR_TEST_CASE( testnum, testreg, lowcorrect, highcorrect, code... ) \
test_ ## testnum: \
    code; \
    li  TESTNUM, testnum; \
    li  x29, lowcorrect; \
    bge x29, testreg, fail; \
    li  x29, highcorrect; \
    bge testreg, x29, fail;
   # unsure if ble/bge or bleu/bgeu should be used
   # also, strictly less and greater versions exist


# To limit complexity while trying to figure out testing for approximate
# instructions, only the test macros needed for approximate add instruction
# have been added in modified form. Recipes for the other test macros
# are in text_macros.h

#-----------------------------------------------------------------------
# Tests for an approximate instruction with register-register operands
#-----------------------------------------------------------------------

#define TEST_APPR_RR_OP( testnum, inst, lo, hi, val1, val2, nm ) \
    APPR_TEST_CASE( testnum, x3, lo, hi, \
      li  x1, val1; \
      li  x2, val2; \
      inst x3, x1, x2, nm; \
    )
# The rest of these test macros has not been tested!
#define TEST_APPR_RR_SRC1_EQ_DEST( testnum, inst, lo, hi, val1, val2, nm ) \
    TEST_CASE( testnum, x1, lo, hi, \
      li  x1, val1; \
      li  x2, val2; \
      inst x1, x1, x2; \
    )

#define TEST_APPR_RR_SRC2_EQ_DEST( testnum, inst, lo, hi, val1, val2, nm ) \
    TEST_CASE( testnum, x2, lo, hi, \
      li  x1, val1; \
      li  x2, val2; \
      inst x2, x1, x2; \
    )

#define TEST_APPR_RR_SRC12_EQ_DEST( testnum, inst, lo, hi, val1, nm ) \
    TEST_CASE( testnum, x1, lo, hi, \
      li  x1, val1; \
      inst x1, x1, x1; \
    )

#define TEST_APPR_RR_DEST_BYPASS( testnum, nop_cycles, inst, lo, hi, val1, val2 , nm ) \
    TEST_CASE( testnum, x6, lo, hi, \
      li  x4, 0; \
1:    li  x1, val1; \
      li  x2, val2; \
      inst x3, x1, x2; \
      TEST_INSERT_NOPS_ ## nop_cycles \
      addi  x6, x3, 0; \
      addi  x4, x4, 1; \
      li  x5, 2; \
      bne x4, x5, 1b \
    )

#define TEST_APPR_RR_SRC12_BYPASS( testnum, src1_nops, src2_nops, inst, lo, hi, val1, val2, nm ) \
    TEST_CASE( testnum, x3, lo, hi, \
      li  x4, 0; \
1:    li  x1, val1; \
      TEST_INSERT_NOPS_ ## src1_nops \
      li  x2, val2; \
      TEST_INSERT_NOPS_ ## src2_nops \
      inst x3, x1, x2; \
      addi  x4, x4, 1; \
      li  x5, 2; \
      bne x4, x5, 1b \
    )

#define TEST_APPR_RR_SRC21_BYPASS( testnum, src1_nops, src2_nops, inst, lo, hi, val1, val2, nm ) \
    TEST_CASE( testnum, x3, lo, hi, \
      li  x4, 0; \
1:    li  x2, val2; \
      TEST_INSERT_NOPS_ ## src1_nops \
      li  x1, val1; \
      TEST_INSERT_NOPS_ ## src2_nops \
      inst x3, x1, x2; \
      addi  x4, x4, 1; \
      li  x5, 2; \
      bne x4, x5, 1b \
    )

#define TEST_APPR_RR_ZEROSRC1( testnum, inst, lo, hi, val, nm) \
    TEST_CASE( testnum, x2, lo, hi, \
      li x1, val; \
      inst x2, x0, x1; \
    )

#define TEST_APPR_RR_ZEROSRC2( testnum, inst, lo, hi, val, nm ) \
    TEST_CASE( testnum, x2, lo, hi, \
      li x1, val; \
      inst x2, x1, x0; \
    )

#define TEST_APPR_RR_ZEROSRC12( testnum, inst, lo, hi, nm ) \
    TEST_CASE( testnum, x1, lo, hi, \
      inst x1, x0, x0; \
    )

#define TEST_APPR_RR_ZERODEST( testnum, inst, val1, val2, nm ) \
    TEST_CASE( testnum, x0, 0, \
      li x1, val1; \
      li x2, val2; \
      inst x0, x1, x2; \

#endif
