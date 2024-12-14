#pragma once

#include "Control.h"

ImplementClass(GraphSerie) : public List {
public: 
	GraphSerie();
	virtual ~GraphSerie();

public:
	DoubleRef get(int i) {
		return (DoubleRef)List::get(i);
	}
	
};

ImplementClass(GraphSeries) : public List {
public: 
	GraphSeries();
	virtual ~GraphSeries();

public:
	virtual GraphSerie* get(int i) {
		return (GraphSerie*)List::get(i);
	}
	
};

ImplementClass(GraphControl) : public Control {
private:
	ImplementClass(Data)* data;
	
public:
	int m_mode;
	
	int m_mx;
	int m_my;
	
	int m_x;
	int m_y;
	
	bool m_x_marque1;
	bool m_x_marque2;
	
	bool m_y_marque1;
	bool m_y_marque2;
	
	Color m_color_axe;
	Color m_color_marque;
	
	GraphSeries* m_series;
	
public:
	GraphControl(GraphSeries* series, int mode);
	virtual ~GraphControl();
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void drawBackground(GdiRef gdi);
	virtual void draw(GdiRef gdi);
	
private:
	void DECL(GdiRef gdi);
    
	void Quadrillage(GdiRef gdi);
	void Quadrillage(GdiRef gdi, int x, int y, int lenx, int leny, int dx, int dy, Color color, bool inter);
	
	void HistogrammeGroupe   (GdiRef gdi);
	void HistogrammeEmpile   (GdiRef gdi);
	void HistogrammeEmpile100(GdiRef gdi);
	void Courbe              (GdiRef gdi);
	void CourbeEmpile        (GdiRef gdi);
	void CourbeEmpile100     (GdiRef gdi);
	void Area                (GdiRef gdi);
	void AreaEmpile          (GdiRef gdi);
	void Secteur             (GdiRef gdi);
		
};

enum {
	graphFirst=1,
	graphHistogrammeGroupe=graphFirst,
	graphHistogrammeEmpile,
	graphHistogrammeEmpile100,
	graphCourbe,
	graphCourbeEmpile,
	graphCourbeEmpile100,
	graphArea,
	graphAreaEmpile,
	graphSecteur,
	graphLast
	
};
