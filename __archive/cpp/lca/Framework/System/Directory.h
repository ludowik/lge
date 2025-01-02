#pragma once

#include "directoryIterator.h"

ImplementClass(Directory) : public File {
public:
	Directory(char* path, char* label=0);
	virtual ~Directory();
	
public:
	IteratorRef getIterator(char* mask);
	
};
