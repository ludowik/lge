#include "System.h"
#include "Keyboard.h"

#define keyNEWLINE  1
#define keyBACK     3
#define keyTAB      4
#define keyENTER    5
#define keyCAPS     6
#define keySHIFT    7
#define keyALTGR    8
#define keySPACE    9

ImplementClass(KeyButtonControl) : public ButtonControl {
public:
	int m_iType;
	String m_csInfo;

public:
	KeyButtonControl(int iType, const char* pInfo);
	virtual ~KeyButtonControl();  

public:
	void setText();

	virtual void computeSize(GdiRef gdi);  
	virtual void draw(GdiRef gdi);

};

KeyButtonControl::KeyButtonControl(int iType, const char* pInfo) : ButtonControl(pInfo, 0) {
	m_iType = iType;
	m_csInfo = pInfo;
}

KeyButtonControl::~KeyButtonControl() {
}

void KeyButtonControl::setText() {
	if ( m_iType==0 ) {
		KeyboardView* form = (KeyboardView*)get_view();
		if ( form ) {
			KeyboardMode iMode = form->m_iMode;
			switch ( iMode )
			{
			case lower:
				{
					m_text = m_csInfo.left(1);
					break;
				}
			case upper:
			case shift:
				{
					if ( m_csInfo.getLen() > 1 )
						m_text = m_csInfo.middle(1, 1);
					else
						m_text = m_csInfo.left(1);
					break;
				}
			case altgr:
				{
					if ( m_csInfo.getLen() > 2 )
					{
						m_text = m_csInfo.middle(2, 1);
					}
					break;
				}
			}
		}
	}
}

void KeyButtonControl::computeSize(GdiRef gdi) {
	setText();
	ButtonControl::computeSize(gdi);
}

void KeyButtonControl::draw(GdiRef gdi) {
	setText();
	ButtonControl::draw(gdi);
}

KeyboardView::KeyboardView(const char* text) : View() {
	m_iMode = shift;
	m_iKeyBoard = 0;
}

KeyboardView::~KeyboardView() {
}

typedef struct {
	int iType;
	const char* pInfo;
}
KeyboardLine;

KeyboardLine keyboardLine[] = {
	{0, _t("&11")},
	{0, _t("é2~")},
	{0, _t("\"3#")},
	{0, _t("'4{")},
	{0, _t("(5[")},
	{0, _t("-6|")},
	{0, _t("è7`")},
	{0, _t("_8\\")},
	{0, _t("ç9^")},
	{0, _t("à0@")},
	{0, _t(")°]")},
	{0, _t("=+}")},
	{keyBACK, _t("BACK")},

	{keyNEWLINE},

	{keyTAB, _t("TAB")},
	{0, _t("aA")},
	{0, _t("zZ")},
	{0, _t("eE")},
	{0, _t("rR")},
	{0, _t("tT")},
	{0, _t("yY")},
	{0, _t("uU")},
	{0, _t("iI")},
	{0, _t("oO")},
	{0, _t("pP")},
	{0, _t("^¨")},
	{0, _t("$£¤")},
	{keyENTER, _t("Entrée")},

	{keyNEWLINE},

	{keyCAPS, _t("V.Maj")},
	{0, _t("qQ")},
	{0, _t("sS")},
	{0, _t("dD")},
	{0, _t("fF")},
	{0, _t("gG")},
	{0, _t("hH")},
	{0, _t("jJ")},
	{0, _t("kK")},
	{0, _t("lL")},
	{0, _t("mM")},
	{0, _t("ù%")},
	{0, _t("*µ")},

	{keyNEWLINE},

	{keySHIFT, _t("Maj")},
	{0, _t("<>")},
	{0, _t("wW")},
	{0, _t("xX")},
	{0, _t("cC")},
	{0, _t("vV")},
	{0, _t("bB")},
	{0, _t("nN")},
	{0, _t(",?")},
	{0, _t(";.")},
	{0, _t(":/")},
	{0, _t("!§")},
	{keyALTGR, _t("Alt. Gr")},

	{keyNEWLINE},

	{keySPACE, _t("Espace")},

	{keyNEWLINE},

	{0, _t("1")},
	{0, _t("2")},
	{0, _t("3")},
	{0, _t("-")},
	{0, _t("+")},

	{keyNEWLINE},

	{0, _t("4")},
	{0, _t("5")},
	{0, _t("6")},
	{0, _t("/")},
	{0, _t("*")},

	{keyNEWLINE},

	{0, _t("7")},
	{0, _t("8")},
	{0, _t("9")},
	{0, _t("+")},
	{0, _t("-")},

	{keyNEWLINE},

	{0, _t("(")},
	{0, _t("0")},
	{0, _t(")")},
	{0, _t(".")},
	{0, _t("%")},

	{-1}
};

void KeyboardView::createUI() {
	View::createUI();

	m_edit = (EditControl*)add(new EditControl(m_text));

	String skeyLower;
	String skeyUpper;
	String skeyAltGr;

	ControlRef ppanel = (ControlRef)add(new Control(), posHCenter|posNextLine);
	for ( int iline = 0 ; keyboardLine[iline].iType>=0 ; iline++ ) {
		switch ( keyboardLine[iline].iType ) {
		case keyNEWLINE: {
				ppanel = (ControlRef)add(new Control(), posHCenter|posNextLine);
				continue;
			}
		}

		KeyButtonControlRef pcontrol = new KeyButtonControl(
			keyboardLine[iline].iType,
			keyboardLine[iline].pInfo);
		pcontrol->setListener(this, (FunctionRef)&KeyboardView::onKeyboard);

		ppanel->add(pcontrol, posRight);
	}
}

bool KeyboardView::onKeyboard(ObjectRef pcontrol) {
	KeyButtonControl* pkey = (KeyButtonControl*)pcontrol;

	switch ( pkey->m_iType )
	{
	case keyCAPS:
		{
			m_iMode = m_iMode==lower ? upper : lower;
			break;
		}
	case keySHIFT:
		{
			m_iMode = shift;
			break;
		}
	case keyALTGR:
		{
			m_iMode = altgr;
			break;
		}
	case keyBACK:
		{
			m_edit->m_text = m_edit->m_text.left(m_edit->m_text.getLen()-1);
			break;
		}
	case keyTAB:
		{
			m_edit->m_text = m_edit->m_text + _t("\t");
			break;
		}
	case keyENTER:
		{
			m_edit->m_text += _t("\n");
			break;
		}
	case keySPACE:
		{
			m_edit->m_text += _t(" ");
			break;
		}
	default:
		{
			m_edit->onKey(((char*)pkey->m_text)[0]);

			switch ( m_iMode )
			{
			case shift:
			case altgr:
				{
					m_iMode = lower;
					break;
				}
			}

			break;
		}
	}

	return true;
}
