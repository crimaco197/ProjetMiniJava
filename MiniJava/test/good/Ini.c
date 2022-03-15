/*
class Ini {
  public static void main(String[] a) {
    new Main().main2();
  }
}
class Main {
  int a;
  int b;
  public int main2() {
    a = 2;
    System.out.println(a);
    System.out.println(b);
    return 0;
  }
}*/
#include <stdio.h>
#include <stdlib.h>
#include "tgc.h"
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"
struct array { int* array; int length; };
tgc_t gc;
struct Main;
void* Main_main2(struct Main* this);
struct Main {
  void* (**vtable)();
  int Main_a;
  int Main_b;
};
void* (*Main_vtable[])() = { Main_main2 };
void* Main_main2(struct Main* this) {
  this->Main_a = 2;
  printf("%d\n", this->Main_a);
  printf("%d\n", this->Main_b);
  return (void*)(0);
}
int main(int argc, char *argv[]) {
  tgc_start(&gc, &argc);
  ({ struct Main* tmp1 = ({ struct Main* res = tgc_calloc(({ extern tgc_t gc; &gc; }), 1, sizeof(*res)); res->vtable = Main_vtable; res; }); (int) tmp1->vtable[0](tmp1); });
  tgc_stop(&gc);

  return 0;
}
