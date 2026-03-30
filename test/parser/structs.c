/* Test struct definitions - only allowed in global scope */
struct Point {
    int x;
    int y;
};

struct Person {
    char name[50];
    int age;
};

int main() {
    struct Point p;
    struct Person person;
    p.x = 10;
    p.y = 20;
    person.age = 25;
    return 0;
}
