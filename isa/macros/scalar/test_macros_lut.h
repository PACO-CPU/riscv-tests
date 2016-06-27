#ifndef __TEST_MACROS_APPR_SCALAR_H
#define __TEST_MACROS_APPR_SCALAR_H



#define LUT_TEST_CASE( testnum, testreg, correctval, code... ) \
test_ ## testnum: \
    code; \
    li  x29, correctval; \
    li  TESTNUM, testnum; \
    bne testreg, x29, fail;

# The lute instruction according to the design document
# lute li, rs, rd
# right now only one lut is implemented, no selection between LUTs is needed, so li is always zero

#define TEST_LUT_OP( testnum, inst, result, val1 ) \
    LUT_TEST_CASE( testnum, x3, result, \
      li  x1, val1; \
      inst x2, x1, 0; \
    )

#endif
