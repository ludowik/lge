#include "System.h"
#include "Demo.h"
#include "Matrix.h"

ApplicationObject<Demo, Model> appDemo("Demo", "Demo", "demo.png");

ImplementClass(GdiControl) : public Control {
public:
	GdiControl() {
	};
	
public:
	virtual void computeSize(GdiRef gdi);
	virtual void draw(GdiRef gdi);

};

Demo::Demo() : View() {	
	System::Font::fontNames(&m_fontNames);
}

void Demo::createUI() {
	m_accx = 0;
	m_accy = 0;
	m_accz = 0;
    
	startPanel(0, new TabsControl()); {
		startPanel(0, new TabsPanel("Lanceur..." )); {
            add(new ButtonControl("Test"         ))->setListener(this , (FunctionRef)&Demo::launchTest);
            add(new ButtonControl("App Store"    ))->setListener(this , (FunctionRef)&Demo::launchAppStore);
            add(new ButtonControl("iTunes Store" ))->setListener(this , (FunctionRef)&Demo::launchiTunesStore);
            add(new ButtonControl("Google Maps 1"))->setListener(this , (FunctionRef)&Demo::launchGoogleMaps1);
            add(new ButtonControl("Google Maps 2"))->setListener(this , (FunctionRef)&Demo::launchGoogleMaps2);
            add(new ButtonControl("Call Home"    ))->setListener(this , (FunctionRef)&Demo::launchCall);
            add(new ButtonControl("Send eMail"   ))->setListener(this , (FunctionRef)&Demo::launchMail);
            add(new ButtonControl("Send SMS"     ))->setListener(this , (FunctionRef)&Demo::launchSMS);
            add(new ButtonControl("Safari"       ))->setListener(this , (FunctionRef)&Demo::launchSafari);
            add(new ButtonControl("YouTube"      ))->setListener(this , (FunctionRef)&Demo::launchYouTube);
            add(new ButtonControl("FaceBook"     ))->setListener(this , (FunctionRef)&Demo::launchFaceBook);
        }
        endPanel();

		startPanel(0, new TabsPanel("Ascii")); {
			String ascii;
			for ( int i = 32 ; i < 255 ; ++i ) {
				ascii += String((char)i);
				ascii += String(" ");
			}
			startPanel(); {
				add(new StaticControl(ascii));
			}
			endPanel();
		}
		endPanel();

		startPanel(0, new TabsPanel("Font")); {
			fromto(int, i, 0, m_fontNames.getCount()) {
				StringRef fontName = (StringRef)m_fontNames[i];
				add(new StaticControl(fontName->getBuf()))->m_fontName = fontName->getBuf();
			}	
		}
		endPanel();
		
		startPanel(0, new TabsPanel("Gdi")); {
			startPanel(posRightExtend|posBottomExtend); {
				add(new StaticControl("N"), posTopAlign   |posWCenter);
				add(new StaticControl("S"), posBottomAlign|posWCenter);
				add(new StaticControl("O"), posLeftAlign  |posHCenter);
				add(new StaticControl("E"), posRightAlign |posHCenter);
				
				add(new GdiControl());
				
				add(new StaticControl("NO"), posTopAlign|posLeftAlign);
				add(new StaticControl("NE"), posTopAlign|posRightAlign);
				add(new StaticControl("SO"), posBottomAlign|posLeftAlign);
				add(new StaticControl("SE"), posBottomAlign|posRightAlign);
			}
			endPanel();
		}
		endPanel();
		
		startPanel(0, new TabsPanel("Gui")); {
			startPanel(); {
				m_accx = (FloatControlRef)add(new FloatControl(), posNextLine);
				m_accy = (FloatControlRef)add(new FloatControl(), posNextLine);
				m_accz = (FloatControlRef)add(new FloatControl(), posNextLine);
				
				add(new StaticControl("Nom"), posNextLine);
				add(new EditControl(0));
				
				add(new StaticControl("Prenom"), posNextLine);
				add(new EditControl(0));
				
				add(new StaticControl("Batterie"), posNextLine);
				add(new BatteryControl());
				
				add(new StaticControl("Volume"), posNextLine);
				add(new VolumeControl());
				
				add(new StaticControl("Gauge"), posNextLine);
				add(new GaugeControl(23));
				
				add(new StaticControl("Date"), posNextLine);
				add(new DateControl());
				
				add(new StaticControl("Heure"), posNextLine);
				add(new TimeControl());
				
				add(new StaticControl("Float"), posNextLine);
				add(new FloatControl(12.12));
				
				add(new StaticControl("Integer"), posNextLine);
				add(new IntegerControl(12));}
			endPanel();
			
			startPanel(posRight); {
				add(new StaticControl("List"), posNextLine);
				
				ListControl* listControl = (ListControl*)add(new ListControl());
				listControl->m_values.add(new String("1 min"));
				listControl->m_values.add(new String("3 min"));
				listControl->m_values.add(new String("5 min"));
				
				add(new CheckBoxControl("Case à cocher"), posNextLine);
				
				add(new RadioButtonControl("Bouton radio 1"), posNextLine);
				add(new RadioButtonControl("Bouton radio 2"), posNextLine);
				add(new RadioButtonControl("Bouton radio 3"), posNextLine);
				
				add(new ColorControl(red), posNextLine);
				add(new ColorControl(green));
				add(new ColorControl(blue));
				
				add(new BitmapControl("lca.png", 32, 32), posNextLine);
				
				add(new CalendarControl(), posNextLine);
			}
			endPanel();
		}
		endPanel();
		
		startPanel(0, new TabsPanel("Graphe")); {
			m_series.releaseAll();
			
			int s = 1;
			int n = 20;
			
			for ( int g = 0 ; g < s ; ++g ) {
				GraphSerie* serie = new GraphSerie();
				m_series.add(serie);
				for ( int i = 0 ; i < n ; ++i ) {
					serie->add(new Double(System::Math::random(100)));
				}
			}
			
			fromto(int, ordre, 0, 3) {
				Matrix m;
				RegressionPolynomiale(m, m_series.get(0), ordre);
				
				GraphSerie* serie = new GraphSerie();
				m_series.add(serie);
				
				fromto(int, x, 0, n) {
					double val = m.get(0,0);
					fromto(int, iordre, 1, ordre+1) {
						val += m.get(iordre,0) * pow(x+1, iordre);
					}
					serie->add(new Double(val));
				}
			}
			
			startPanel(); {
				fromto(int, i, graphFirst, graphLast) {
					add(new GraphControl(&m_series, i));
				}
			}
			endPanel();
		}
		endPanel();
	}
	endPanel();
}

void Demo::createToolBar() {
	m_toolbar = (ToolBarControlRef)startPanel(0, new ToolBarControl()); {
		add(new ButtonControl("End"))->setListener(this , (FunctionRef)&View::onClose);
	}
	endPanel();
}

bool Demo::acceleration(double x, double y, double z) {
	if ( m_accx ) {
		m_accx->m_value = x;
		m_accy->m_value = y;
		m_accz->m_value = z;
	}
	
	return true;
}

void GdiControl::computeSize(GdiRef gdi) {
	m_rect.w = gdi->m_rect.w;
	m_rect.h = gdi->m_rect.w;
}

void GdiControl::draw(GdiRef gdi) {
	Rect rect;
	
	gdi->moveto(m_rect.x+100, m_rect.y+100);
	gdi->lineto(m_rect.x+200, m_rect.y+200);
	
	gdi->line(m_rect.x+150, m_rect.y+100, m_rect.x+250, m_rect.y+200);
	
	int h = 10;
	
	char* s = "Test";
	for ( int i = 0 ; i < 6 ; ++i ) {
		rect = gdi->text(m_rect.x+10, m_rect.y+h, s, white, 0, 8+2*i);
		
		h += 12+2*i;
	}
	
	h += 10;
	
	s = "A";
	for ( int i = 0 ; i < 9 ; ++i ) {
		gdi->text(m_rect.x+10+10*i, m_rect.y+h, s, white, 0, 8, i*45);
	}
	
	gdi->roundgradient(m_rect.x+ 10, m_rect.y+150, 80, 100, 20, eHorizontal, red, yellow);
	gdi->roundgradient(m_rect.x+110, m_rect.y+150, 80, 100, 20, eVertical  , red, yellow);
	gdi->roundgradient(m_rect.x+210, m_rect.y+150, 80, 100, 20, eDiagonal  , red, yellow);
	
	BitmapRef bmp = new Bitmap();
	bmp->create(30, 50);
	bmp->line(0, 0, 29, 49);
	
	gdi->copy(bmp, m_rect.x+ 10, m_rect.y+300, 0, 0);
	
	Pixelisation(bmp, 4).execute();
	gdi->copy(bmp, m_rect.x+ 50, m_rect.y+300, 0, 0);
	
	Blur(bmp).execute();
	gdi->copy(bmp, m_rect.x+ 90, m_rect.y+300, 0, 0);
	
	Colorisation(bmp, 8).execute();
	gdi->copy(bmp, m_rect.x+130, m_rect.y+300, 0, 0);
	
	Luminosite(bmp, .8).execute();
	gdi->copy(bmp, m_rect.x+170, m_rect.y+300, 0, 0);
	
	Binarisation(bmp, 64).execute();
	gdi->copy(bmp, m_rect.x+210, m_rect.y+300, 0, 0);
	
	GrayScale(bmp).execute();
	gdi->copy(bmp, m_rect.x+250, m_rect.y+300, 0, 0);
	
	Squelettisation(bmp).execute();
	gdi->copy(bmp, m_rect.x+ 10, m_rect.y+360, 0, 0);
	
	delete bmp;
	
	// Test alignement
	gdi->rect(m_rect.x+  1, m_rect.y+  1, 100, 100, red);
	
	gdi->line(m_rect.x+102, m_rect.y+  1, 200,   1, blue);
	gdi->line(m_rect.x+  1, m_rect.y+102,   1, 200, blue);
	
	gdi->circle(m_rect.center().x, m_rect.center().y, 50, red); {
		gdi->pie(m_rect.center().x, m_rect.center().y, 60,   0, 45, blue );
		gdi->pie(m_rect.center().x, m_rect.center().y, 60,  90, 45, red  );
		gdi->pie(m_rect.center().x, m_rect.center().y, 60, 180, 45, white);
		gdi->pie(m_rect.center().x, m_rect.center().y, 60, 270, 45, green);
	}
	
	int n = 10;
	fromto(int,part,0,n) {
		gdi->pie(m_rect.center().x, m_rect.center().y, 40, part*360/n, 360/n, brown, brown);
	}
}

bool Demo::launchTest(ObjectRef obj) {
    NSString *stringURL = @"lca://";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;    
}

bool Demo::launchAppStore(ObjectRef obj) {
//    NSString *stringURL = @"http://itunes.apple.com/fr/app/id390017969?mt=8";
    NSString *stringURL = @"itms-apps://itunes.apple.com/fr/genre/mobile-software-applications/id36?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

bool Demo::launchiTunesStore(ObjectRef obj) {
    NSString *stringURL = @"itms://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPodcast?id=315986667";;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

bool Demo::launchGoogleMaps1(ObjectRef obj) {
    NSString *stringURL = @"http://maps.google.com/maps?q=london";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

bool Demo::launchGoogleMaps2(ObjectRef obj) {
    NSString *title = @"Le%20hasard%20du%20jour";
    
    float latitude = random()%2000/100;
    float longitude = random()%2000/100;
    
    int zoom = 4;
    
    NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@@%1.6f,%1.6f&z=%d", title, latitude, longitude, zoom];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

bool Demo::launchCall(ObjectRef obj) {
    NSString *stringURL = @"tel:0145061259";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

bool Demo::launchMail(ObjectRef obj) {
    NSString *subject = @"Message subject";
    NSString *body = @"Message body";
    NSString *address = @"lmilhau@free.fr";
    NSString *cc = @"ludovic.milhau@free.fr";
    
    NSString *path = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@", address, cc, subject, body];
    NSURL *stringURL = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [[UIApplication sharedApplication] openURL:stringURL];
    return true;
}

bool Demo::launchSMS(ObjectRef obj) {
    NSString *stringURL = @"sms:0643861874";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

bool Demo::launchSafari(ObjectRef obj) {
    NSString *stringURL = @"http://";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

bool Demo::launchYouTube(ObjectRef obj) {
    NSString *stringURL = @"http://www.youtube.com/watch?v=WofOn4mdC0s";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

bool Demo::launchFaceBook(ObjectRef obj) {
    /*
     fb://profile – Pour votre Profil
     fb://friends – Pour votre Liste d'amis
     fb://feed – Pour les Actus en direct
     fb://events – Pour les Evènements
     fb://requests – Pour les Requêtes
     fb://notifications – Pour les Requêtes
     fb://notes- Pour les Notes
     fb://albums – Pour les Albums photo
     */
    
    NSString *stringURL = @"fb://profile";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
    return true;
}

// NSString *stringURL = @"tweetie://post?message=Coucou%20Ludovic";
// NSString *stringURL = @"linkedin://";
// NSString *stringURL = @"skype:bixcorp?call"; // chat, call, add
