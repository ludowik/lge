#pragma once

ImplementClass(Object) {
public:
	static int newID();

public:
	const char* m_class;
	int m_id;
	
public:
	Object(const char* cl=0);
	virtual ~Object();
	
public:
	virtual const char* asString();
	
public:	
	virtual bool save(class File& file);
	virtual bool load(class File& file);
	
public:
	virtual bool isKindOf(const char* cl);
	
};

template<typename type> class ObjectType : public Object {
public:
	type m_val;
	
public:
	ObjectType();
	ObjectType(type val);

	virtual ~ObjectType();
	
public:
	operator type();
	
};

template<typename type> ObjectType<type>::ObjectType() : Object() {
	m_val = 0;
}

template<typename type> ObjectType<type>::ObjectType(type val) : Object() {
	m_val = val;
}

template<typename type> ObjectType<type>::~ObjectType() {
}

template<typename type> ObjectType<type>::operator type() {
	return m_val;
}

typedef ObjectType<bool> Bool;
typedef ObjectType<int> Int;
typedef ObjectType<double> Double;

typedef Bool* BoolRef;
typedef Int* IntRef;
typedef Double* DoubleRef;