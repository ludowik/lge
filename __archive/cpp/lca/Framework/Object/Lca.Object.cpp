#include "System.h"
#include "Lca.Object.h"

// v1

int Object::newID() {
	static int currentID = 32000;
	return currentID++;
}

Object::Object(const char* cl) {
	m_class = cl?cl:"Object";
	m_id = newID();
}

Object::~Object() {
}

const char* Object::asString() {
	return m_class;
}

bool Object::save(class File& file) {
	return true;
}

bool Object::load(class File& file) {
	return true;
}

bool Object::isKindOf(const char* cl) {
	return strcmp(m_class, cl) == 0 ? true : false;
}
