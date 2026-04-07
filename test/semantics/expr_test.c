int func1() { return 0; }

int func2(int *a, char *b) {
  int a;
  int *a;
  char a;
  return (a == NULL);
}

int func2() {}

int test1() {
  int a;
  a = (1 + 'a') + (1 - 'a');
}

int test2() {
  int *a;
  if (a == NULL) {
  }
  if (NULL == a) {
  }
}

int null_check() {
  int *a;
  a = NULL;
  if (a == NULL) {
    int *b;
  }
}

int undeclaraed() {
  a = 0;
  {
    int a;
  }
  a = 0;
  foo();
}

int test3() { int *a[5]; }

int test4() {
  int *a;
  int *b;
  char *c;

  int result;
  result = func1(a);
  result = func1();
  result = func2();
  result = func2(a, b, b);
  result = func2(a, b);
  result = func2(a, c);
  return result;
}

struct str1 {
  char *a;
  int b;
  struct str2 {
    int a;
    char b;
  } *c;
};

int test5() {
  int a;
  int *b;
  char c[10];
  struct str1 st;
  &(a);
  &(1);
  *b;
  *(b);
  *0;
  *(0);
  *('a');

  &st;
  &(st);
  &(st.a);
  &(st.b);
  *st.a;
  *(st.a);
  *st.b;
  *(st.b);
  &(st.c->a);
  &(st.c);
  *(st.c);
  (st).a;
  *((st).a);
  &(st).b;
  (st.c)->a;
  &(st.c)->b;
}

int arrfunc(int a[10], char b[5]) {}
int test6() {
  int c[10];
  int d[3];
  char e[4];
  arrfunc();
  arrfunc(c, d);
  arrfunc(c, e);
  arrfunc(c, e[0]);
  arrfunc(c[0], e[0]);
}

int test7() {
  int a;
  (++a) = 10;
  (b) = (NULL);
}