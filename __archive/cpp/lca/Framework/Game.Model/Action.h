#pragma once

ImplementClass(Action) : public Object {
public:
	Action();
	virtual ~Action();
	
public:
	virtual void execute()=0;
	virtual void undo()=0;
	
};
