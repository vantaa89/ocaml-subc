/* testcase of project3_slides.pdf */
int redeclaration() {
  int a;
  int a;  /* error: redeclaration */
  char a; /* error: redeclaration */
  for (;;) {
    int a;
    for (;;) {
      int a;
    }
  }
}

int typecheck_assign1() {
  int a;
  char b;
  a = b;    /* error: incompatible types for assignment operation*/
  5 = a;    /* error: lvalue is not assignable */
  a = NULL; /* error: cannot assign 'NULL' to non-pointer type */
  a = 5;    /* legal */
}

int typecheck_assign2() {
  int *a;
  int b[10];
  a = b; /* error: incompatible types for assignment operation*/
  b = a; /* error: lvalue is not assignable */
}

int typecheck_assign3() {
  int *a[5];
  int *b;
  int c[10];
  struct temp1 {
    int a;
  } *s1;
  struct temp1 s2;
  struct temp2 {
    int b;
  } *s3;
  a = b;    /* error: lvalue is not assignable */
  b = c;    /* error: incompatible types for assignment operation */
  s1 = s3;  /* error: incompatible types for assignment operation */
  s1 = s2;  /* error: incompatible types for assignment operation */
  s1 = &s2; /* legal */
}

int typecheck_unary1() {
  int a;
  char b;
  a = 10;
  b = 'a';
  a = -a; /* legal */
  b = -b; /* error */
}

int typecheck_unary2() {
  int a;
  char b;
  int *c;
  char d[10];
  struct str0 {
    int a;
  } e;

  a++;
  --a;
  b++;
  c++; /* error */
  --d; /* error */
  ++e; /* error */
}

int typecheck_binary1() {
  int result;
  int a;
  int b;
  result = (a > 5) || (a <= b);
}

int typecheck_binary2() {
  int result;
  int *a;
  int *b;
  char *c;
  result = (a == b);
  result = (a == c); /* error */
}

int typecheck_binary3() {
  int *a;
  int b;
  int c[10];
  a = 0; /* error: incompatible types for assignment operation */
  a = NULL;
  a = &b;
  a = *b; /* error: indirection requires pointer operand */
  &b = a; /* error: lvalue is not assignable */
  b = &c; /* error: cannot take the address of an rvalue */
  b = 0;
  b = *a;
}

struct str1 {
  int i;
  char c;
};
int typecheck_struct() {
  struct str1 st1;
  struct str1 *pst1;

  int i;
  i = st1.i;
  i = st1.i2; /* error: no such member in struct */
  i = st1->i; /* error: member reference base type is not a struct pointer */
  i = pst1->i;
  i = pst1.i; /* error: member reference base type is not a struct */
}

int typecheck_array() {
  int a[5];
  int b;
  char c;
  b = a[1];
  a[1] = b;
  a[1] = b[1]; /* error: subscripted value is not an array */
  a[b];
  a[c]; /* error: array subscript is not an integer */
}

/* struct declaration */
struct a {
  struct b x;  /* error: incomplete type */
  struct b *p; /* error: incomplete type */
  struct b {
  } y;
};
struct b {}; /* error: redeclaration */
int struct_declaration() {
  struct b {
  } x; /* error: redeclaration */
}

/* function declaration */
int func1(int a, char b) { return 0; }
int func2(int a, char b) { return 'c'; } /* error:incompatible return types */
int func1() {}                           /* error: redeclaration */
int main() {
  int a;
  int b;
  char c;
  b = func1(a, b); /* error: incompatible arguments in function call */
  b = func1(a, c);
  c = func1(a, c); /* error: incompatible types for assignment operation */
  b = a();         /* error: not a function */
}

int skip_errcode() {
  int a;
  char a;  /* error */
  a = 1;   /* legal (int) = (int) */
  a = 'c'; /* error */
}

int multiple_errors() {
  int a;
  func1 = a[1]; /* error: subscripted value is not an array */
  func1 = a;    /* error: lvalue is not assignable */
  return 1;
}
