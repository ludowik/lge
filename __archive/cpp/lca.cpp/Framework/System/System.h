#pragma once

#if defined(_WIN32) || defined(_WIN64)
	#define _WINDOWS 1

	#ifdef _DEBUG
	   #define DEBUG_CLIENTBLOCK new(_CLIENT_BLOCK, __FILE__, __LINE__)
	#else
	   #define DEBUG_CLIENTBLOCK
	#endif

	#define _CRT_SECURE_NO_WARNINGS
	#define _CRTDBG_MAP_ALLOC 1
	#include <stdlib.h>
	#include <crtdbg.h>

	#include <Windows.h>
	#include <winuser.h>
	#include <GdiPlus.h>

	#ifdef _DEBUG
		#define new DEBUG_CLIENTBLOCK
	#endif

	#define TARGET_IPHONE_SIMULATOR 1

	#pragma warning(disable : 4244) 
#endif

#if !defined(_WINDOWS)
	#define _MAC 1
	#include <stdlib.h>
#endif

#include <limits.h>
#include <stdio.h>
#include <stdarg.h>
#include <time.h>
#include <math.h>
#include <ctype.h>

#if defined(_WINDOWS)
	#define sqrt(v) sqrt((long double)(v))
	#define pow(a,b) pow((long double)(a),(b))
	#define strlen(s) ((int)strlen(s))
#endif

#define STRING_SIZE  2048
#define STRING_COUNT 64

extern const char* defaultFontName;
extern int defaultFontSize;

#define label(domain, id) System::String::load(domain, id)

#define fromto(type,i,start,end) for( type i = (start) ; i < (end) ; ++i )

typedef long LayoutType;
typedef unsigned char byte;
typedef signed char sint;
typedef void* Res;
typedef const char Char;

#define _t(s) s

namespace System {
	namespace Time {
		typedef struct {
			int second;
			int minute;
			int hour;
			
			int day;
			int month;
			int year;
		}
		Time;
	}
};

extern const char* classGdiOpenGL;
extern const char* classGdiWindows;

#undef sign
#define sign(val) ((val)>0?1:(val)<0?-1:0)

#undef abs
#define abs(val) ((val)>0?(val):-(val))

#undef min
#define min(a, b) ((a)<(b)?(a):(b))

#undef max
#define max(a, b) ((a)>(b)?(a):(b))

#define DeclareClass(className)   typedef class className* className ## Ref ;

#define ImplementClass(className) typedef class className* className ## Ref ; class className

#include "Lca.Singleton.h"
#include "Lca.Object.h"
#include "Lca.String.h"

#include "Assert.h"

#include "LcaDate.h"
#include "LcaTime.h"

#include "Log.h"

#include "Collection.h"
#include "Iterator.h"

#include "List.h"
#include "ListItem.h"
#include "ListIterator.h"

#include "Array.h"
#include "ArrayIterator.h"

#include "Stack.h"

#include "TableIterator.h"

#include "Color.h"
#include "Font.h"
#include "Gdi.h"
#include "Gdi.Windows.h"

#include "Point.h"
#include "Rect.h"
#include "Size.h"
#include "Line.h"
#include "Bitmap.h"

#include "BitmapList.h"

#include "Action.h"
#include "Actions.h"

#include "Event.h"

#include "AudioClip.h"

#include "Alert.h"
#include "BatteryControl.h"
#include "ButtonControl.h"
#include "BitmapButtonControl.h"
#include "BitmapControl.h"
#include "CalendarControl.h"
#include "CheckBoxControl.h"
#include "Control.h"
#include "ColorControl.h"
#include "DateControl.h"
#include "EditControl.h"
#include "FloatControl.h"
#include "GaugeControl.h"
#include "GraphControl.h"
#include "IntegerControl.h"
#include "Layout.h"
#include "ListControl.h"
#include "Message.h"
#include "Menu.h"
#include "RadioButtonControl.h"
#include "RichTextControl.h"
#include "StaticControl.h"
#include "StatusBarControl.h"
#include "TabsControl.h"
#include "TimeControl.h"
#include "ToolBarControl.h"
#include "VolumeControl.h"
#include "Wait.h"

#include "Model.h"
#include "View.h"

#include "File.h"
#include "Directory.h"
#include "DirectoryIterator.h"
#include "Feature.h"

#include "Card.h"
#include "Cards.h"

#include "Board.h"
#include "Cell.h"

#include "Board.Model.h"
#include "Board.View.h"

#include "TransformImage.h"

#include "Application.h"

#include "Maths.h"
#include "Stat.h"

#include "Lca.Test.h"

#undef assert
#define assertA(expression, sExpression, sFile, line) System::Debug::assertion(expression?true:false, (char*)(sExpression), (char*)(sFile), line)
#define assert(expression) assertA(expression, #expression, __FILE__, __LINE__)

typedef long long SoundID;

enum {
	gdiModeGdi=0,
	gdiModeOpenGL
};

enum {
	iPhone=0,
	iPad
};

enum {
	orientationDefault=-1,
	orientationUnknown=0,
	orientationPortrait,
	orientationLandscape
};

namespace System {
	
	namespace String {
		const char* load(const char* id);
		const char* load(const char* domain, const char* id);
	};
	
	namespace Time {
		Time getTime();
		
		long ellapsedMilliseconds();
		long ellapsedTicks();
		
		void sleep(int millisecond);
		
		const char* getDayName(int d, bool longName);
		const char* getMonthName(int m, bool longName);
		
		int getDayOfWeek(int time);
		int getFirstDayOfWeek();
	};
	
	namespace Debug {
		void trace(const char* msg);
		void stop();
		void assertion(bool expression, const char* test, const char* file, int line);
	};	
	
	namespace Math {		
		void seed(int val=0);
		
		int random(int max);
		int random(int min, int max);
		
		double random(double max);
		double random(double min, double max);
	};
	
	namespace File {
		void fileDelete(const char* path);
		const char* getDocumentsDirectory();
		
		FILE* fileOpen(const char* path, const char* mode);
		
		void fileSeek(FILE* file, int len);
		void fileClose(FILE* file);

		size_t fileWrite(FILE* file, void* pdata, int objSize, int numObj);
		size_t fileRead (FILE* file, void* pdata, int objSize, int numObj);

		void fileCloseAll();
	};
	
	namespace Battery {
		double getPercent();
	};
	
	namespace Media {
		void initInterface();

		double getCoefInterface();
		double getRadius();

		int setMachineType(int machineType);
		int getMachineType();
		
		int getSoundVolume();
		int setSoundVolume(int volume);
		
		SoundID loadSound(const char* id);
		void playSound(SoundID id, int nb=1);
		void releaseSound(SoundID id);
		
		int setOrientation(int orientation=orientationDefault);
		int getOrientation();
		
		void setGdiMode(int mode);
		int getGdiMode();
				
		void setWindowsSize();
		Rect getWindowsSize();
		
		void setActiveWindow(void* wnd);
		void* getActiveWindow();
		
		void setActiveDC(void* dc);
		void* getActiveDC();
		
		void setActiveInstance(void* instance);
		void* getActiveInstance();
		
		void redraw(RectRef rect=0);
		void setNeedsRedraw(RectRef rect=0);
		
		Res loadResource(const char* type, const char* id);
		
		double getVersion();
			
	};
	
	namespace Font {
		void familyNames(ListRef list);
		void fontNames(ListRef list, const char* familyName=0);
	}
	
	namespace Event {
		void waitEvent();
		
		void startWaitAnimation(int progressId=0);
		void stopWaitAnimation();
	}
	
};
