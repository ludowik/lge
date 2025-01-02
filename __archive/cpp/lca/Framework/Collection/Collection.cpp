#include "System.h"
#include "Collection.h"

Collection::Collection() : Object("Collection") {
	m_collection = 0;
	m_delete = true;
}

Collection::Collection(CollectionRef collection) : Object("Collection") {
	m_collection = collection;
	m_delete = true;
}

Collection::~Collection() {  
	if ( m_collection && m_collection != this ) {
		delete m_collection;
		m_collection = 0;
	}
}

int Collection::getCount() {
	return m_collection->getCount();
}

ObjectRef Collection::add(ObjectRef obj) {
	return m_collection->add(obj);
}

void Collection::adds(CollectionRef collection) {
	Iterator iter = collection->getIterator();
	while ( iter.hasNext() ) {
		add(iter.removeNext());
	}
}

void Collection::move(ObjectRef object, CollectionRef collection) {
	Iterator iter = collection->getIterator();
	while ( iter.hasNext() ) {
		ObjectRef current = (ObjectRef)iter.next();
		if ( current == object ) {
			add(iter.remove());
			
			while ( iter.hasNext() ) {
				current = (ObjectRef)iter.next();
				add(iter.remove());
			}
			break;
		}
	}
}	

ObjectRef Collection::add(int i, ObjectRef obj) {
	return m_collection->add(i, obj);
}

ObjectRef Collection::get(int i) {
	return m_collection->get(i);
}

ObjectRef Collection::operator[](int i) {
	return get(i);
}

int Collection::getIndex(ObjectRef obj) {
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		if ( iter.next() == obj ) {
			return iter.getIndex();
		}
	}
	return -1;
}

int Collection::operator[](ObjectRef obj) {
	return getIndex(obj);
}

ObjectRef Collection::getFirst() {
	return m_collection->getFirst();
}

ObjectRef Collection::getLast() {
	return m_collection->getLast();
}

ObjectRef Collection::getRandom() {
	return m_collection->get(System::Math::random(0, m_collection->getCount()));
}

ObjectRef Collection::remove(int i) {
	return m_collection->remove(i);
}

ObjectRef Collection::remove(ObjectRef obj) {
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		if ( iter.next() == obj ) {
			return remove(iter.getIndex());
		}
	}
	return 0;
}

void Collection::removeAll() {
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		iter.next();
		iter.remove();
	}
}

void Collection::release(int i) {
	ObjectRef obj = remove(i);
	if ( m_delete ) {
		delete obj;
	}
}

void Collection::release(ObjectRef obj) {
	remove(obj);
	if ( m_delete ) {
		delete obj;
	}
}

void Collection::releaseAll() {
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		iter.next();
		iter.release();
	}
}

void Collection::sort(CompareRef compare) {
	int n = getCount();
	
	for ( int i = 0 ; i < n-1 ; ++i ) {
		ObjectRef min = (ObjectRef)get(i);
		for ( int j = i+1 ; j < n ; ++j ) {
			ObjectRef obj = (ObjectRef)get(j);
			if ( compare(obj, min) < 0 ) {
				min = obj;
			}
		}
		
		remove(min);
		add(i, min);
	}
}

IteratorRef Collection::getIterator() {
	return m_collection ? m_collection->getIterator() : 0;
}
