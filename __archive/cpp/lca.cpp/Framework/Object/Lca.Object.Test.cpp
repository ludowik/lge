#include "System.h"

TestObject<Object> testObject("Object");

template<> void TestObject<Object>::test() {
}
