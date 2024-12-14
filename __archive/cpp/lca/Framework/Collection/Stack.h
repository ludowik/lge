#pragma once

ImplementClass(Stack) : public Collection {
public:
	Stack();
	virtual ~Stack();
	
public:
	virtual ObjectRef push(ObjectRef obj);
	virtual ObjectRef pop();
	
};