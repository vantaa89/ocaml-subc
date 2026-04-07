/* SEMANTIC ANALYZER TEST CASES - ALL IN ONE FILE */

/* ========== VALID CASES ========== */

/* Test 1: Valid variable declarations */
int global_int;
char global_char;
int *global_ptr;

/* Test 2: Valid arrays */
int arr[10];
char str[20];

/* Test 3: Valid struct declaration */
struct Point {
  int x;
  int y;
};

/* Test 4: Valid function with parameters */
int add(int a, int b) { return a + b; }

/* Test 5: Scope and local variables */
int scope_test() {
  int local_var;
  {
    int block_var;
    local_var = block_var;
  }
  return local_var;
}

/* Test 6: Valid arithmetic operations */
int arithmetic_test() {
  int a;
  int b;
  int c;
  a = 5;
  b = 10;
  c = a + b;
  c = a - b;
  c = a * b;
  c = a / b;
  c = a % b;
  return c;
}

/* Test 7: Valid pointer operations */
int pointer_test() {
  int x;
  int *ptr;
  ptr = &x;
  x = *ptr;
  return x;
}

/* Test 8: Valid array access */
int array_test() {
  int numbers[5];
  numbers[0] = 42;
  return numbers[0];
}

/* Test 9: Valid struct access */
int struct_test() {
  struct Point p;
  struct Point *pptr;
  p.x = 5;
  p.y = 10;
  pptr = &p;
  pptr->x = 15;
  return p.x;
}

/* Test 10: Valid comparisons */
int comparison_test() {
  int a;
  int b;
  char c;
  char d;
  int result;
  result = (a < b);
  result = (a == b);
  result = (c != d);
  return result;
}

/* Test 11: Valid logical operations */
int logical_test() {
  int a;
  int b;
  int result;
  result = a && b;
  result = a || b;
  result = !a;
  return result;
}

/* Test 12: Valid increment/decrement */
int inc_dec_test() {
  int x;
  char c;
  x++;
  ++x;
  x--;
  --x;
  c++;
  --c;
  return x;
}

/* Test 13: Valid NULL assignment */
int null_test() {
  int *ptr;
  ptr = NULL;
  return 0;
}

/* Test 14: Valid string and char literals */
int literal_test() {
  char *str;
  char c;
  c = 'a';
  return c;
}

/* ========== ERROR CASES ========== */

/* Test 15: Undeclared variable */
int undeclared_test() {
  undefined_var = 5; /* ERROR: undefined_var not declared */
  return 0;
}

/* Test 16: Redeclaration in same scope */
int redecl_test() {
  int x;
  int x; /* ERROR: redeclaration of x */
  return 0;
}

/* Test 17: Parameter redeclaration */
int param_redecl(int a, int a) { /* ERROR: parameter a redeclared */ return a; }

/* Test 18: Type mismatch in assignment */
int type_mismatch_test() {
  int x;
  char *ptr;
  x = ptr; /* ERROR: incompatible types */
  return 0;
}

/* Test 19: Invalid pointer arithmetic */
int invalid_ptr_arith() {
  int *ptr1;
  int *ptr2;
  int result;
  result = ptr1 + ptr2; /* ERROR: can't add two pointers */
  return 0;
}

/* Test 20: Invalid dereference */
int invalid_deref() {
  int x;
  int y;
  y = *x; /* ERROR: x is not a pointer */
  return 0;
}

/* Test 21: Invalid address-of */
int invalid_address() {
  int *ptr;
  ptr = &5; /* ERROR: can't take address of literal */
  return 0;
}

/* Test 22: Invalid array access */
int invalid_array() {
  int x;
  int y;
  y = x[0]; /* ERROR: x is not an array */
  return 0;
}

/* Test 23: Invalid struct access */
int invalid_struct() {
  int x;
  int y;
  y = x.field; /* ERROR: x is not a struct */
  return 0;
}

/* Test 24: Invalid function call */
int invalid_func_call() {
  int x;
  int y;
  y = x(); /* ERROR: x is not a function */
  return 0;
}

/* Test 25: Return type mismatch */
int return_mismatch() {
  char c;
  return c; /* ERROR: returning char from int function */
}

/* Test 26: Struct comparison */
int struct_comparison() {
  struct Point p1;
  struct Point p2;
  int result;
  result = (p1 == p2); /* ERROR: can't compare structs */
  return 0;
}

/* Test 27: Incomplete struct usage */
struct Incomplete *incomplete_test() {
  struct Incomplete *ptr; /* ERROR: struct Incomplete not defined */
  return ptr;
}

/* Test 28: Wrong argument count */
int wrong_args() {
  int result;
  result = add(5);       /* ERROR: add expects 2 arguments */
  result = add(1, 2, 3); /* ERROR: add expects 2 arguments */
  return result;
}

/* Test 29: Wrong argument type */
int wrong_arg_type() {
  int result;
  char *str;
  result = add(5, str); /* ERROR: second arg should be int */
  return result;
}

/* Test 30: Assignment to non-lvalue */
int non_lvalue_assign() {
  int x;
  int y;
  (x + y) = 5; /* ERROR: can't assign to expression */
  return 0;
}
