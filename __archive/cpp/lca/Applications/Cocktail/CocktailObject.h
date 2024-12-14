#pragma once

ImplementClass(CocktailObject) : public Object {
public:
	String m_name;
	
public:
	CocktailObject(const char* cl, const char* name);
	
public:
	virtual const char* asString();
	
};

ImplementClass(CocktailObjects) : public List {
public:
	String m_name;

public:
	virtual const char* asString();
	virtual void init()=0;
	
public:
	ObjectRef get(const char* cl);
	
};