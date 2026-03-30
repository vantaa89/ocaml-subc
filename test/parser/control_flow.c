/* Test control flow structures */

int main() {
    int i;
    int j;
    int sum;
    
    sum = 0;
    
    /* if-else */
    if (sum == 0) {
        sum = 1;
    } else {
        sum = 2;
    }
    
    /* while loop */
    i = 0;
    while (i < 10) {
        sum = sum + i;
        i = i + 1;
    }
    
    /* for loop */
    for (j = 0; j < 5; j = j + 1) {
        if (j == 3) {
            continue;
        }
        sum = sum * 2;
        if (sum > 100) {
            break;
        }
    }
    
    return sum;
}
