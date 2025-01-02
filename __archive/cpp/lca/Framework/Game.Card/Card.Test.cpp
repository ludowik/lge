#include "System.h"

TestObject<Card> testCard("Card");

template<> void TestObject<Card>::test() {
  assert(m_obj->m_serie==0);
  assert(m_obj->m_val==0);
  assert(m_obj->m_select==false);
  assert(m_obj->m_reverse==false);

  Card card(12, 23);
  assert(card.m_serie==12);
  assert(card.m_val==23);
  assert(card.m_select==false);
  assert(card.m_reverse==false);
}
