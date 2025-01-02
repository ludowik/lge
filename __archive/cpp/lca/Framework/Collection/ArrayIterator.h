#pragma once

ImplementClass(ArrayIterator) : public Iterator {
protected:
  int m_current;
  int m_previous;

public:
  ArrayIterator();
  ArrayIterator(CollectionRef collect);

  virtual ~ArrayIterator();
	
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
