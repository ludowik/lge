#pragma once

#include "StaticControl.h"

ImplementClass(RichTextControl) : public StaticControl {
public:
	RichTextControl(const char* value);
	virtual ~RichTextControl();

public:
	virtual void draw(GdiRef gdi);

};
