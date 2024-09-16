#include "System.h"
#include "List.h"
#include "ListIterator.h"
#include "ListItem.h"

ListIterator::ListIterator() {
	m_class = "ListIterator";
	
	m_collect = 0;
	m_current = 0;
	m_previous = 0;
	m_index =0;
	
	begin();
}

ListIterator::ListIterator(CollectionRef collect) {
	m_class = "ListIterator";
	
	m_collect = collect;
	m_current = 0;
	m_previous = 0;
	m_index =0;
	
	begin();
}

ListIterator::~ListIterator() {
}

void ListIterator::begin() {
	if ( m_collect )
		m_current = ((List*)m_collect)->m_root;
	else
		m_current = 0;
	
	m_previous = 0;
	m_index = -1;
}

bool ListIterator::hasNext() {
	if ( m_current ) {
		return true;
	}
	return false;
}

ObjectRef ListIterator::next() {
	m_previous = m_current;
	ObjectRef obj = m_current->m_obj;
	m_current = m_current->m_next;
	m_index++;
	return obj;
}

void ListIterator::end() {
	if ( m_collect ) 
		m_current = ((List*)m_collect)->m_end;
	else
		m_current = 0;
	
	m_previous = 0;
	m_index = m_collect->getCount();
}

bool ListIterator::hasPrevious() {
	if ( m_current ) {
		return true;
	}
	return false;
}

ObjectRef ListIterator::previous() {
	m_previous = m_current;
	ObjectRef obj = m_current->m_obj;
	m_current = m_current->m_previous;
	m_index--;
	return obj;
}

int ListIterator::getIndex() {
	return m_index;
}

ObjectRef ListIterator::remove() {
	List* collect = (List*)m_collect;
	ObjectRef obj = collect->remove(m_previous);
	return obj;
}

void ListIterator::release() {
	List* collect = (List*)m_collect;
	collect->release(m_previous);
}
