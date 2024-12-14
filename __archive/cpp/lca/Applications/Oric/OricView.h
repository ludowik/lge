#pragma once

#include "Oric.h"

ImplementClass(OricView) : public View {
public:
	EmulateurOric* emul;

public:
	OricView();
	virtual ~OricView();

public:
	virtual bool onKey(char c);

};
