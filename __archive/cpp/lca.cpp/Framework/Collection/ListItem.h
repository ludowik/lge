#pragma once

ImplementClass(ListItem) : public Object {
public:
	ListItemRef m_next;
	ListItemRef m_previous;
	
	ObjectRef m_obj;
	
public:
	ListItem(ListItemRef next, ListItemRef previous, ObjectRef obj);
	virtual ~ListItem();
	
};
