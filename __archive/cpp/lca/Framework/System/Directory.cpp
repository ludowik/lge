#include "System.h"
#include "directory.h"

Directory::Directory(char* path, char* label) : File(path, label) {
}

Directory::~Directory() {
}

IteratorRef Directory::getIterator(char* mask) {
	return new DirectoryIterator(this, mask);
}