#include "System.h"

TestObject<Stack> testStack("Stack");

template<> void TestObject<Stack>::test() {
	int n = 0;
	
	while ( n < 50 ) {
		m_obj->push(new Int(m_obj->getCount()));
		n++;
	}
	
	while ( m_obj->getCount() ) {
		delete m_obj->pop();
		n--;
	}
	
	assert(n==0);
	
	while ( n < 50 ) {
		m_obj->push(new Int(m_obj->getCount()));
		n++;
	}
	
	while ( n ) {
		delete m_obj->pop();
		n--;
	}
	
	assert(m_obj->getCount()==0);
}
