/*
class Ini {
  public static void main(String[] a) {
    new Main0().main0();
  }
}
class Main0 {
  public int main0() {
    int b;
    int d;
    b = 60;
    d = b + 20;
    System.out.println(b);
    System.out.println(d);
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
struct Main0;
void* Main0_main0(struct Main0* this);
struct Main0 {
  void* (**vtable)();
};
void* (*Main0_vtable[])() = { Main0_main0 };
void* Main0_main0(struct Main0* this) {
  int b;
  int d;
  b = 60;
  d = (b + 20);
  printf("%d\n", b);
  printf("%d\n", d);
  return (void*)(0);
}
int main(int argc, char *argv[]) {
  tgc_start(&gc, &argc);
  ({ struct Main0* tmp1 = ({ struct Main0* res = tgc_calloc(({ extern tgc_t gc; &gc; }), 1, sizeof(*res)); res->vtable = Main0_vtable; res; }); (int) tmp1->vtable[0](tmp1); });
  tgc_stop(&gc);

  return 0;
}
