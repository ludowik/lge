#include "System.h"
#include "ColorView.h"

ApplicationObject<ColorView, Model> appColor("Color", "Color", "color.png");

ImplementClass(ColorGaugeControl) : public GaugeControl {
public:
	ColorViewRef m_parent;
	
	int m_type;
	
public:
	ColorGaugeControl(ColorViewRef parent, int type, int val, int max) : GaugeControl(val, max) {
		m_parent = parent;
		m_type = type;
		m_readOnly = false;
	};

	virtual ~ColorGaugeControl() {
	};
	
public:
	virtual void computeSize(GdiRef gdi) {
		GaugeControl::computeSize(gdi);
		m_rect.h = (int)( 35 * System::Media::getCoefInterface() );
	}
	
	virtual void draw(GdiRef gdi) {
		byte r = rValue(m_parent->m_color);
		byte g = gValue(m_parent->m_color);
		byte b = bValue(m_parent->m_color);
		
		int h = hValue(m_parent->m_color);
//		int s = sValue(m_parent->m_color);
//		int l = lValue(m_parent->m_color);
		
		Color color;
		Color centerColor;

        if ( m_type == red )
            fromto(int, x, 0, m_rect.w) {
				color = Rgb(x*Rmax/m_rect.w, g, b);
                if ( x == (int)( m_rect.w / 2 ) )
                    centerColor = color;
                
                gdi->line(m_rect.x+x, m_rect.y, m_rect.x+x, m_rect.y+m_rect.h, color);
            }
        else if ( m_type == green )
            fromto(int, x, 0, m_rect.w) {
				color = Rgb(r, x*Gmax/m_rect.w, b);
                if ( x == (int)( m_rect.w / 2 ) )
                    centerColor = color;
                
                gdi->line(m_rect.x+x, m_rect.y, m_rect.x+x, m_rect.y+m_rect.h, color);
            }
        else if ( m_type == blue )
            fromto(int, x, 0, m_rect.w) {
				color = Rgb(r, g, x*Bmax/m_rect.w);
                if ( x == (int)( m_rect.w / 2 ) )
                    centerColor = color;
                
                gdi->line(m_rect.x+x, m_rect.y, m_rect.x+x, m_rect.y+m_rect.h, color);
            }
        else if ( m_type == 0 )
            fromto(int, x, 0, m_rect.w) {
				color = hsl2rgb((int)(x*Hmax/m_rect.w), (int)(Smax), (int)(Lmax*2./3.));
                if ( x == (int)( m_rect.w / 2 ) )
                    centerColor = color;
                
                gdi->line(m_rect.x+x, m_rect.y, m_rect.x+x, m_rect.y+m_rect.h, color);
            }
        else if ( m_type == 1 )
            fromto(int, x, 0, m_rect.w) {
				color = hsl2rgb((int)(h), (int)(x*Smax/m_rect.w), (int)(Lmax*2./3.));
                if ( x == (int)( m_rect.w / 2 ) )
                    centerColor = color;
                
                gdi->line(m_rect.x+x, m_rect.y, m_rect.x+x, m_rect.y+m_rect.h, color);
            }
        else if ( m_type == 2 )
            fromto(int, x, 0, m_rect.w) {
				color = hsl2rgb((int)(h), (int)(Smax), (int)(x*Lmax/m_rect.w));
                
                if ( x == (int)( m_rect.w / 2 ) )
                    centerColor = color;
                
                gdi->line(m_rect.x+x, m_rect.y, m_rect.x+x, m_rect.y+m_rect.h, color);
            }
		
		double pct = percent();		
		int x = (int) ( m_rect.w * pct );
		
		Color invertColor = invert(centerColor);
		gdi->rect(m_rect.x+x-1, m_rect.y, 2, m_rect.h, invertColor, invertColor);
		
		m_text = m_val;
		computeSizeText(gdi, m_text);
		
		gdi->text(xLayoutText(), yLayoutText(), m_text, invertColor);
		
	};
    
    virtual bool touchMove(int x, int y) {
        GaugeControl::touchMove(x, y);
        touchNotify();
        return false;
    }

    

};

ColorView::ColorView(Color color) : View() {
	m_class = "ColorView";
	m_color = color;
    m_hex = asHexa(m_color);
    
    m_shouldRotateToLandscape = false;
}

ColorView::~ColorView() {
}

void ColorView::createUI() {
	ControlRef panel = startPanel(posHCenter); {
		panel->m_marginIn.setMargin(8);
        		        
		panel = startPanel(posWCenter); {
            panel->m_marginIn.setMargin(10);
            
            add(new ColorControl(Rgb(255,   0,   0)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(  0, 255,   0)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(  0,   0, 255)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(255, 255,   0)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            
            add(new ColorControl(Rgb(255,   0, 255)), posNextLine)->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(  0, 255, 255)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(128, 128, 128)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(128, 192, 192)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            
            add(new ColorControl(Rgb(192, 128, 192)), posNextLine)->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(192, 128, 128)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(192, 192, 192)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            add(new ColorControl(Rgb(128, 192, 128)))->setListener(this, (FunctionRef)&ColorView::onDefineColor);
            
            m_colorCtrl = (ColorControlRef)add(new ColorControl(m_color), posNextCol|posDefaultSize);
            m_colorCtrl->m_rect.w = 80;
            m_colorCtrl->m_rect.h = 80;

            add(new StaticControl(&m_hex), posBelow);

            add(new ButtonControl("C"))->setListener(this, (FunctionRef)&ColorView::onCopy);
            add(new ButtonControl("M"))->setListener(this, (FunctionRef)&ColorView::onMail);
		}
        endPanel();
        
        panel = startPanel(posNextLine|posRightExtend); {
			panel->m_marginIn.setMargin(8);
			panel->m_marginEx.setMargin(8);

			startPanel(posNextLine); {
				startPanel(posNextLine); {
					add(new StaticControl("R"), posHCenter);
					m_rGauge = (GaugeControl*)add(new ColorGaugeControl(this, red, rValue(m_color), Rmax), posRight|posRightExtend);
					m_rGauge->setListener(this, (FunctionRef)&ColorView::onRGBColor);
				}
				endPanel();

				startPanel(posNextLine); {
					add(new StaticControl("G"), posHCenter);
					m_gGauge = (GaugeControl*)add(new ColorGaugeControl(this, green, gValue(m_color), Gmax), posRight|posRightExtend);
					m_gGauge->setListener(this, (FunctionRef)&ColorView::onRGBColor);
				}
				endPanel();

				startPanel(posNextLine); {
					add(new StaticControl("B"), posHCenter);
					m_bGauge = (GaugeControl*)add(new ColorGaugeControl(this, blue, bValue(m_color), Bmax), posRight|posRightExtend);
					m_bGauge->setListener(this, (FunctionRef)&ColorView::onRGBColor);
				}
				endPanel();
			}
			endPanel();
			
			startPanel(posRight); {
				startPanel(posNextLine); {
					add(new StaticControl("H"), posHCenter);
					m_hGauge = (GaugeControl*)add(new ColorGaugeControl(this, 0, hValue(m_color), Hmax), posRight|posRightExtend);
					m_hGauge->setListener(this, (FunctionRef)&ColorView::onHSLColor);
				}
				endPanel();

				startPanel(posNextLine); {
					add(new StaticControl("S"), posHCenter);
					m_sGauge = (GaugeControl*)add(new ColorGaugeControl(this, 1, sValue(m_color), Smax), posRight|posRightExtend);
					m_sGauge->setListener(this, (FunctionRef)&ColorView::onHSLColor);
				}
				endPanel();

				startPanel(posNextLine); {
					add(new StaticControl("L"), posHCenter);
					m_lGauge = (GaugeControl*)add(new ColorGaugeControl(this, 2, lValue(m_color), Lmax), posRight|posRightExtend);
					m_lGauge->setListener(this, (FunctionRef)&ColorView::onHSLColor);
				}
				endPanel();
			}
            endPanel();
		}
		endPanel();
		
		add(new ButtonControl("Reverse"), posNextLine|posWCenter)->setListener(this , (FunctionRef)&ColorView::onReverse);
	}
	endPanel();

    m_rGauge->m_border = true;
    m_gGauge->m_border = true;
    m_bGauge->m_border = true;
    m_hGauge->m_border = true;
    m_sGauge->m_border = true;
    m_lGauge->m_border = true;
}

NSString* nst(const char* s);

bool ColorView::onCopy(ObjectRef obj) {
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if ( pasteboard ) {
        pasteboard.persistent = YES;
        
        NSString *string = nst(m_hex);
        [pasteboard setString:string];
        
        /*UIColor* color = [UIColor colorWithRed:rValue(m_color) green:gValue(m_color) blue:bValue(m_color) alpha:1];
         [pasteboard setColor:color];*/
    }
    
    return true;
}

bool ColorView::onMail(ObjectRef obj) {
    NSString *subject = @"Selected Color";
    NSString *body = nst(m_hex);
    NSString *path = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@", subject, body];
    NSURL *stringURL = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] openURL:stringURL];
    
    return true;
}


bool ColorView::onDefineColor(ObjectRef obj) {
	Color color = ((ColorControlRef)obj)->m_rgb;
	
	int r = rValue(color);
	int g = gValue(color);
	int b = bValue(color);
	
	setRGBColor(r, g, b);
	return true;
}

bool ColorView::onRGBColor(ObjectRef obj) {
	setRGBColor(m_rGauge->m_val,
				m_gGauge->m_val,
				m_bGauge->m_val);
	return true;
}

bool ColorView::onHSLColor(ObjectRef obj) {
	setHSLColor(m_hGauge->m_val,
				m_sGauge->m_val,
				m_lGauge->m_val);
	return true;
}

bool ColorView::onReverse(ObjectRef obj) {
	Color color = invert(m_color);
	
	int r = rValue(color);
	int g = gValue(color);
	int b = bValue(color);
	
	setRGBColor(r, g, b);
	return true;
}

void ColorView::setRGBColor(int r, int g, int b) {
	m_color = Rgb(r, g, b);
	
	m_rGauge->m_val = r;
	m_gGauge->m_val = g;
	m_bGauge->m_val = b;	
	
	m_hGauge->m_val = hValue(m_color);
	m_sGauge->m_val = sValue(m_color);
	m_lGauge->m_val = lValue(m_color);	

	m_colorCtrl->m_rgb = m_color;
    
    m_hex = asHexa(m_color);
}

void ColorView::setHSLColor(int h, int s, int l) {
	m_color = hsl2rgb(h, s, l);
	
	m_rGauge->m_val = rValue(m_color);
	m_gGauge->m_val = gValue(m_color);
	m_bGauge->m_val = bValue(m_color);
	
	m_hGauge->m_val = h;
	m_sGauge->m_val = s;
	m_lGauge->m_val = l;	
	
	m_colorCtrl->m_rgb = m_color;

    m_hex = asHexa(m_color);
}

Color selectColor(Color color) {
	ColorView colorDialog(color);
	colorDialog.run();
	
	return colorDialog.m_color;
}
