#include "System.h"
#include "Launcher.h"

LauncherModel::LauncherModel() {
	m_cl = 0;
}

LauncherModel::~LauncherModel() {
}

bool LauncherModel::save(File& file) {
	if ( Model::save(file) ) {
		ViewRef view = get_view();
		if ( view->m_model && view->m_model != this ) {
			String s(view->m_model->m_class);
			file << s;
			return true;
		}
	}
	return false;
}

bool LauncherModel::load(File& file) {
	if ( Model::load(file) ) {
		file >> m_cl;
		return true;
	}
	return false;
}
