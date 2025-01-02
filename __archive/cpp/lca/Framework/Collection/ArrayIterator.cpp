#include "System.h"
#include "Array.h"
#include "ArrayIterator.h"

ArrayIterator::ArrayIterator() {
	m_class = "ArrayIterator";
	
	m_collect = 0;
	m_current = 0;
	m_previous = 0;
	
	begin();
}

ArrayIterator::~ArrayIterator() {
}

ArrayIterator::ArrayIterator(CollectionRef collect)
{  
	m_class = "ArrayIterator";
	
	m_collect = collect;
	m_current = 0;
	m_previous = 0;
	
	begin();
}

void ArrayIterator::begin() {
	m_current = 0;
	m_previous = m_current;
}

bool ArrayIterator::hasNext() {
	if ( m_current < m_collect->getCount() ) {
		return true;
	}
	return false;
}

ObjectRef ArrayIterator::next() {
	m_previous = m_current;
	ObjectRef obj = m_collect->get(m_current);
	m_current++;
	return obj;
}

void ArrayIterator::end() {
	m_current = m_collect->getCount();
	m_previous = m_current;
}

bool ArrayIterator::hasPrevious() {
	if ( m_current > 0 ) {
		return true;
	}
	return false;
}

ObjectRef ArrayIterator::previous() {
	m_current--;
	m_previous = m_current;
	return m_collect->get(m_current);
}

int ArrayIterator::getIndex() {
	return m_previous;
}

ObjectRef ArrayIterator::remove() {
	ObjectRef obj = m_collect->remove(m_previous);
	m_current = m_previous;
	return obj;
}

void ArrayIterator::release() {
	m_collect->release(m_previous);
	m_current = m_previous;
}
