#pragma once

ImplementClass(ListIterator) : public Iterator {
protected:
	ListItemRef m_current;
	ListItemRef m_previous;
	
	int m_index;
	
public:
	ListIterator();
	ListIterator(CollectionRef collect);

	virtual ~ListIterator();
	
public:
	virtual void begin();
	virtual bool hasNext();
	virtual ObjectRef next();
	
	virtual void end();
	virtual bool hasPrevious();
	virtual ObjectRef previous();
	
	virtual int getIndex();
	
	virtual ObjectRef remove();
	virtual void release();
	
};
