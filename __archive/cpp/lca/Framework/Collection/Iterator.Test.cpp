#include "System.h"

TestObject<Iterator> testIterator("Iterator");

template<> void TestObject<Iterator>::test() {
  Iterator i1;
  Iterator i2(new Iterator());
}
