int func1() { return 1; }
int func2() { return 2; }

struct str1 {
  int a;
  int* b;
};

int main() {
  int a;
  int* b;
  char c;
  char* d;
  struct str1 s1;
  struct str1 s2;
  struct str1* sp;

  a = 1;
  b = &(a);
  b = &(1); /* error */
  b = &(a);
  *(b) = a;
  c = ('a');
  d = &((c));
  d = &(('a')); /* error */
  a = (func1() + func2());
  b = &(func1() + func2()); /* error */
  s2 = (s1);
  sp = &(s1);
}