
# The lute instruction according to the design document
# lute li, rs, rd
# right now only one lut is implemented, no selection between LUTs is needed, so li is always zero




#define TEST_LUT_OP( testnum, inst, result, val1 ) \
    TEST_CASE( testnum, x3, result, \
      li  x1, val1; \
      inst 0, x1, x2; \
    )

