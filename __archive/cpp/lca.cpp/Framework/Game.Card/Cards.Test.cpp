#include "System.h"
#include "Lca.test.h"

TestObject<Cards> testCards("Cards");

template<> void TestObject<Cards>::test() {
	m_obj->create54();
	m_obj->createTarot();
	m_obj->create52();
	
	CardRef card = (CardRef)m_obj->get(0);
	
	assert(card->m_serie==0);
	assert(card->m_val==1);
	
	for ( int i = 0 ; i < 100 ; ++i ) {
		m_obj->mix();
	}
	
	assert(m_obj->getCount()==52);
}
