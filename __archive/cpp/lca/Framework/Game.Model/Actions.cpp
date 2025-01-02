#include "System.h"
#include "Action.h"
#include "Actions.h"
#include "List.h"

Actions::Actions() {
	Object::m_class = "Actions";
}

Actions::~Actions() {
}

int Actions::getCount() {
	return data.getCount();
}

void Actions::releaseAll() {
	data.releaseAll();
}

ObjectRef Actions::add(ObjectRef obj) {
	if ( obj && obj->isKindOf("Actions") ) {
		if ( ((Actions*)obj)->getCount() == 0 ) {
			delete obj;
			return 0;
		}
	}	
	return data.add(obj);
}

ObjectRef Actions::getLast() {
	return data.getLast();
}

void Actions::execute() {
	Iterator iter = data.getIterator();
	while ( iter.hasNext() ) {
		ActionRef action = (ActionRef)iter.next();
		action->execute();
	}
}

void Actions::undo() {
	Iterator iter = data.getIterator();
	iter.end();
	
	while ( iter.hasPrevious() ) {
		ActionRef action = (ActionRef)iter.previous();
		action->undo();
	}
}

ActionRef Actions::push(ActionRef action) {
	action = (ActionRef)add(action);
	if ( action ) {
		action->execute();
	}
	return (ActionRef)action;
}

ActionRef Actions::pop() {
	ActionRef action = (ActionRef)data.pop();
	action->undo();
	delete action;
	return 0;
}
