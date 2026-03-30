/* This file contains invalid subC features that should cause parse errors */

/* Invalid: typedef not allowed */
/* typedef int Integer; */

/* Invalid: union not allowed */
/* union Data {
    int i;
    char c;
}; */

/* Invalid: multi-dimensional array */
/* int matrix[10][10]; */

/* Invalid: function pointer */
/* int (*func_ptr)(int, int); */

/* Invalid: forward declaration */
/* int forward_func(int x); */

/* Invalid: unsupported types */
/* long big_num; */
/* short small_num; */
/* float decimal; */
/* double precision; */
/* unsigned positive; */
/* void nothing; */

/* Invalid: struct definition inside function */
int main() {
    /* struct LocalStruct {
        int x;
    }; */
    
    /* Invalid: function definition inside function */
    /* int inner_func() {
        return 1;
    } */
    
    return 0;
}
