int factorial(int n) {
  if (n <= 1) {
    return 1;
  }
  return n * factorial(n - 1);
}

int main() {
  int i;
  for (i = 1; i <= 5; i = i + 1) {
    printf("%d\n", factorial(i));
  }
  return 0;
}
