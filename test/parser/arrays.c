/* Test arrays - no multi-dimensional arrays allowed */
int numbers[100];
char text[50];

int processArray(int arr[20], int size) {
    int i;
    int sum;
    sum = 0;
    for (i = 0; i < size; i = i + 1) {
        sum = sum + arr[i];
    }
    return sum;
}

int main() {
    int local_array[20];
    char message[30];
    int i;
    
    for (i = 0; i < 20; i = i + 1) {
        local_array[i] = i * 2;
    }
    
    message[0] = 'H';
    message[1] = 'i';
    message[2] = '\0';
    
    return processArray(local_array, 20);
}
