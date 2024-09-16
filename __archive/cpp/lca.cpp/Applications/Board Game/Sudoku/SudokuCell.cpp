#include "System.h"
#include "SudokuView.h"
#include "SudokuCell.h"

SudokuCell::SudokuCell(int c, int y, sint* pvalue, int id) : Cell(c, y, pvalue, id) {	
	m_system = false;
	m_selectNumber = false;
	
	for ( int i = 0 ; i < 9 ; ++i ) {
		m_number[i] = true;
	}
	
	m_layoutText = posWCenter|posHCenter;
}

SudokuCell::~SudokuCell() {
}

void SudokuCell::unselect() {
	Cell::unselect();

	m_selectNumber = false;
}

void SudokuCell::draw(GdiRef gdi) {
	SudokuViewRef view = (SudokuViewRef)m_view;
	
	gdi->rect(&m_rect, grayLight, white);
	
	Rect rectIn = m_rect;
	rectIn.inset(2, 2);

	bool b = ( ( m_posInBoard.m_x / 3 + m_posInBoard.m_y / 3 ) % 2 ) == 0 ? false : true;
	if ( b ) {
	}	
	
	if ( m_selected  || m_checked ) {
		Color clr = Rgb(0,200,220);
		gdi->rect(&rectIn, clr, clr);
	}
	
	if ( m_selectNumber ) {
		Color clr = orange;
		gdi->setPenSize(3);
		gdi->rect(&rectIn, clr);
		gdi->setPenSize(1);
	}
	
	if ( m_value != 0 ) {
		m_fontSize = (int) ( m_rect.h * 0.9 );

		String stext;
		stext.format("%ld", m_value);
		computeSizeText(gdi, stext);

		Color clr = m_system ? black : blue;

		gdi->text(xLayoutText(), yLayoutText(), stext, clr, 0, m_fontSize);
	}
	
	int x = m_rect.x + 3;
	int y = m_rect.y + 3;
	
	if ( view->m_showPossibilities ) {
		Rect size;
		for ( int i = 0 ; i < 9 ; ++i ) {
			if ( m_number[i] ) {
				m_fontSize = (int)( m_rect.h * 0.3 );
				
				String stext;
				stext.format("%ld", i+1);
				computeSizeText(gdi, stext);
				
				size = gdi->text(x, y, stext.getBuf(), black, 0, m_fontSize);
				
				x += size.w;
			}
		}
	}
		
	Color clr = black;
	
	gdi->setPenSize(4);

	if ( m_posInBoard.m_y == 3 || m_posInBoard.m_y == 6 ) {
		gdi->line(m_rect.left(), m_rect.bottom(), m_rect.right(), m_rect.bottom(), clr);
	}
	if ( m_posInBoard.m_y == 2 || m_posInBoard.m_y == 5 ) {
		gdi->line(m_rect.left(), m_rect.top(), m_rect.right(), m_rect.top(), clr);
	}


	if ( m_posInBoard.m_x == 2 || m_posInBoard.m_x == 5 ) {
		gdi->line(m_rect.right(), m_rect.top(), m_rect.right(), m_rect.bottom(), clr);
	}
	if ( m_posInBoard.m_x == 3 || m_posInBoard.m_x == 6 ) {
		gdi->line(m_rect.left(), m_rect.top(), m_rect.left(), m_rect.bottom(), clr);
	}

	gdi->setPenSize(1);
}

int SudokuCell::get1Candidat() {
	int value = 0;
	
	bool b1candidat = false;
	for ( int i = 0 ; i < 9 ; ++i ) {
		if ( m_number[i] ) {
			if ( b1candidat ) {
				b1candidat = false;
				break;
			}
			b1candidat = true;
			value = i+1;
		}
	}
	
	return b1candidat ? value : 0;
}


bool SudokuCell::load(File& file) {
	file >> m_value;
	file >> m_system;
	return true;
}

bool SudokuCell::save(File& file) {
	file << m_value;
	file << m_system;
	return true;
}
