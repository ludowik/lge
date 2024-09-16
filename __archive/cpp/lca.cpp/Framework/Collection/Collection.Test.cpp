#include "System.h"

TestObject<Collection> testCollection("Collection");

template<> void TestObject<Collection>::test() {
	if ( m_obj->isKindOf("Collection") ) {
		m_obj->m_collection = new Array();
	}
	
	// Remplissage
	int n = 0;
	for ( ; n < 10 ; ++n ) {
		m_obj->add(new Int(n));
	}

	// On transvase dans un sens...
	List list;
	list.Collection::adds(m_obj);
	
	assert(m_obj->getCount()==0);
	assert(list.getCount()==n);
	
	// ...puis dans l'autre
	m_obj->adds(&list);
	
	assert(m_obj->getCount()==n);
	assert(list.getCount()==0);
	
	// On itere dans un sens...
	Iterator iter = m_obj->getIterator();
	while ( iter.hasNext() ) {
		iter.next();
	}
	
	// ...puis dans l'autre
	iter.end();
	
	while ( iter.hasPrevious() ) {
		iter.previous();
	}
	
	// On melange
	for ( int i = 0 ; i < n ; ++i ) {
		Int* obj = (Int*)m_obj->remove(System::Math::random(n));
		m_obj->add(System::Math::random(n-1), obj);
	}
	
	return;
	
	// ...et on tri
	for ( int i = 0 ; i < n-1 ; ++i ) {
		Int* min = (Int*)m_obj->get(i);
		for ( int j = i+1 ; j < n ; ++j ) {
			Int* obj = (Int*)m_obj->get(j);
			if ( obj->m_val < min->m_val ) {
				min = obj;
			}
		}
		
		m_obj->remove(min);
		m_obj->add(i, min);
	}
}
