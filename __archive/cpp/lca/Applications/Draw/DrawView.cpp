#include "System.h"
#include "DrawView.h"
#include "ToolControl.h"
#include "ColorControl.h"
#include "ModeControl.h"

ApplicationObject<DrawView, Model> appDraw("Draw", "Draw", "draw.png");

byte Adjust(byte srcRgb, byte dstRgb, int localAdjust) {
	byte val;
	if ( dstRgb < srcRgb )
		val = (byte)(max(dstRgb, srcRgb - localAdjust));
	else
		val = (byte)(min(dstRgb, srcRgb + localAdjust));
	
	return val;
}

void set_Pixel(GdiRef gdi, int x, int y, Color dstRgb, int localAdjust) {
	gdi->pixel(x, y, dstRgb);
	return;
	
	Color srcRgb = gdi->getPixel(x, y);
	
	byte r = Adjust(rValue(srcRgb), rValue(dstRgb), localAdjust);
	byte g = Adjust(gValue(srcRgb), gValue(dstRgb), localAdjust);
	byte b = Adjust(bValue(srcRgb), bValue(dstRgb), localAdjust);
	
	gdi->pixel(x, y, Rgb(r,g,b));
}

DrawInfo DrawView::m_drawInfo;

DrawView::DrawView() : View() {
	m_drawInfo.rgb = (Color)ftrGet(FTR_RGB, blueLight);
	
	m_drawInfo.size = ftrGet(FTR_SIZE, 8);
	m_drawInfo.pen = ftrGet(FTR_PEN, 0);
	
	m_drawInfo.adjust = ftrGet(FTR_ADJUST, 16);
	
	m_drawInfo.mode = ftrGet(FTR_MODE, modeLine);

	m_drawInfo.percents = 0;
}

DrawView::~DrawView() {
	ftrSet(FTR_RGB   , m_drawInfo.rgb);
	ftrSet(FTR_SIZE  , m_drawInfo.size);
	ftrSet(FTR_PEN   , m_drawInfo.pen);
	ftrSet(FTR_ADJUST, m_drawInfo.adjust);
	ftrSet(FTR_MODE  , m_drawInfo.mode);

	if ( m_drawInfo.percents ) {
		for ( int x = 0 ; x < m_drawInfo.size ; ++x ) {
			delete[] m_drawInfo.percents[x];
		}
		delete[] m_drawInfo.percents;
		m_drawInfo.percents = 0;
	}
}

void DrawView::createUI() {
	m_drawControl = (DrawControl*)add(new DrawControl(), posNextLine|posRightExtend|posBottomExtend);
}

void DrawView::createToolBar() {
	m_fontSize = fontLarge;
	
	m_toolbar = (ToolBarControlRef)startPanel(0, new ToolBarControl()); {
		add(new ColorControl(DrawView::m_drawInfo.rgb));     
		
		add(new ChooseToolControl(DrawView::m_drawInfo.size,
								  DrawView::m_drawInfo.pen,
								  DrawView::m_drawInfo.adjust));
		
		add(new ChooseModeControl(DrawView::m_drawInfo.mode));
				
		add(new ButtonControl("Pixel"  ))->setListener(this, (FunctionRef)&DrawView::onPixelisation);
		add(new ButtonControl("Filter" ))->setListener(this, (FunctionRef)&DrawView::onFilter);
		add(new ButtonControl("Color"  ))->setListener(this, (FunctionRef)&DrawView::onChangeColor);
		add(new ButtonControl("N&B"    ))->setListener(this, (FunctionRef)&DrawView::onGrayScale);
		add(new ButtonControl("Lumiere"))->setListener(this, (FunctionRef)&DrawView::onLuminosity);
		add(new ButtonControl("Binar." ))->setListener(this, (FunctionRef)&DrawView::onBinarisation);
		add(new ButtonControl("Squel." ))->setListener(this, (FunctionRef)&DrawView::onSquelettisation);
		add(new ButtonControl("Dilater"))->setListener(this, (FunctionRef)&DrawView::onDilatation);
	}
	endPanel();
}

bool DrawView::onNew(ObjectRef obj) {
	return false;
}

bool DrawView::onTest(ObjectRef obj) {
	return false;
}

bool DrawView::onPixelisation(ObjectRef obj) {
	Pixelisation op(&m_drawControl->m_gdi);	
	op.execute();
	
	return true;
}

bool DrawView::onFilter(ObjectRef obj) {
	Blur op(&m_drawControl->m_gdi);
	op.execute();
	
	return true;
}

bool DrawView::onChangeColor(ObjectRef obj) {
	Colorisation op(&m_drawControl->m_gdi);
	op.execute();

	return true;
}

bool DrawView::onGrayScale(ObjectRef obj) {
	GrayScale op(&m_drawControl->m_gdi);
	op.execute();
	
	return true;
}

bool DrawView::onLuminosity(ObjectRef obj) {
	Luminosite op(&m_drawControl->m_gdi);
	op.execute();
	
	return true;
}

bool DrawView::onBinarisation(ObjectRef obj) {
	Binarisation op(&m_drawControl->m_gdi, 32);
	op.execute();
	
	return true;
}

bool DrawView::onSquelettisation(ObjectRef obj) {
	Squelettisation op(&m_drawControl->m_gdi);
	op.execute();
	
	return true;
}

bool DrawView::onDilatation(ObjectRef obj) {
	Dilatation op(&m_drawControl->m_gdi);
	op.execute();
	
	return true;
}

DrawControl::DrawControl() {
	m_gdi.Gdi::create();
}

DrawControl::~DrawControl() {
}

Rect rectd;

void DrawControl::draw(GdiRef gdi) {
	gdi->copy(&m_gdi,
        m_rect.x,
        m_rect.y);
    
/*    
    max(gdi->m_redrawRect.x, m_rect.x),
    max(gdi->m_redrawRect.y, m_rect.y),
    min(gdi->m_redrawRect.right (), m_rect.right ())-max(gdi->m_redrawRect.x, m_rect.x),
    min(gdi->m_redrawRect.bottom(), m_rect.bottom())-max(gdi->m_redrawRect.y, m_rect.y));
*/
}

bool DrawControl::touchBegin(int x, int y) {
	return touch(x, y, false);
}

bool DrawControl::touchMove(int x, int y) {
	DrawViewRef view = (DrawViewRef)m_view;
    
    view->m_toolbar->m_visible = false;
	view->m_statusbar->m_visible = false;
	
	view->m_needsRedrawAutomatic = false;
	
	//Rect rect(x, y, 0, 0);
	rectd = Rect(x, y, 0, 0);
    
	Event event;
	do {
		getEvent(event, eAllTouchEvent);					
		if ( event.m_type == eTouchMove ) {
			touch(event.x, event.y, true);
			
			rectd.add(Rect(event.x, event.y, 0, 0));
            
			System::Media::redraw(&rectd);
		}
		else {					
			System::Event::waitEvent();
		}
	}
	while ( event.m_type == eTouchMove || ( event.m_type != eTouchEnd && event.m_type != eTouchBegin ) );

	view->m_needsRedrawAutomatic = true;
    
	view->m_toolbar->m_visible = true;
	view->m_statusbar->m_visible = true;
	
	return true;
}

bool DrawControl::touch(int x, int y, bool move) {
	x -= m_rect.x;
	y -= m_rect.y;

	switch ( DrawView::m_drawInfo.mode ) {
		case modeGomme: {
			onGomme(x, y, move);
			break;
		}
		case modePoint: {
			onPoint(x, y, move);
			break;
		}
		case modeLine: {
			onLine(x, y, move);
			break;
		}
		case modeRect: {
			onRect(x, y, move);
			break;
		}
		case modeCircle: {
			onCircle(x, y, move);
			break;
		}
		case modeFill: {
			onFill(x, y, move);
			break;
		}
	}
	
	return true;
}


bool DrawControl::onPoint(int firstX, int firstY, bool move) {
	DrawViewRef view = (DrawViewRef)m_view;
	view->drawPattern(&m_gdi, firstX, firstY, &DrawView::m_drawInfo);
	return true;
}

bool DrawControl::onGomme(int firstX, int firstY, bool move) {
	m_gdi.pixel(firstX, firstY, black);
	return true;
}

bool DrawControl::onLine(int x, int y, bool move) {
	static int _x = 0;
	static int _y = 0;
	
	if ( move ) {
		m_gdi.line(_x, _y, x,  y, DrawView::m_drawInfo.rgb);
	}
	
	_x = x;
	_y = y;
	
	return true;
}

bool DrawControl::onRect(int x, int y, bool move) {
	static int _x = 0;
	static int _y = 0;
	
	if ( move ) {
		m_gdi.Gdi::rect(_x, _y, x-_x,  y-_y, DrawView::m_drawInfo.rgb);
	}
	else {	
		_x = x;
		_y = y;
	}
	
	return true;
}

bool DrawControl::onCircle(int x, int y, bool move) {
	static int _x = 0;
	static int _y = 0;
	
	if ( move ) {
		m_gdi.Gdi::circle(_x, _y, x-_x, DrawView::m_drawInfo.rgb);
	}
	else {	
		_x = x;
		_y = y;
	}
	
	return true;
}

bool DrawControl::onFill(int firstX, int firstY, bool move) {
	return true;
}

bool DrawControl::save(File& file) {
	return m_gdi.Gdi::save(file);
}

bool DrawControl::load(File& file) {
	return m_gdi.Gdi::load(file);
}

bool DrawView::save(File& file) {
	return m_drawControl->save(file);
}

bool DrawView::load(File& file) {
	return m_drawControl->load(file);
}

void DrawView::drawPattern(GdiRef gdi, int newX, int newY, DrawInfo* drawInfo) {
	static int size = -1;
	static int pen = -1;
	static int rayon = -1;

	int x = 0;
	int y = 0;
	
	if ( m_drawInfo.percents == NULL || size == -1 || size != drawInfo->size || pen != drawInfo->pen ) {
		if ( m_drawInfo.percents ) {
			for ( x = 0 ; x < size ; ++x ) {
				delete[] m_drawInfo.percents[x];
			}
			delete[] m_drawInfo.percents;
			m_drawInfo.percents = 0;
		}
		
		size = drawInfo->size;
		pen = drawInfo->pen;
		
		rayon = divby2(size);
		
		m_drawInfo.percents = new double*[size];
		
		for ( x = 0 ; x < size ; ++x ) {
			m_drawInfo.percents[x] = new double[size];
			for ( y = 0 ; y < size ; ++y ) {
				switch ( drawInfo->pen ) {
					case 0: {
						int x2 = x-rayon;
						int y2 = y-rayon;
						
						x2 *= x2;
						y2 *= y2;
						
						m_drawInfo.percents[x][y] = max(0., ( rayon - sqrt(x2+y2) ) / rayon );
						break;
					}
					case 1: {
						if ( x == rayon || y == rayon )
							m_drawInfo.percents[x][y] = 1;
						else
							m_drawInfo.percents[x][y] = 0;
						break;
					}
					case 2: {
						if ( abs(x) == abs(y) || ( x + y ) == size-1 )
							m_drawInfo.percents[x][y] = 1;
						else
							m_drawInfo.percents[x][y] = 0;
						break;
					}
					case 3: {
						if ( x == rayon )
							m_drawInfo.percents[x][y] = 1;
						else
							m_drawInfo.percents[x][y] = 0;
						break;
					}
					case 4: {
						if ( y == rayon )
							m_drawInfo.percents[x][y] = 1;
						else
							m_drawInfo.percents[x][y] = 0;
						break;
					}
					case 5: {
						if ( abs(x) == abs(y) )
							m_drawInfo.percents[x][y] = 1;
						else
							m_drawInfo.percents[x][y] = 0;
						break;
					}
					case 6: {
						if ( ( x + y ) == size-1 )
							m_drawInfo.percents[x][y] = 1;
						else
							m_drawInfo.percents[x][y] = 0;
						break;
					}
					case 7: {
						m_drawInfo.percents[x][y] = 1;
						break;
					}
				}
			}
		}
	}
	
	newX -= rayon;
	newY -= rayon;
	
	for ( x = 0 ; x < size ; ++x ) {
		for ( y = 0 ; y < size ; ++y ) {
			int localAdjust = (int)( m_drawInfo.percents[x][y] * drawInfo->adjust );
			if ( localAdjust > 0 ) {
				set_Pixel(gdi, newX+x, newY+y, drawInfo->rgb, localAdjust);
			}
		}
	}
}
