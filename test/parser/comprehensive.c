/* Comprehensive test combining multiple subC features */

struct Student {
    char name[30];
    int id;
    int grades[5];
};

int students_count;
struct Student classroom[50];

int calculateAverage(int scores[5], int count) {
    int sum;
    int i;
    sum = 0;
    for (i = 0; i < count; i = i + 1) {
        sum = sum + scores[i];
    }
    return sum / count;
}

int findStudent(int student_id) {
    int i;
    for (i = 0; i < students_count; i = i + 1) {
        if (classroom[i].id == student_id) {
            return i;
        }
    }
    return -1;
}

int main() {
    int index;
    int avg;
    char *name_ptr;
    
    students_count = 2;
    
    /* Initialize first student */
    classroom[0].id = 12345;
    classroom[0].name[0] = 'J';
    classroom[0].name[1] = 'o';
    classroom[0].name[2] = 'h';
    classroom[0].name[3] = 'n';
    classroom[0].name[4] = '\0';
    classroom[0].grades[0] = 85;
    classroom[0].grades[1] = 92;
    classroom[0].grades[2] = 78;
    classroom[0].grades[3] = 88;
    classroom[0].grades[4] = 95;
    
    /* Initialize second student */
    classroom[1].id = 67890;
    name_ptr = classroom[1].name;
    *name_ptr = 'A';
    *(name_ptr + 1) = 'n';
    *(name_ptr + 2) = 'n';
    *(name_ptr + 3) = 'a';
    *(name_ptr + 4) = '\0';
    
    index = findStudent(12345);
    if (index != -1) {
        avg = calculateAverage(classroom[index].grades, 5);
    }
    
    return avg;
}
