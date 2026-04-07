Semantic analysis tests

  $ ../../src/main.exe --check < var_def.c
  7: error: redeclaration
  9: error: redeclaration
  14: error: use of undeclared identifier
  [1]

  $ ../../src/main.exe --check < func_op.c
  20: error: incompatible return types
  34: error: incompatible arguments in function call
  35: error: incompatible arguments in function call
  39: error: incompatible arguments in function call
  41: error: incompatible types for assignment operation
  42: error: incompatible arguments in function call
  [1]

  $ ../../src/main.exe --check < ptr_op.c
  9: error: lvalue is not assignable
  13: error: cannot take the address of an rvalue
  15: error: incompatible types for assignment operation
  16: error: invalid operands to binary expression
  17: error: invalid argument type to unary expression
  18: error: invalid argument type to unary expression
  20: error: incompatible types for assignment operation
  21: error: incompatible types for assignment operation
  23: error: incompatible types for assignment operation
  24: error: invalid argument type to unary expression
  25: error: invalid argument type to unary expression
  27: error: types are not comparable in binary expression
  [1]

  $ ../../src/main.exe --check < str_op.c
  17: error: redeclaration
  35: error: incompatible types for assignment operation
  39: error: incompatible types for assignment operation
  41: error: incompatible types for assignment operation
  44: error: incompatible types for assignment operation
  [1]

  $ ../../src/main.exe --check < complex_semantic_tests.c
  53: error: incompatible types for assignment operation
  54: error: incompatible types for assignment operation
  55: error: incompatible types for assignment operation
  58: error: subscripted value is not an array
  59: error: subscripted value is not an array
  121: error: use of undeclared identifier
  124: error: indirection requires pointer operand
  127: error: use of undeclared identifier
  128: error: lvalue is not assignable
  132: error: member reference base type is not a struct
  135: error: invalid operands to binary expression
  163: error: use of undeclared identifier
  167: error: use of undeclared identifier
  171: error: use of undeclared identifier
  190: error: redeclaration
  204: error: incompatible types for assignment operation
  207: error: invalid operands to binary expression
  210: error: incompatible types for assignment operation
  235: error: member reference base type is not a struct pointer
  238: error: member reference base type is not a struct pointer
  241: error: no such member in struct
  257: error: invalid operands to binary expression
  258: error: invalid operands to binary expression
  262: error: invalid operands to binary expression
  263: error: invalid operands to binary expression
  264: error: invalid operands to binary expression
  265: error: invalid operands to binary expression
  267: error: invalid operands to binary expression
  289: error: incompatible arguments in function call
  290: error: incompatible arguments in function call
  292: error: incompatible arguments in function call
  295: error: incompatible arguments in function call
  296: error: incompatible arguments in function call
  299: error: not a function
  300: error: not a function
  313: error: incompatible return types
  317: error: incompatible return types
  321: error: incompatible return types
  332: error: incompatible return types
  359: error: invalid argument type to unary expression
  360: error: invalid argument type to unary expression
  361: error: invalid argument type to unary expression
  362: error: invalid argument type to unary expression
  365: error: invalid operands to binary expression
  366: error: invalid argument type to unary expression
  382: error: incompatible types for assignment operation
  383: error: array subscript is not an integer
  386: error: subscripted value is not an array
  386: error: array subscript is not an integer
  387: error: array subscript is not an integer
  390: error: subscripted value is not an array
  391: error: subscripted value is not an array
  402: error: use of undeclared identifier
  403: error: indirection requires pointer operand
  404: error: use of undeclared identifier
  [1]

  $ ../../src/main.exe --check < complex_test_1.c
  123: error: incompatible types for assignment operation
  124: error: subscripted value is not an array
  125: error: subscripted value is not an array
  244: error: incompatible types for assignment operation
  291: error: incompatible types for assignment operation
  317: error: redeclaration
  319: error: use of undeclared identifier
  324: error: incompatible types for assignment operation
  330: error: member reference base type is not a struct pointer
  336: error: array subscript is not an integer
  339: error: incompatible arguments in function call
  341: error: incompatible return types
  [1]

  $ ../../src/main.exe --check < expr.c
  20: error: cannot take the address of an rvalue
  25: error: cannot take the address of an rvalue
  27: error: cannot take the address of an rvalue
  [1]

  $ ../../src/main.exe --check < expr_test.c
  4: error: redeclaration
  5: error: redeclaration
  6: error: redeclaration
  10: error: redeclaration
  14: error: invalid operands to binary expression
  34: error: use of undeclared identifier
  38: error: use of undeclared identifier
  39: error: use of undeclared identifier
  50: error: incompatible arguments in function call
  52: error: incompatible arguments in function call
  53: error: incompatible arguments in function call
  54: error: incompatible arguments in function call
  74: error: cannot take the address of an rvalue
  77: error: indirection requires pointer operand
  78: error: indirection requires pointer operand
  79: error: indirection requires pointer operand
  87: error: indirection requires pointer operand
  88: error: indirection requires pointer operand
  104: error: incompatible arguments in function call
  105: error: incompatible arguments in function call
  107: error: incompatible arguments in function call
  108: error: incompatible arguments in function call
  113: error: lvalue is not assignable
  114: error: use of undeclared identifier
  [1]

  $ ../../src/main.exe --check < semantic_tests1.c
  124: error: incompatible return types
  131: error: use of undeclared identifier
  138: error: redeclaration
  143: error: redeclaration
  149: error: incompatible types for assignment operation
  158: error: invalid operands to binary expression
  166: error: indirection requires pointer operand
  173: error: cannot take the address of an rvalue
  181: error: subscripted value is not an array
  189: error: member reference base type is not a struct
  197: error: not a function
  204: error: incompatible return types
  212: error: types are not comparable in binary expression
  217: error: incomplete type
  218: error: incomplete type
  219: error: use of undeclared identifier
  225: error: incompatible arguments in function call
  226: error: incompatible arguments in function call
  234: error: incompatible arguments in function call
  242: error: lvalue is not assignable
  [1]

  $ ../../src/main.exe --check < slide.c
  4: error: redeclaration
  5: error: redeclaration
  17: error: incompatible types for assignment operation
  18: error: lvalue is not assignable
  19: error: cannot assign 'NULL' to non-pointer type
  26: error: incompatible types for assignment operation
  27: error: lvalue is not assignable
  41: error: lvalue is not assignable
  42: error: incompatible types for assignment operation
  43: error: incompatible types for assignment operation
  44: error: incompatible types for assignment operation
  54: error: invalid argument type to unary expression
  69: error: invalid argument type to unary expression
  70: error: invalid argument type to unary expression
  71: error: invalid argument type to unary expression
  87: error: types are not comparable in binary expression
  94: error: incompatible types for assignment operation
  97: error: indirection requires pointer operand
  98: error: lvalue is not assignable
  99: error: cannot take the address of an rvalue
  114: error: no such member in struct
  115: error: member reference base type is not a struct pointer
  117: error: member reference base type is not a struct
  126: error: subscripted value is not an array
  128: error: array subscript is not an integer
  133: error: incomplete type
  134: error: incomplete type
  138: error: redeclaration
  140: error: redeclaration
  146: error: incompatible return types
  147: error: redeclaration
  152: error: incompatible arguments in function call
  154: error: incompatible types for assignment operation
  155: error: not a function
  160: error: redeclaration
  162: error: incompatible types for assignment operation
  167: error: subscripted value is not an array
  168: error: lvalue is not assignable
  [1]
