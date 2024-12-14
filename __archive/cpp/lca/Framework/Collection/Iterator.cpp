#include "System.h"
#include "Iterator.h"

Iterator::Iterator() : Object("Iterator") {
	m_iter = 0;
	m_collect = 0;
}

Iterator::Iterator(IteratorRef iter) : Object("Iterator") {
	m_iter = iter;
	m_collect = 0;
}

Iterator::Iterator(CollectionRef collect) : Object("Iterator") {
	m_iter = 0;
	m_collect = collect;
}

Iterator::~Iterator() {
	delete m_iter;  
}

void Iterator::begin() {
	m_iter->begin();
}

void Iterator::begin(int i) {
	m_iter->begin();
	while ( i-- ) {
		m_iter->next();
	}
}

bool Iterator::hasNext() {
	return m_iter->hasNext();
}

ObjectRef Iterator::next() {
	return m_iter->next();
}

void Iterator::end() {
	m_iter->end();
}

bool Iterator::hasPrevious() {
	return m_iter ? m_iter->hasPrevious() : 0;
}

ObjectRef Iterator::previous() {
	return hasPrevious() ? m_iter->previous() : 0;
}

int Iterator::getIndex() {
	return m_iter->getIndex();
}

ObjectRef Iterator::remove() {
	return m_iter->remove();
}

ObjectRef Iterator::removeNext() {
	next();
	return remove();
}

ObjectRef Iterator::removePrevious() {
	previous();
	return remove();
}

void Iterator::release() {
	m_iter->release();
}
