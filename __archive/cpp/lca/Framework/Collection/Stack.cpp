#include "System.h"
#include "Stack.h"

Stack::Stack() {
	m_class = "Stack";
	m_collection = new List();
}

Stack::~Stack() {
}

ObjectRef Stack::push(ObjectRef obj) {
	return add(obj);
}

ObjectRef Stack::pop() {
	int n = getCount();
	if ( n > 0 ) {
		return remove(n-1);
	}
	return 0;
}
