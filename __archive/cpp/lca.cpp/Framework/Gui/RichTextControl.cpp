#include "System.h"
#include "RichTextControl.h"

RichTextControl::RichTextControl(const char* value) : StaticControl(value) {
	m_class = "RichTextControl";
	m_layout = posRightExtend;
}

RichTextControl::~RichTextControl() {
}

void RichTextControl::draw(GdiRef gdi) {
	char* txt = m_value;

	int x = 0; // m_xOrigin;
	int y = m_yOrigin;

	LayoutType layoutText;
	layoutText = posLeftAlign;

	Rect textSize;

	int len = 0;

	while ( txt[0] ) {
		len = 0;
		while ( txt[len] && txt[len] != '<' ) {
			len++;
		}

		if ( len > 0 ) {
			String str;
			str.append(txt, len);
		
			textSize = gdi->getTextSize(str, m_fontName, m_fontSize, m_fontAngle);

			int wText = textSize.w;
			int hText = textSize.h;

			textSize = gdi->text(
				x+xLayout(layoutText, wText),
				y+yLayout(layoutText, hText), str, m_textColor, m_fontName, m_fontSize);
			
			{ 
				Rect rectInfo = textSize;
				gdi->rect(&rectInfo, red);
			
				rectInfo.setRight (gdi->m_positionNextText.x);
				rectInfo.setBottom(gdi->m_positionNextText.y);
				gdi->rect(&rectInfo, blue);
			}

			x += gdi->m_positionNextText.x-textSize.x;
			y += gdi->m_positionNextText.y-textSize.y;
		}

		if ( txt[len] == '<' ) {
			len++;

			bool on = true;
			if ( txt[len] == '/' ) {
				len++;
				on = false;
			}

			int sublen = 0;				
			while ( txt[len+sublen] && txt[len+sublen] != '>' ) {
				sublen++;
			}

			if ( txt[len+sublen] == '>' ) {
				String keyword(&txt[len], sublen);
				keyword.lower();

				if ( keyword.equal("center") ) {
					layoutText = posWCenter;
				}
				else if ( keyword.equal("left") ) {
					layoutText = posLeftAlign;
				}
				else if ( keyword.equal("right") ) {
					layoutText = posRightAlign;
				}
				else if ( keyword.equal("nl") ) {
					x = 0;
					y += textSize.bottom()-gdi->m_positionNextText.y;
				}
				len += sublen+1;
			}
		}

		txt += len;
	}
}
