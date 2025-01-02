#pragma once

enum KeyboardMode{
  lower=0,
  upper,
  shift,
  altgr
};

ImplementClass(KeyboardView) : public View  {
public:
	KeyboardMode m_iMode;
	
	int m_iKeyBoard;

public:
	EditControlRef m_edit;

public:
	KeyboardView(const char* text);
	virtual ~KeyboardView();

public:
	virtual void createUI();

public:
	bool onKeyboard(ObjectRef object);

};
