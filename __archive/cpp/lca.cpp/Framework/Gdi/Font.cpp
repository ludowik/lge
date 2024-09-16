#include "System.h"
#include "Font.h"

Font::Font() {
	m_fontName = defaultFontName;
	m_fontSize = System::Media::getMachineType()==iPad?fontSemiLarge:fontStandard;
	m_fontAngle = 0;	
}
