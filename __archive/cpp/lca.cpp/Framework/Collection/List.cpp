#include "System.h"
#include "List.h"
#include "ListIterator.h"
#include "ListItem.h"

List::List() {
	m_class = "List";
	
	m_collection = this;
	
	m_root = 0;
	m_end = 0;

	m_count = 0;
}

List::~List() {
	releaseAll();
}

ObjectRef List::add(ObjectRef obj) {
	if ( m_root ) {
		m_end->m_next = new ListItem(0, m_end, obj);
		m_end = m_end->m_next;
	}
	else {
		m_root = m_end = new ListItem(0, 0, obj);
	}
	
	m_count++;
	
	return obj;
}

ObjectRef List::add(int i, ObjectRef obj) {
	int count = 0;
	
	ListItemRef item = m_root;
	while ( item && i != count ) {
		count++;
		item = item->m_next;
	}
	
	if ( item ) {
		ListItemRef insert = new ListItem(item, item->m_previous, obj);
		item->m_previous = insert;
		
		if ( insert->m_previous ) {
			insert->m_previous->m_next = insert;
		}
		if ( m_root == item ) {
			m_root = insert;
		}
		
		m_count++;
	}
	else {
		add(obj);
	}
	
	return obj;
}

int List::getCount() {
	return m_count;
}

ObjectRef List::get(int i) {
	int count = 0;
	
	ListItemRef item = m_root;
	while ( item && i != count ) {
		count++;
		item = item->m_next;
	}
	
	return item ? item->m_obj : 0;
}

ObjectRef List::getFirst() {
	return m_root ? m_root->m_obj : 0;
}

ObjectRef List::getLast() {
	return m_end ? m_end->m_obj : 0;
}

ObjectRef List::remove(int i) {
	int count = 0;
	
	ListItemRef item = m_root;
	while ( item && i != count ) {
		count++;
		item = item->m_next;
	}
	
	if ( item ) {
		return remove(item);
	}
	return 0;
}

ObjectRef List::remove(ObjectRef obj) {
	int count = 0;
	
	ListItemRef item = m_root;
	while ( item && item->m_obj != obj ) {
		count++;
		item = item->m_next;
	}
	
	if ( item ) {
		return remove(item);
	}
	return 0;
}

ObjectRef List::remove(ListItemRef item) {
	ObjectRef obj = item->m_obj;
	
	if ( m_root == item )
		m_root = item->m_next;
	
	if ( m_end == item )
		m_end = item->m_previous;
	
	if ( item->m_previous )
		item->m_previous->m_next = item->m_next;
	
	if ( item->m_next )
		item->m_next->m_previous = item->m_previous;
	
	delete item;
	
	m_count--;
	
	return obj;
}

void List::release(int i) {
	Collection::release(i);
}

void List::release(ObjectRef item) {
	Collection::release(item);
}

void List::release(ListItemRef item) {
	ObjectRef object = remove(item);
	if ( m_delete ) {
		delete object;
	}
}

IteratorRef List::getIterator() {
	return new ListIterator(this);
}
