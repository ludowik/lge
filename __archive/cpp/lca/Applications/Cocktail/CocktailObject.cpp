#include "System.h"
#include "CocktailObject.h"

CocktailObject::CocktailObject(const char* cl, const char* name) : Object(cl) {
	m_name = name;
}

const char* CocktailObject::asString() {
	return m_name.getBuf();
}

const char* CocktailObjects::asString() {
	return m_name.getBuf();
}

ObjectRef CocktailObjects::get(const char* cl) {
	Iterator iter = getIterator();
	while ( iter.hasNext() ) {
		//ObjectRef obj = (ObjectRef)iter.next();
	}
	return 0;
}
