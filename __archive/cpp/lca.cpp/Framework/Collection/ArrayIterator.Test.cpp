#include "System.h"

TestObject<ArrayIterator> testArrayIterator("ArrayIterator");

template<> void TestObject<ArrayIterator>::test() {
	Array c;
	c.add(new Object());
	
	assert(c.getCount()==1);
	
	int index = 0;
	
	Iterator iter = c.getIterator();
	while ( iter.hasNext() ) {
		iter.next();
		
		assert(iter.getIndex()==index++);
	}
}
