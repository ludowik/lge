#pragma once

#define Collection lcaCollection

DeclareClass(Iterator);

typedef int (*CompareRef)(ObjectRef o1, ObjectRef o2);

ImplementClass(Collection) : public Object {
public:
	CollectionRef m_collection;
	
public:
	bool m_delete;
	
public:
	Collection();
	Collection(CollectionRef collection);
	virtual ~Collection();
	
public:
	virtual int getCount();
	
	virtual ObjectRef add(ObjectRef obj);
	virtual void adds(CollectionRef collection);
	virtual void move(ObjectRef object, CollectionRef collection);
	
	virtual ObjectRef add(int i, ObjectRef obj);
	
	virtual ObjectRef get(int i);
	virtual ObjectRef operator[](int i);
	
	virtual int getIndex(ObjectRef obj);
	virtual int operator[](ObjectRef obj);
	
	virtual ObjectRef getFirst();
	virtual ObjectRef getLast();
	
	virtual ObjectRef getRandom();
	
	virtual ObjectRef remove(int i);
	virtual ObjectRef remove(ObjectRef obj);
	virtual void removeAll();
	
	virtual void release(int i);
	virtual void release(ObjectRef obj);  
	virtual void releaseAll();
	
	virtual void sort(CompareRef compare);
	
	virtual IteratorRef getIterator();
	
};

template<class T, class O> class CollectionObject : public Collection {
public:
	CollectionObject() {
		m_collection = new T();
	}
	
};
