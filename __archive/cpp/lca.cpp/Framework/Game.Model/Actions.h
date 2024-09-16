#pragma once

ImplementClass(Actions) : public Action {
public:
	Stack data;
	
public:
	Actions();
	virtual ~Actions();
	
public:
	int getCount();
	
	void releaseAll();
	
	ObjectRef add(ObjectRef obj);
	ObjectRef getLast();
	
public:
	virtual void execute();
	virtual void undo();
	
public:
	virtual Action* push(Action* action);
	virtual Action* pop();
	
};
