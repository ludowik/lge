#pragma once

typedef unsigned long Color;
typedef ObjectType<Color> ColorObject;
typedef ColorObject* ColorObjectRef;

#define Hmax 360
#define Smax 240
#define Lmax 240

#define Rmax 255
#define Gmax 255
#define Bmax 255
#define Amax 255

#define Attrib(a,b) (((unsigned char)(a))<<b)

#define Rgb(r,g,b)    (Attrib(r,0)+Attrib(g,8)+Attrib(b,16)+Attrib(Amax,24))
#define Rgba(r,g,b,a) (Attrib(r,0)+Attrib(g,8)+Attrib(b,16)+Attrib(a,24))

#define rValue(rgb) (((unsigned char*)&rgb)[0])
#define gValue(rgb) (((unsigned char*)&rgb)[1])
#define bValue(rgb) (((unsigned char*)&rgb)[2])
#define aValue(rgb) (((unsigned char*)&rgb)[3])

#define rIntensity(rgb) ((double)rValue(rgb)/Rmax)
#define gIntensity(rgb) ((double)gValue(rgb)/Gmax)
#define bIntensity(rgb) ((double)bValue(rgb)/Bmax)
#define aIntensity(rgb) ((double)aValue(rgb)/Amax)

#define defaultColor Rgba(1,1,1,0)
#define nullColor    Rgba(2,2,2,0)

#define transparentColor Rgba(0,0,0,0)

extern const Color black;
extern const Color white;

extern const Color blueDark;
extern const Color blueLight;

extern const Color greenDark;
extern const Color greenLight;

extern const Color redDark;
extern const Color redLight;

extern const Color grayDark2;
extern const Color grayDark;
extern const Color gray;
extern const Color grayLight;
extern const Color grayLight2;

extern const Color red;
extern const Color green;
extern const Color blue;

extern const Color yellow;
extern const Color purple;
extern const Color orange;
extern const Color brown;

extern const Color silver;

byte grayScaleValue(Color color);

Color grayScaleColor(Color color);

Color luminosity(Color color, double fluminosity);

Color invert(Color color);

Color merge(Color color1, Color color2);

Color randomColor();

int hValue(Color color);
int sValue(Color color);
int lValue(Color color);

void rgb2hsl(Color color, int& H, int& S, int& L);

Color hsl2rgb(int H, int S, int L);

String asHexa(Color color);


