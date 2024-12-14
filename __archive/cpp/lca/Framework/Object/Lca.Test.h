#pragma once

DeclareClass(Object);
DeclareClass(Collection);

ImplementClass(Test) : public Singleton<Test> , public List {
public:
	Test();
	virtual ~Test();
	
public:
	virtual void test();
	
};

template<class T> class TestObject : public Object {
public:
	const char* m_name;
	
public:
	T* m_obj;
	
public:
	TestObject(const char* name) : Object("TestObject") {
		Test::getInstance().add(this);
		m_name = name;
		m_obj = new T();
	}
	
	TestObject(const char* name, T* obj) : Object("TestObject") {
		Test::getInstance().add(this);
		m_name = name;
		m_obj = obj;
	}
	
	virtual ~TestObject() {
		delete m_obj;
	}
	
public:
	virtual void test();
	
};
