#include "System.h"

TestObject<Time> testTime("Time");

template<> void TestObject<Time>::test() {
	Time t;

	// reset
	t.set(0, 0, 0);
	assert(t.second()==0);
	assert(t.minute()==0);
	assert(t.hour  ()==0);

	// initialisation
	t.set(2, 35, 24);
	assert(t.second()==24);
	assert(t.minute()==35);
	assert(t.hour  ()==2);

	// test aux limites
	t.set(2, 70, 70);
	assert(t.second()==10);
	assert(t.minute()==11);
	assert(t.hour  ()==3);

	// chrono
	t.set(0,0,0);
	while ( t.hour() == 0 ) {
		t.add(1);
	}
	int second = t.get();
	while ( second-- ) {
		t.sub(1);
	}
	assert(t.second()==0);
	assert(t.minute()==0);
	assert(t.hour  ()==0);	
}
