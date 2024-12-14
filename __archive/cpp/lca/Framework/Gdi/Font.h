#pragma once

#define fontSmall     ((int)( defaultFontSize * 0.5 ))
#define fontSemiSmall ((int)( defaultFontSize * 0.8 ))
#define fontStandard  ((int)( defaultFontSize * 1.0 ))
#define fontSemiLarge ((int)( defaultFontSize * 1.2 ))
#define fontLarge     ((int)( defaultFontSize * 1.5 ))
#define fontVeryLarge ((int)( defaultFontSize * 2.0 ))

ImplementClass(Font) {
public:
	const char* m_fontName;
	
	int m_fontSize;
	int m_fontAngle;
	
public:
	Font();
	
};
