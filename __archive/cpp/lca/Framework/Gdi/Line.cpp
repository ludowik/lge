#include "System.h"
#include "Line.h"

Line::Line() {
	m_points = new List();
}

Line::Line(PointRef from, PointRef to, int precision, int n) {
	m_points = new List();
	
	x = from->x;
	y = from->y;
	
	w = to->x-x;
	h = to->y-y;
	
	m_precision = precision;
	m_n = n;
}

Line::~Line() {
	if ( m_points ) {
		delete m_points;
	}
}

int Line::getCount() {
	assert(m_points);
	return m_points->getCount();
}

Point Line::get(int i) {
	assert(m_points);
	PointRef pos = (PointRef)m_points->get(i);
	return pos?pos[0]:Point();
}

void Line::release(int i) {
	assert(m_points);
	m_points->release(i);
}

int Line::initLine() {
	assert(m_points);

	m_points->releaseAll();

	m_points->add(new Point(x,y));
	
	if ( w != 0 || h != 0 ) {
		double _x = x;
		double _y = y;
		
		double size = (int)sqrt( w * w + h * h );

		if ( m_n != -1 ) {
			m_precision = max(1, size / m_n);
		}

		double dx = (double)w / (double)size;
		double dy = (double)h / (double)size;
		
		for ( double i = m_precision ; i < size ; i += m_precision ) {
			_x += dx * m_precision;
			_y += dy * m_precision;
			
			m_points->add(new Point(_x,_y));
		}
		
		m_points->add(new Point(x+w, y+h));
	}
	
	return m_points->getCount();
}

IteratorRef Line::getIterator() {
	assert(m_points);
	
	initLine();	
	return m_points->getIterator();
}
