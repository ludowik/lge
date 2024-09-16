#pragma once

ImplementClass(Array) : public Collection {
protected:
	int m_count;
	int m_available;

	ObjectRef* m_array;
	
public:
	Array();
	virtual ~Array();
	
public:
	virtual int getCount();
	
	virtual ObjectRef add(ObjectRef obj);
	virtual ObjectRef add(int i, ObjectRef obj);
	
	virtual ObjectRef get(int i);
	
	virtual ObjectRef getFirst();
	virtual ObjectRef getLast();
	
	virtual ObjectRef remove(int i);
	
	virtual IteratorRef getIterator();
	
};
