/* Test pointers - no function pointers allowed */
int global_var;

int modify(int *ptr) {
    *ptr = *ptr + 10;
    return *ptr;
}

int main() {
    int x;
    int *p;
    char *str;
    char buffer[20];
    
    x = 42;
    p = &x;
    str = buffer;
    
    *p = 100;
    *str = 'A';
    
    modify(&global_var);
    
    return *p;
}
