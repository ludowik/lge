#include "System.h"

#if (_WINDOWS)
#elif (_MAC)
#endif

#if (_WINDOWS)
	//#include "Resource.h"

#elif (_MAC)
	#include <AudioToolbox/AudioToolbox.h>

	#include <memory.h>
	#include <xlocale.h>

#endif

#include "Gdi.h"
#include "String.h"

const char* defaultFontName = 0;

int defaultFontSize = 0;

void System::Media::initInterface() {
	defaultFontName = "Courier";
	
	switch ( getMachineType() ) {
		case iPhone:
			defaultFontSize = 18;
			break;
		case iPad:
			defaultFontSize = 28;
			break;
	}
}

double System::Media::getCoefInterface() {
	switch ( getMachineType() ) {
		case iPhone:
			return 1.;
		case iPad:
			return 3.;
	}
	return 1.;
}

static int g_machineType = iPad;

int System::Media::setMachineType(int machineType) {
	g_machineType = machineType;
	return g_machineType;
}

int System::Media::getMachineType() {
#if (_WINDOWS)	
	return g_machineType;

#elif (_MAC)
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		// The device is an iPad running iPhone 3.2 or later
		return iPad;
	}
	else {
		// The device is an iPhone or iPod touch
		return iPhone;
	}
#endif
}

#if ( _MAC )
const NSStringEncoding kEncoding_char = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);

NSString* nst(const char* s) {
	void* data = (void*)s;
	unsigned int dataSize = strlen(s) * sizeof(char);
	
	return [[[NSString alloc] initWithBytes:data length:dataSize encoding:kEncoding_char] autorelease];
}

#endif

const char* System::String::load(const char* id) {
	return load("lca", id);
}

const char* System::String::load(const char* domain, const char* id) {
	static char string[STRING_COUNT][STRING_SIZE+1];
	static int is = -1;

	is++;
	if ( is == STRING_COUNT ) {
		is = 0;
	}

	domain = domain?domain:"lca";

	strcpy(string[is], id);
	
#if (_WINDOWS)
	HINSTANCE hInst = (HINSTANCE)System::Media::getActiveInstance();

	HRSRC hResource = FindResourceA(hInst, domain, "FILE");
	if ( hResource ) {
		HGLOBAL hglobalResource = LoadResource(hInst, hResource);
		assert(hglobalResource);
	
		wchar_t* source = (wchar_t*)LockResource(hglobalResource);
		assert(source);
	
		size_t destSize = wcslen(source);
		
		char* destination = (char*)malloc(sizeof(char)*(destSize+1));
		assert(destination);

		char* mbs = destination;
		wchar_t* wcs = source;
		while ( wcs[0] && destSize ) {
			int len = wctomb(mbs, wcs[0]);
			if ( len != -1 ) {
				mbs++;
				destSize--;
			}
			wcs++;
		}
		mbs[0] = 0;

		mbs = destination;
	
		int len = 0;
		int sublen = 0;

		while ( mbs[len] ) {
			while ( mbs[len] && mbs[len] != '"' ) {
				len++;
			}

			if ( mbs[len] == 0 ) {
				break;
			}
			else if ( mbs[len] == '"' ) {
				len++;
				sublen = 0;
				while ( mbs[len+sublen] && mbs[len+sublen] != '"' ) {
					sublen++;
				}

				::String key(&mbs[len], sublen);
				len += sublen+1;

				while ( mbs[len] && mbs[len] != '"' ) {
					len++;
				}

				if ( mbs[len] == '"' ) {
					len++;
					sublen = 0;
					while ( mbs[len+sublen] && mbs[len+sublen] != '"' ) {
						sublen++;
					}

					::String value;
					fromto(int, i, 0, sublen) {
						if ( mbs[len+i] == '\n' && mbs[len+i-1] != '\r' && mbs[len+i-1] != '>' ||
							 mbs[len+i] == '\n' && mbs[len+i-1] == '\r' && mbs[len+i-2] != '>' ) {
							value += ::String(' ');
						}
						else if ( (unsigned char)mbs[len+i] >= 32 ) {
							value += ::String(mbs[len+i]);
						}
					}

					len += sublen+1;

					if ( key == id ) {
						strcpy(string[is], value.getBuf());
						break;
					}

					while ( mbs[len] && mbs[len] != ';' ) {
						len++;
					}

					if ( mbs[len] == ';' ) {
						len++;
					}
					else {
						assert(0);
					}
				}
				else {
					assert(0);
				}
			}
			else {
				assert(0);
			}
		}

		free(destination);

		UnlockResource(hglobalResource);
	}

#elif (_MAC)
	static char mbs[STRING_SIZE+1];
	
	NSString* ns = NSLocalizedStringFromTable(nst(id), nst(domain), nst(""));
	if ( ns ) {
		[[ns dataUsingEncoding:kEncoding_char allowLossyConversion:YES] getBytes:mbs length:STRING_SIZE];
	}
	
	int l = strlen(mbs);

	::String value;
	fromto(int, i, 2, l) {
		if ( mbs[i] == '\n' && mbs[i-1] != '\r' && mbs[i-1] != '>' ||
			 mbs[i] == '\n' && mbs[i-1] == '\r' && mbs[i-2] != '>' ) {
			value += ::String(' ');
		}
		else if ( (unsigned char)mbs[i] >= 32 ) {
			value += ::String(mbs[i]);
		}
	}
	
	strcpy(string[is], value.getBuf());
	
#endif

	return string[is];
}

System::Time::Time System::Time::getTime() {
	Time res;
	memset(&res, 0, sizeof(res));

#if (_WINDOWS)
	tm now;
	time_t szClock;

	time(&szClock);
	localtime_s(&now, &szClock);

	res.hour   = now.tm_hour;
	res.minute = now.tm_min;
	res.second = now.tm_sec;
	
	res.day   = now.tm_mday;
	res.month = now.tm_mon;
	res.year  = now.tm_year+1900;

#elif (_MAC)
	CFTimeZoneRef timeZone = CFTimeZoneCopySystem(); 
	CFGregorianDate date = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), timeZone);
	
	res.hour   = (int)(date.hour);
	res.minute = (int)(date.minute);
	res.second = (int)(date.second);
	
	res.day   = (int)(date.day);
	res.month = (int)(date.month);
	res.year  = (int)(date.year);
	
#endif

	return res;
}

void System::Time::sleep(int millisecond) {
	Timer timer;

	timer.timerInit();
	timer.timerWait(millisecond);
}

// LARGE_INTEGER to 64-bit integral type:
static long long toInteger(LARGE_INTEGER const& integer) {
#ifdef INT64_MAX // Does the compiler natively support 64-bit integers?
	return integer.QuadPart;
#else
	return (static_cast<long long>(integer.HighPart) << 32) | integer.LowPart;
#endif
}

// signed long long to LARGE_INTEGER object:
static LARGE_INTEGER toLargeInteger(long long value) {
	LARGE_INTEGER result = {0,0};

#ifdef INT64_MAX // Does the compiler natively support 64-bit integers?
	result.QuadPart = value;
#else
	result.HighPart = value & 0xFFFFFFFF00000000;
	result.LowPart = value & 0xFFFFFFFF;
#endif
	return result;
}

long System::Time::ellapsedMilliseconds() {
	static bool init = false;

#if (_WINDOWS)
	static LARGE_INTEGER m_nFreq = toLargeInteger(0);
	static LARGE_INTEGER m_nBeginTime = toLargeInteger(0);
	
	if ( init == false ) {
		init = true;
		QueryPerformanceFrequency(&m_nFreq);
		QueryPerformanceCounter(&m_nBeginTime);
	}

	LARGE_INTEGER nEndTime;
	QueryPerformanceCounter(&nEndTime);
	
	long nCalcTime = (long) ( (nEndTime.QuadPart - m_nBeginTime.QuadPart) * 1000 / m_nFreq.QuadPart );

#elif (_MAC)
	static NSTimeInterval referenceTime = 0;
	NSTimeInterval elapsedTime = 0;
	
	if ( init == false ) {
		init = true;
		referenceTime = [NSDate timeIntervalSinceReferenceDate];
	}
	else {
		elapsedTime = [NSDate timeIntervalSinceReferenceDate]-referenceTime;
	}
	
	long nCalcTime = (long)(elapsedTime*1000);

#endif

	return nCalcTime;
}

long System::Time::ellapsedTicks() {
	long t = clock();

#if (_WINDOWS)
	t /= 1000;

#elif (_MAC)
	t /= CLOCKS_PER_SEC;

#endif

	return t;
}

const char* System::Time::getDayName(int d, bool longName) {
	return "";
}

const char* System::Time::getMonthName(int m, bool longName) {
	const char* r = "";
	if ( longName ) {
		switch ( m ) {
		case  1: r = "Janvier" ; break;
		case  2: r = "Fevrier"  ; break;
		case  3: r = "Mars"     ; break;
		case  4: r = "Avril"    ; break;
		case  5: r = "Mai"      ; break;
		case  6: r = "Juin"     ; break;
		case  7: r = "Juillet"  ; break;
		case  8: r = "Août"     ; break;
		case  9: r = "Septembre"; break;
		case 10: r = "Octobre"  ; break;
		case 11: r = "Novembre" ; break;
		case 12: r = "Decembre" ; break;
		}
	}
	else {
		switch ( m ) {
		case  1: r = "Jan" ; break;
		case  2: r = "Fev" ; break;
		case  3: r = "Mar" ; break;
		case  4: r = "Avr" ; break;
		case  5: r = "Mai" ; break;
		case  6: r = "Juin"; break;
		case  7: r = "Jui" ; break;
		case  8: r = "Aout"; break;
		case  9: r = "Sep" ; break;
		case 10: r = "Oct" ; break;
		case 11: r = "Nov" ; break;
		case 12: r = "Dec" ; break;
		}
	}

	return r;
}

int System::Time::getDayOfWeek(int time) {
#if (_WINDOWS)
	// TODO
	return 0;

#elif (_MAC)
	CFTimeZoneRef timeZone = CFTimeZoneCopySystem(); 
	return CFAbsoluteTimeGetDayOfWeek(time, timeZone);

#endif
}

int System::Time::getFirstDayOfWeek() {
	return 0;
}

void System::Math::seed(int val) {
	if ( val == 0 ) {
#if (_WINDOWS)
		time_t szClock;
		time(&szClock);

		val = (int)szClock;

#elif (_MAC)
		val = CFAbsoluteTimeGetCurrent();

#endif
	}
	::srand(val);
}

int System::Math::random(int max) {
#if (_WINDOWS)
	int randomValue = ::rand();

#elif (_MAC)
	int randomValue = ::random();

#endif
	return ( max > 0 ) ? ( randomValue % max ) : ( randomValue );
}

int System::Math::random(int min, int max) {
	if ( max - min == 0 ) {
		return min;
	}
	return min + random(max-min);
}

double System::Math::random(double max) {
	const double coeff = 1000;
	if ( max == 0 ) {
		return 0.;
	}
#if (_WINDOWS)
	return ( ::rand  () % (int)( max * coeff ) ) / coeff;

#elif (_MAC)
	return ( ::random() % (int)( max * coeff ) ) / coeff;

#endif
}

double System::Math::random(double min, double max) {
	return min + random(max-min);
}

void System::Debug::trace(const char* msg) {
#if (_WINDOWS)
	_CrtDbgReport(_CRT_WARN, 0, 0, "Test", msg);

#elif (_MAC)
#endif
}

void System::Debug::stop() {
#if (_WINDOWS)
	_CrtDbgBreak();

#elif (_MAC)
#endif
}

void System::Debug::assertion(bool expression, const char* test, const char* file, int line) {
	if ( expression == false ) {		
#if (_WINDOWS)
		_CrtDbgBreak();

#elif (_MAC)
		::String cs(file);
		cs += "(";
		cs += ::String(line);
		cs += ")";
		cs += NEWLINE;
		cs += test;

		msgAlert(cs);

#endif
		exit(0);
	}
}

double System::Battery::getPercent() {
#if (_WINDOWS)
	return 100;

#elif (_MAC)
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
	if ( [[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnknown ) {
		return 0;
	}
	return (double)[[UIDevice currentDevice] batteryLevel]*100;

#endif
}

int System::Media::getSoundVolume() {
	return 0;
}

int System::Media::setSoundVolume(int volume) {
	return volume;
}

#if (_MAC)
void repeatSound(SystemSoundID ssID, void *clientData) {
	AudioServicesRemoveSystemSoundCompletion(ssID);

	int nb = (int)clientData;
	if ( nb > 0 ) {
		// Preparation de la liberation du clip audio (dernier parametre pour jouer plusieurs fois si necessaire)
		AudioServicesAddSystemSoundCompletion(ssID, 0, 0, ::repeatSound, (void*)(--nb));		
		// Lecture du clip audio
		AudioServicesPlayAlertSound(ssID);
	}
}
#endif

SoundID System::Media::loadSound(const char* _idSound) {
#if (_WINDOWS)
	SoundID ssID = (SoundID)_idSound;

#elif (_MAC)
	NSString* idSound = [NSString stringWithUTF8String:_idSound];
	
	// Chargement du clip audio
	id soundPath = [[NSBundle mainBundle] pathForResource:idSound ofType:@"wav"];
	CFURLRef baseURL = (CFURLRef) [[NSURL alloc] initFileURLWithPath:soundPath];
	SystemSoundID ssID;
	AudioServicesCreateSystemSoundID(baseURL, &ssID);
	CFRelease(baseURL);

#endif

	return (SoundID)ssID;
}
	
void System::Media::playSound(SoundID ssID, int nb) {
#if (_WINDOWS)
	const char* id = (const char*)ssID;

	HMODULE module = GetModuleHandle(0);
	PlaySoundA(id, module, SND_RESOURCE|SND_ASYNC);

#elif (_MAC)
	// Preparation de la liberation du clip audio (dernier parametre pour jouer plusieurs fois si necessaire)
	AudioServicesAddSystemSoundCompletion((SystemSoundID)ssID, 0, 0, ::repeatSound, (void*)(--nb));	
	// Lecture du clip audio
	AudioServicesPlayAlertSound((SystemSoundID)ssID);

#endif
}

void System::Media::releaseSound(SoundID id) {
#if (_WINDOW)

#elif (_MAC)
	SystemSoundID ssID = (SystemSoundID)id;
	// Liberation du clip audio
	AudioServicesDisposeSystemSoundID(ssID);

#endif
}

static int g_gdiMode = 0;
void System::Media::setGdiMode(int gdiMode) {
	g_gdiMode = gdiMode;
}

int System::Media::getGdiMode() {
	return g_gdiMode;
}

void* g_activeWindow = 0;
void System::Media::setActiveWindow(void* wnd) {
	g_activeWindow = wnd;
}

void* System::Media::getActiveWindow() {
	return g_activeWindow;
}

void* g_activeDC = 0;
void System::Media::setActiveDC(void* dc) {
	g_activeDC = dc;
}

void* System::Media::getActiveDC() {
	return g_activeDC;
}

void* g_activeInstance = 0;
void System::Media::setActiveInstance(void* instance) {
	g_activeInstance = instance;
}

void* System::Media::getActiveInstance() {
	return g_activeInstance;
}

double System::Media::getRadius() {
	return 4;
}

#if (_WINDOWS)
UINT g_redrawFlags = RDW_INVALIDATE|RDW_NOERASE;
#endif

void System::Media::redraw(RectRef rect) {
	ViewRef view = get_view();
	view->m_needsRedraw = true;

#if (_WINDOWS)
	RedrawWindow((HWND)g_activeWindow, 0, 0, g_redrawFlags);

#elif (_MAC)
	if ( g_gdiMode == gdiModeOpenGL ) {
		view->draw(rect);
	}
	else {
        if ( rect ) {
            View::g_gdi->m_redrawRect = *rect;
        }
		[(UIView*)g_activeWindow setNeedsDisplay];
	}

#endif

	Event::waitEvent();
}

void System::Media::setNeedsRedraw(RectRef rect) {
	ViewRef view = get_view();
	view->m_needsRedraw = true;

#if (_WINDOWS)
	RedrawWindow((HWND)g_activeWindow, 0, 0, g_redrawFlags);

#elif (_MAC)
	if ( g_gdiMode == gdiModeOpenGL ) {
		view->draw(rect);
	}
	else {
		[(UIView*)g_activeWindow setNeedsDisplay];
	}

#endif
}

Rect g_rectWindows;
void System::Media::setWindowsSize() {
#if (_WINDOWS)
	RECT cgRect;
	if ( g_activeWindow ) {
		GetClientRect((HWND)g_activeWindow, &cgRect);
		
		g_rectWindows.w = cgRect.right-cgRect.left;
		g_rectWindows.h = cgRect.bottom-cgRect.top;
	}
	else {
		g_rectWindows.w = 240;
		g_rectWindows.h = 240;
	}
	
#elif (_MAC)
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	
	if ( getOrientation() == orientationLandscape ) {
		g_rectWindows.w = applicationFrame.size.height;
		g_rectWindows.h = applicationFrame.size.width;
	}
	else {
		g_rectWindows.w = applicationFrame.size.width;
		g_rectWindows.h = applicationFrame.size.height;
	}
	
#endif
}

Rect System::Media::getWindowsSize() {
	return g_rectWindows;
}

int g_orientation = orientationUnknown;

int System::Media::setOrientation(int _orientation) {
#if (_WINDOWS)
	if ( _orientation != orientationDefault ) {
		g_orientation = _orientation;
	}
	else if ( g_orientation == orientationPortrait ) {
		g_orientation = orientationLandscape;
	}
	else {
		g_orientation = orientationPortrait;
	}

#elif (_MAC)
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
    ViewRef view = get_view();

	int newOrientation = g_orientation;
	
    if ( UIDeviceOrientationIsLandscape(orientation) ) {
        if ( view && view->shouldAutorotateToInterfaceOrientation(orientationLandscape) ) {
            newOrientation = orientationLandscape;
        }
    }
	else if ( UIDeviceOrientationIsPortrait(orientation) ) {
        if ( view && view->shouldAutorotateToInterfaceOrientation(orientationPortrait) ) {
            newOrientation = orientationPortrait;            
        }
	}
    
    g_orientation = newOrientation;

#endif

	return g_orientation;
}

int System::Media::getOrientation() {
	return g_orientation;
}

Res System::Media::loadResource(const char* type, const char* id) {
	// TODO
	return 0;
}

void System::Font::familyNames(ListRef list) {
#if (_WINDOWS)
	// TODO

#elif (_MAC)
	NSArray* array = [UIFont familyNames];
	
	int count = [array count];
	for ( int i = 0 ; i < count ; ++i ) {
		list->add(new ::String((char*)[[array objectAtIndex:i] UTF8String]));
	}

#endif
}

void System::Font::fontNames(ListRef list, const char* familyName) {
	if ( familyName == 0 ) {
		List familyNamesList;
		familyNames(&familyNamesList);
		foreach ( ::StringRef , fName , familyNamesList ) {
			fontNames(list, fName->getBuf());
		}
	}
	else {
#if (_WINDOWS)
	// TODO

#elif (_MAC)
		NSString* fName = [NSString stringWithUTF8String:familyName];
		NSArray* array = [UIFont fontNamesForFamilyName:fName];

		int count = [array count];
		for ( int i = 0 ; i < count ; ++i ) {
			list->add(new ::String((char*)[[array objectAtIndex:i] UTF8String]));
		}

#endif
	}
}

void System::Event::waitEvent() {
#if (_WINDOWS)
	BOOL ret = FALSE;

	MSG msg;
	if ( PeekMessage(&msg, 0, 0, 0, FALSE) ) {  // PeekMessage n'est pas bloquant et ne vide pas la file d'attente
		if ( ( ret = GetMessage( &msg, 0, 0, 0 ) ) != 0 ) {
			if ( ret == -1 ) {
				return;
			}
			else {
				if ( msg.message == WM_TIMER ) { 
					msg.hwnd = (HWND)Media::getActiveWindow();
				}

				TranslateMessage(&msg);

				DispatchMessage(&msg);
			}
		}		
	}

#elif (_MAC)
	CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, FALSE);

#endif
}

#if (_WINDOWS)
#elif (_MAC)
	id g_progressId = 0;
#endif

void System::Event::startWaitAnimation(int progressId) {
#if (_WINDOWS)
	SetCursor(LoadCursor(0, IDC_WAIT));	

#elif (_MAC)
	if ( progressId != 0 ) {
		g_progressId = (id)progressId;
	}
	
	if ( g_progressId != 0 ) {
		// Centrage de l'animation
		CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
		CGRect progressBounds = [g_progressId bounds];
		
		[g_progressId setFrame:CGRectMake(( applicationFrame.size.width  - progressBounds.size.width  )/2,
										  ( applicationFrame.size.height - progressBounds.size.height )/2,
										  progressBounds.size.width,
										  progressBounds.size.height)];
		
		// Affichage de l'animation
		[g_progressId setHidden:FALSE];
		[g_progressId startAnimating];
		
		// Forcer au moins un affichage
		waitEvent();
	}
#endif
}

void System::Event::stopWaitAnimation() {
#if (_WINDOWS)
	SetCursor(LoadCursor(0, IDC_ARROW));

#elif (_MAC)
	if ( g_progressId != 0 ) {
		[g_progressId stopAnimating];
		[g_progressId setHidden:TRUE];
	}

#endif
}

void System::File::fileDelete(const char* path) {
	// TODO
}

const char* System::File::getDocumentsDirectory() {
#if (_WINDOWS)
	static char documentsDirectory[STRING_SIZE];
	GetCurrentDirectoryA(STRING_SIZE, documentsDirectory);
	
	static ::String spath;
	::String svolume;
	::String sdir;
	::String sname;
	::String sfname;
	::String slabel;
	::String sext;
	::String doc("doc");
	
	split(documentsDirectory, 0, spath, svolume, sdir, sname, sfname, slabel, sext);

	make(spath, svolume, sdir, doc, sext);

	return spath.getBuf();

#elif (_MAC)
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	
	return (char*)[documentsDirectory UTF8String];

#endif
}

FILE* System::File::fileOpen(const char* path, const char* mode) {
#if (_WINDOWS)
	FILE* file = 0;
	if ( fopen_s(&file, path, mode) == 0 ) {
		return file;
	}
	return 0;
	
#elif (_MAC)
	return fopen(path, mode);
	
#endif
}

void System::File::fileSeek(FILE* file, int len)  {
	fseek(file, len, SEEK_CUR);
}

void System::File::fileClose(FILE* file) {
	if ( file ) {
#if (_WINDOWS)
		clearerr_s(file);

#elif (_MAC)
		clearerr(file);
		
#endif
	
		fclose(file);
	}
}

void System::File::fileCloseAll() {
#if (_WINDOWS)
	_fcloseall();
	
#elif (_MAC)
#endif
}

size_t System::File::fileWrite(FILE* file, void* pdata, int objSize, int numObj) {
	return fwrite(pdata, objSize, numObj, file);
}

size_t System::File::fileRead(FILE* file, void* pdata, int objSize, int numObj) {
	return fread(pdata, objSize, numObj, file);
}

double System::Media::getVersion() {
	static double version = 0.;

#if (_WINDOWS)
#elif (_MAC)
	if ( version == 0. ) {
		NSString* ns = [[UIDevice currentDevice] systemVersion];
		version = [ns doubleValue];
	}

#endif

	return version;
}
