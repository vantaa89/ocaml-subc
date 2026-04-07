/* Semantic Analyzer Test Cases for SubC Language */

/* ========== BASIC TYPE DECLARATIONS ========== */

/* Valid basic type declarations */
int x;
char c;
int *ptr;
char *cptr;

/* Array declarations */
int arr[10];
char str[100];

/* ========== STRUCT DECLARATIONS ========== */

/* Valid struct declaration */
struct Point {
  int x;
  int y;
};

/* Struct with pointer members */
struct Node {
  int data;
  struct Node *next;
};

/* Struct pointer declaration */
struct Point *pptr;

/* ========== FUNCTION DECLARATIONS ========== */

/* Simple function */
int add(int a, int b) { return a + b; }

/* Function with no parameters */
int print_hello() { return 0; }

/* Function with array parameter */
int sum_array(int arr[10]) {
  int i;
  int total;
  total = 0;
  for (i = 0; i < 10; i = i + 1) {
    total = total + arr[i];
  }
  return total;
}

/* Function with struct parameter */
int distance(struct Point p1, struct Point p2) {
  int dx;
  int dy;
  dx = p1.x - p2.x;
  dy = p1.y - p2.y;
  return dx * dx + dy * dy;
}

/* ========== VARIABLE SCOPING TESTS ========== */

int global_var;

int scope_test() {
  int local_var;
  {
    int inner_var;
    local_var = 5;
    inner_var = 10;
  }
  return local_var;
}

/* ========== EXPRESSION TESTS ========== */

int expression_tests() {
  int a;
  int b;
  int result;

  /* Arithmetic expressions */
  a = 10;
  b = 20;
  result = a + b;
  result = a - b;
  result = a * b;
  result = a / b;
  result = a % b;

  /* Logical expressions */
  result = a && b;
  result = a || b;
  result = !a;

  /* Comparison expressions */
  result = a < b;
  result = a > b;
  result = a <= b;
  result = a >= b;
  result = a == b;
  result = a != b;

  /* Increment/decrement */
  a++;
  ++a;
  a--;
  --a;

  return result;
}

/* ========== POINTER TESTS ========== */

int pointer_tests() {
  int x;
  int *ptr;
  int arr[5];

  x = 42;
  ptr = &x;
  *ptr = 100;

  ptr = arr;
  ptr[0] = 1;
  ptr[1] = 2;

  return *ptr;
}

/* ========== STRUCT ACCESS TESTS ========== */

int struct_tests() {
  struct Point p;
  struct Point *pptr;

  p.x = 10;
  p.y = 20;

  pptr = &p;
  pptr->x = 30;
  pptr->y = 40;

  return p.x + p.y;
}

/* ========== CONTROL FLOW TESTS ========== */

int control_flow_tests(int n) {
  int i;
  int sum;

  /* If-else statement */
  if (n > 0) {
    sum = n;
  } else {
    sum = 0;
  }

  /* While loop */
  i = 0;
  while (i < n) {
    sum = sum + i;
    i++;
  }

  /* For loop */
  for (i = 0; i < n; i++) {
    if (i == 5) {
      break;
    }
    if (i == 2) {
      continue;
    }
    sum = sum + i;
  }

  return sum;
}

/* ========== FUNCTION CALL TESTS ========== */

int factorial(int n) {
  if (n <= 1) {
    return 1;
  }
  return n * factorial(n - 1);
}

int function_call_tests() {
  int result;
  struct Point p1;
  struct Point p2;

  result = add(5, 10);
  result = factorial(5);

  p1.x = 0;
  p1.y = 0;
  p2.x = 3;
  p2.y = 4;
  result = distance(p1, p2);

  return result;
}

/* ========== NULL POINTER TESTS ========== */

int null_tests() {
  int *ptr;
  struct Node *node;

  ptr = NULL;
  node = NULL;

  if (ptr == NULL) {
    return 1;
  }

  return 0;
}

/* ========== ARRAY ACCESS TESTS ========== */

int array_tests() {
  int arr[10];
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < 10; i++) {
    arr[i] = i * i;
    sum = sum + arr[i];
  }

  return sum;
}

/* ========== STRING TESTS ========== */

char *string_tests() {
  char *msg;
  char buffer[100];

  msg = "Hello, World!";
  return msg;
}

/* ========== COMPLEX NESTED STRUCTURES ========== */

struct LinkedList {
  int data;
  struct LinkedList *next;
};

int linked_list_test() {
  struct LinkedList head;
  struct LinkedList second;
  struct LinkedList *current;

  head.data = 1;
  head.next = &second;

  second.data = 2;
  second.next = NULL;

  current = &head;
  while (current != NULL) {
    current = current->next;
  }

  return head.data;
}

/* ========== ASSIGNMENT COMPATIBILITY TESTS ========== */

int assignment_tests() {
  int i;
  char c;
  int *iptr;
  char *cptr;

  /* Basic assignments */
  i = 42;
  c = 'A';

  /* Pointer assignments */
  iptr = &i;
  cptr = &c;

  /* Character to int promotion */
  i = c;

  return i;
}

/* ========== MAIN FUNCTION ========== */

int main() {
  int result;

  result = expression_tests();
  result = pointer_tests();
  result = struct_tests();
  result = control_flow_tests(10);
  result = function_call_tests();
  result = null_tests();
  result = array_tests();
  result = linked_list_test();
  result = assignment_tests();

  return result;
}

/* ========== ERROR CASES (Should be caught by semantic analyzer) ========== */

int duplicate_var;
int duplicate_var;

int use_undeclared() { return undefined_var; }

int type_error() {
  int x;
  struct Point p;
  x = p;
  return x;
}

int pointer_error() {
  int x;
  return x->field;
}

int array_error() {
  int arr[10];
  struct Point p;
  return arr[p];
}

int call_error() { return add(1, 2, 3); }

struct Point return_error() { return 42; }

int control_error() {
  break;
  return 0;
}
