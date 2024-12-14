#include "System.h"
#include "Alert.h"

ImplementClass(AlertView) : public View {
public:
	AlertView(const char* string);
	virtual ~AlertView();
	
public:
	virtual void createUI();
	
};

AlertView::AlertView(const char* string) : View() {
	m_text = string;
}

AlertView::~AlertView() {
}

void AlertView::createUI() {
	add(new StaticControl(m_text));
	add(new ButtonControl("OK"))->setListener(this , (FunctionRef)&View::onClose);
}

/* Alerte : affichage d'un entier
 */
void msgAlert(int ivalue) {
	String string;
	string.format("%ld", ivalue);
	
	msgAlert(string);
}

/* Alerte : affichage d'un flottant
 */
void msgAlert(double fvalue) {
	String string;
	string.format("%g", fvalue);
	
	msgAlert(string);
}

/* Alerte : affichage d'un texte formate
 */
void msgAlert(const char* pformat, ...) {
	va_list pargList;
	va_start(pargList, pformat);
	
	String string;
	string.format(pformat, pargList);
	
	va_end(pargList);

	AlertView view(string);
	view.run();
}

/* Alerte : affichage conditionnele d'un texte formate
 */
void msgAlertIf(bool balert, const char* pformat, ...) {
	if ( balert ) {
		va_list pargList;
		va_start(pargList, pformat);
		
		String string;
		string.format(pformat, pargList);
		
		va_end(pargList);

		AlertView view(string);
		view.run();
	}
}
