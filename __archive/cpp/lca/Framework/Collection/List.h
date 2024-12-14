#pragma once

#include "ListItem.h"
#include "ListIterator.h"

ImplementClass(List) : public Collection {
public:
	ListItemRef m_root;
	ListItemRef m_end;
	
	int m_count;

public:
	List();
	virtual ~List();
	
public:
	virtual int getCount();
	
	virtual ObjectRef add(ObjectRef obj);
	virtual ObjectRef add(int i, ObjectRef obj);
	
	virtual ObjectRef get(int i);
	
	virtual ObjectRef getFirst();
	virtual ObjectRef getLast();
	
	virtual ObjectRef remove(int i);
	virtual ObjectRef remove(ObjectRef item);
	virtual ObjectRef remove(ListItemRef item);
	
	virtual void release(int i);
	virtual void release(ObjectRef item);
	virtual void release(ListItemRef item);
	
	virtual IteratorRef getIterator();
	
};
