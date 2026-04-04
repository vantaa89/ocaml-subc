Semantic analysis tests

  $ ../../src/main.exe --check < var_def.c
  7: error: redeclaration of a
  9: error: redeclaration of b
  14: error: The symbol e is unbound
  [1]

  $ ../../src/main.exe --check < func_op.c
  20: error: return type mismatch: expected Int, got Char
  34: error: func1: expected 2 args, got 3
  35: error: func2: expected 0 args, got 1
  39: error: func3: argument type mismatch
  41: error: incompatible types for assignment operation
  42: error: func3: argument type mismatch
  42: error: incompatible types for assignment operation
  [1]

  $ ../../src/main.exe --check < ptr_op.c
  9: error: incompatible types for assignment operation
  13: error: incompatible types for assignment operation
  15: error: incompatible types for assignment operation
  16: error: incompatible types for binary operation
  16: error: dereferencing a non-pointer type
  16: error: incompatible types for assignment operation
  17: error: incompatible types for assignment operation
  20: error: incompatible types for assignment operation
  21: error: incompatible types for assignment operation
  23: error: incompatible types for assignment operation
  24: error: incompatible types for assignment operation
  [1]

  $ ../../src/main.exe --check < str_op.c
  17: error: redeclaration of str3
  35: error: incompatible types for assignment operation
  39: error: incompatible types for assignment operation
  41: error: incompatible types for assignment operation
  44: error: incompatible types for assignment operation
  [1]
