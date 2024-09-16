#pragma once

#define foreach(type,obj,collection)\
	Iterator iter##obj = (collection).getIterator();\
	for ( type obj = iter##obj.hasNext()?(type)iter##obj.next():0 ; obj ; obj = iter##obj.hasNext()?(type)iter##obj.next():0 )

#define foreach_nodecl(type,obj,collection)\
	iter##obj = (collection).getIterator();\
	for ( type obj = iter##obj.hasNext()?(type)iter##obj.next():0 ; obj ; obj = iter##obj.hasNext()?(type)iter##obj.next():0 )

#define foreach_order(type,obj,collection,order)\
	Iterator iter = (collection).getIterator();\
	if ( order )\
		iter.begin();\
	else\
		iter.end();\
	for ( type obj = (order)?(iter.hasNext()?(type)iter.next():0):(iter.hasPrevious()?(type)iter.previous():0) ; obj ; obj = (order)?(iter.hasNext()?(type)iter.next():0):(iter.hasPrevious()?(type)iter.previous():0) )

#define foreach_reverse(type,obj,collection)\
	Iterator iter = (collection).getIterator();\
	iter.end();\
	for ( type obj = iter.hasPrevious()?(type)iter.previous():0 ; obj ; obj = iter.hasPrevious()?(type)iter.previous():0 )

ImplementClass(Iterator) : public Object {
protected:
	IteratorRef m_iter;

	CollectionRef m_collect;
	
public:
	Iterator();
	Iterator(IteratorRef i);
	Iterator(CollectionRef collect);
	virtual ~Iterator();
	
public:
	virtual void begin();
	virtual void begin(int i);
	virtual bool hasNext();
	virtual ObjectRef next();
	
public:
	virtual void end();
	virtual bool hasPrevious();
	virtual ObjectRef previous();
	
public:
	virtual int getIndex();
	
public:
	virtual ObjectRef remove();
	virtual ObjectRef removeNext();
	virtual ObjectRef removePrevious();
	virtual void release();
	
};
