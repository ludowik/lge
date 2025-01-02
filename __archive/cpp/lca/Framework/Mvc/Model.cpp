#include "System.h"
#include "Model.h"

Model::Model() : Object("Model") {
	m_view = 0;
	m_version = 1;
}

Model::~Model() {
}

void Model::init() {
}

void Model::release() {
}

bool Model::idle() {
	return false;
}

bool Model::save() {
	String name(System::File::getDocumentsDirectory());

	name += "/";
	name += m_class;
	name += ".txt";
	
	File file;
	file.open(name.getBuf(), "w");
	
	if ( file.m_file ) {
		file << m_version;
		
		if ( save(file) ) {
			file.close();
			return true;
		}

		file.close();
	}
	
	file.del();
	
	return false;
}

bool Model::save(File& file) {
	return true;
}

bool Model::load() {
	String name(System::File::getDocumentsDirectory());

	name += "/";
	name += m_class;
	name += ".txt";
	
	File file;
	file.open(name.getBuf(), "r");
	
	if ( file.m_file ) {
		int version;
		file >> version;
		
		if ( version == m_version ) {
			if ( load(file) ) {
				file.close();
				return true;
			}
		}

		file.close();
	}
	
	file.del();
	
	return false;
}

bool Model::load(File& file) {
	return true;
}
