#include "System.h"
#include "ListItem.h"

ListItem::ListItem(ListItemRef next, ListItemRef previous, ObjectRef obj) {
	m_next = next;
	m_previous = previous;
	m_obj = obj;
}

ListItem::~ListItem() {
}
