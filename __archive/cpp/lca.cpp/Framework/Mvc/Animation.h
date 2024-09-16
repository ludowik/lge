#pragma once

DeclareClass(View);

ImplementClass(Animation) : public Object {
public:
	ViewRef m_view;

public:
	Animation(ViewRef view);
	virtual ~Animation();

public:
	virtual bool initAnimation();
	virtual bool iterAnimation();
	virtual bool finishAnimation();
	
public:
	virtual bool resetAnimation();

};
