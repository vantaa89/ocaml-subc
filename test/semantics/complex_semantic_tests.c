/* COMPLEX SEMANTIC ANALYZER TEST CASES */

/* ========== NESTED STRUCT TESTS ========== */

struct Node {
  int data;
  struct Node *next;
};

struct List {
  struct Node *head;
  int count;
};

int nested_struct_valid() {
  struct List list;
  struct Node node;
  struct Node *ptr;

  list.head = &node;
  list.count = 1;
  node.data = 42;
  node.next = NULL;
  ptr = list.head;
  return ptr->data;
}

/* ========== FUNCTION POINTER TESTS ========== */

int func_with_array_param(int arr[10]) { return arr[0]; }

int *func_returning_ptr() {
  int *result;
  return result;
}

int complex_function_test() {
  int numbers[5];
  int *ptr_result;

  numbers[0] = 100;
  ptr_result = func_returning_ptr();
  return func_with_array_param(numbers);
}

/* ========== MULTI-DIMENSIONAL ARRAY SIMULATION ========== */

int matrix_test() {
  int rows[3];
  int data[3];
  int i;

  rows[0] = data;
  rows[1] = data;
  rows[2] = data;

  i = 0;
  rows[i][0] = 5;
  return rows[0][0];
}

/* ========== COMPLEX EXPRESSION TESTS ========== */

int complex_expressions() {
  int a;
  int b;
  int c;
  int *ptr;
  int arr[5];

  a = 10;
  b = 20;
  c = 30;
  ptr = &a;

  /* Complex valid expressions */
  c = (a + b) * (c - a);
  c = *ptr + arr[0];
  c = (a < b) && (c > a);
  c = !a || (b == c);
  ptr = &arr[a % 5];

  return c;
}

/* ========== RECURSIVE STRUCT DEFINITION ========== */

struct TreeNode {
  int value;
  struct TreeNode *left;
  struct TreeNode *right;
  struct TreeNode *parent;
};

int tree_operations() {
  struct TreeNode root;
  struct TreeNode child;

  root.value = 1;
  root.left = &child;
  root.right = NULL;
  root.parent = NULL;

  child.value = 2;
  child.left = NULL;
  child.right = NULL;
  child.parent = &root;

  return root.left->value;
}

/* ========== COMPLEX ERROR CASES - MULTIPLE ERRORS PER LINE ========== */

int multiple_errors_test() {
  int x;
  char c;
  int *ptr;
  int d;

  /* ERROR: undeclared + type mismatch + invalid operation */
  x = undefined_var + ptr + struct_var.field;

  /* ERROR: invalid dereference + undeclared + type mismatch */
  c = *x + unknown_func() + ptr;

  /* ERROR: invalid array access + undeclared + assignment to non-lvalue */
  (x + d) = y[z] + missing_var;
  (x + d) = 1;

  /* ERROR: invalid struct access + function call on non-function + type
   * mismatch */
  x = c.nonexistent + x() + ptr;

  /* ERROR: address of non-lvalue + invalid pointer arithmetic + undeclared */
  ptr = &(x + c) + another_ptr + undefined_ptr;

  return x;
}

/* ========== SCOPE COMPLEXITY TESTS ========== */

int x; /* global x */

int scope_complexity() {
  int y; /* local y */

  {
    int x; /* shadows global x */
    int z;

    x = 10;
    y = 20;
    z = 30;

    {
      int y; /* shadows outer y */
      int w;

      y = x + z; /* uses block x, outer z */
      w = y;

      /* ERROR: undeclared in this scope */
      w = undefined_in_deep_scope;
    }

    /* ERROR: w not accessible here */
    z = w;
  }

  /* ERROR: z not accessible here */
  return z;
}

/* ========== FUNCTION PARAMETER COMPLEXITY ========== */

int complex_params(int a, char *str, int arr[100], struct Node *node) {
  int result;

  result = a + arr[0];
  result = result + node->data;

  /* Valid operations */
  arr[a] = node->data;
  node->next = NULL;

  return result;
}

/* ERROR: parameter redeclaration with different types */
int param_errors(int x, char x, int *x) { return x; }

/* ========== ASSIGNMENT CHAIN ERRORS ========== */

int assignment_chain_test() {
  int a;
  int b;
  char c;
  int *ptr;

  /* Valid assignment chain */
  a = b = 5;

  /* ERROR: type mismatch in chain */
  a = ptr = c;

  /* ERROR: assignment to non-lvalue in chain */
  a = (b + c) = 10;

  /* ERROR: multiple type mismatches */
  ptr = c = a;

  return a;
}

/* ========== STRUCT POINTER CHAIN TESTS ========== */

struct Container {
  struct Node *node_ptr;
  int *int_ptr;
};

int struct_pointer_chains() {
  struct Container cont;
  struct Node node;
  int value;

  cont.node_ptr = &node;
  cont.int_ptr = &value;

  /* Valid complex access */
  cont.node_ptr->data = 42;
  value = *cont.int_ptr;

  /* ERROR: invalid chain - treating int as struct */
  value = cont.int_ptr->data;

  /* ERROR: invalid chain - treating struct as pointer */
  value = node->data;

  /* ERROR: accessing non-existent field */
  value = cont.nonexistent->data;

  return value;
}

/* ========== ARITHMETIC WITH MIXED TYPES ========== */

int mixed_arithmetic() {
  int i;
  char c;
  int *ptr;
  int arr[5];
  struct Node n1;
  struct Node n2;

  /* Valid arithmetic */
  i = i + c; /* char promotes to int */
  i = arr[i] + c;
  i = arr[i] + i;

  /* ERROR: pointer arithmetic violations */
  i = ptr + ptr; /* can't add two pointers */
  i = ptr * 2;   /* can't multiply pointer */
  i = ptr / 2;   /* can't divide pointer */
  i = ptr % 2;   /* can't mod pointer */

  i = n1 + n2; /* can't add structs */

  return i;
}

/* ========== FUNCTION CALL COMPLEXITY ========== */

int func_a(int x) { return x; }
char func_b(char c) { return c; }
int *func_c(int *p) { return p; }

int function_call_errors() {
  int result;
  char c;
  int *ptr;

  /* Valid calls */
  result = func_a(10);
  c = func_b('x');
  ptr = func_c(ptr);

  /* ERROR: wrong argument types */
  result = func_a(ptr);      /* int* to int */
  result = func_a("string"); /* string to int */
  c = func_b(
      result); /* int to char - might be valid depending on implementation */

  /* ERROR: wrong number of arguments */
  result = func_a();     /* missing argument */
  result = func_a(1, 2); /* too many arguments */

  /* ERROR: calling non-function */
  result = result(10); /* result is int, not function */
  result = ptr();      /* ptr is int*, not function */

  return result;
}

/* ========== RETURN STATEMENT COMPLEXITY ========== */

int return_errors() {
  int x;
  char c;
  int *ptr;

  if (x) {
    return c; /* ERROR: char returned from int function */
  }

  if (c) {
    return ptr; /* ERROR: int* returned from int function */
  }

  if (ptr) {
    return 'a';
  }

  return x; /* Valid */
}

char *string_return_errors() {
  int x;
  char c;

  if (x) {
    return x; /* ERROR: int returned from char* function */
  }

  if (c) {
    return &c; /* Valid: char* */
  }
}

/* ========== UNARY OPERATOR COMPLEXITY ========== */

int unary_operator_tests() {
  int x;
  char c;
  int *ptr;
  struct Node node;

  /* Valid unary operations */
  x = -x;
  x = !x;
  x++;
  ++x;
  x--;
  --x;
  c++;
  --c;

  /* ERROR: invalid unary operations */
  x = -ptr;  /* can't negate pointer */
  x = !node; /* can't logical-not struct */
  ptr++;     /* increment might be valid for pointers */
  node++;    /* ERROR: can't increment struct */

  /* ERROR: increment/decrement non-lvalues */
  (x + c)++; /* can't increment expression */
  ++(x * 2); /* can't increment expression */

  return x;
}

/* ========== ARRAY BOUNDS AND ACCESS COMPLEXITY ========== */

int array_complexity() {
  int arr[10];
  int *ptr;
  int x;
  char c;

  /* Valid array operations */
  arr[0] = 5;
  arr[x] = 10;
  ptr = arr;  /* array to pointer conversion */
  x = arr[c]; /* char index promotes to int */

  /* ERROR: invalid array access */
  x = ptr[ptr]; /* can't use pointer as index */
  x = arr[arr]; /* can't use array as index */

  /* ERROR: array access on non-array */
  x = x[0]; /* x is int, not array */
  x = c[5]; /* c is char, not array */

  return x;
}

/* ========== COMPREHENSIVE ERROR LINE ========== */

int ultimate_error_test() {
  int x;

  /* This line should generate multiple semantic errors */
  x = undefined1 + undefined2->nonexistent.field[undefined3] +
      (*x)(undefined4, undefined5) + (undefined6 + undefined7)++ + &(x + 5) +
      struct_literal.a.b.c;

  return x;
}
