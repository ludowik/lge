#include "System.h"

TestObject<Control> testControl("Control");

template<> void TestObject<Control>::test() {
  String str("The TEXT");
  m_obj->m_text = str;
  
  assert(str==m_obj->m_text);
}
