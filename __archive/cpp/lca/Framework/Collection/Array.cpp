#include "System.h"
#include "Array.h"
#include "ArrayIterator.h"

Array::Array() {
	m_class = "Array";
	
	m_count = 0;
	m_available = 1;
	
	m_array = (ObjectRef*)calloc(m_available, sizeof(ObjectRef));
	m_array[0] = NULL;
}

Array::~Array() {
	releaseAll();
	free(m_array);
}

int Array::getCount() {
	return m_count;
}

ObjectRef Array::add(ObjectRef obj) {
	if ( m_available == m_count ) {
		m_available = m_available ? 2*m_available : 1;
		m_array = (ObjectRef*)realloc(m_array, m_available*sizeof(ObjectRef));
	}
	
	m_array[m_count] = obj;
	m_count++;
	
	return obj;
}

ObjectRef Array::add(int i, ObjectRef obj) {
	if ( m_available == m_count ) {
		m_available = m_available ? 2*m_available : 1;
		m_array = (ObjectRef*)realloc(m_array, m_available*sizeof(ObjectRef));
	}
	
	memmove(&m_array[i+1], &m_array[i], sizeof(ObjectRef)*(m_count-i));
	
	m_array[i] = obj;	
	m_count++;
	
	return obj;
}

ObjectRef Array::get(int i) {
	return m_array[i];
}

ObjectRef Array::getFirst() {
	return m_array[0];
}

ObjectRef Array::getLast() {
	return m_array[m_count-1];
}

ObjectRef Array::remove(int i) {
	ObjectRef obj = get(i);
	if ( i < m_count-1 ) {
		memmove(&m_array[i], &m_array[i+1], sizeof(ObjectRef)*(m_count-i-1));
	}
	
	m_count--;
	
	return obj;
}

IteratorRef Array::getIterator() {
	return new ArrayIterator(this);
}
