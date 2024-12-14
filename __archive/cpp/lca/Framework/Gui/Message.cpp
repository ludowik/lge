#include "System.h"
#include "Message.h"

ImplementClass(MessageView) : public View {
public:
	ViewRef m_view;
	
	ObjectRef m_obj;
	FunctionRef m_f;
	
	String m_title;
	String m_ok;
	String m_cancel;
	
public:
	MessageView(ViewRef view, const char* title, const char* text, ObjectRef obj, const char* ok, FunctionRef f);
	virtual ~MessageView();

public:
	virtual void createUI();
	
public:
	bool onAction(ObjectRef obj);
	
};

MessageView::MessageView(ViewRef view, const char* title, const char* text, ObjectRef obj, const char* ok, FunctionRef f) : View() {
	m_class = "MessageView";
	
	m_view = view;
	
	m_title = title;
	m_text = text;
	m_ok = ok;
	m_cancel = System::String::load("Cancel");
		
	m_obj = obj;
	m_f = f;
	
	if ( !m_view->g_gdi->isKindOf(classGdiOpenGL) ) {
		m_bgImage = m_view->g_gdi;
	}
}

MessageView::~MessageView() {
	if ( !m_view->g_gdi->isKindOf(classGdiOpenGL) ) {
		m_bgImage = 0;
		m_view->g_gdi->release();
	}
}

void MessageView::createUI() {
	m_area->m_layout = posHCenter|posWCenter;
	m_area->m_opaque = true;

	add(new StaticControl(m_title), posWCenter)->m_fontSize = fontLarge;
	add(new StaticControl(m_text), posNextLine|posWCenter);
	
	startPanel(posNextLine|posWCenter); {
		add(new ButtonControl(m_cancel))->setListener(this, (FunctionRef)&View::onClose);
		add(new ButtonControl(m_ok))->setListener(this, (FunctionRef)&MessageView::onAction);
	}
	endPanel();
}

bool MessageView::onAction(ObjectRef obj) {
	onClose(obj);
	return (m_obj->*m_f)(this);
}

void Message(ViewRef view, const char* title, const char* text, ObjectRef obj, const char* ok, FunctionRef f) {
	MessageView message(view, title, text, obj, ok, f);
	message.run();
}
