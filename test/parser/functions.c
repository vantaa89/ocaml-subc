/* Test function definitions - only allowed in global scope */

int add(int a, int b) {
    return a + b;
}

char getChar(char arr[1000], int index) {
    return arr[index];
}

int factorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}

int main() {
    int result;
    char buffer[10];
    result = add(5, 3);
    buffer[0] = 'h';
    return factorial(5);
}
