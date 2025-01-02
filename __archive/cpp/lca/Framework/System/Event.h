#pragma once

enum {
	eNullEvent     =0,
	eTouchBegin    =0x00000001,
	eTouchMove     =0x00000002,
	eTouchEnd      =0x00000004,
	eAllTouchEvent =0x0000000F,
	eTouchSingleTap=0x00000010,
	eTouchDoubleTap=0x00000020,
	eTouchTripleTap=0x00000040,
	eAllTapEvent   =0x000000F0,
	eAcceleration  =0x00000100,
	eAnimate       =0x00001000,
	eTimer         =0x00010000,
	eIdle          =0x00100000,
	eClose         =0x01000000,
	eAllEvent      =0xFFFFFFFF
};

ImplementClass(Event) : public Object {
public:
	int m_type;
	
public:
	double x;
	double y;
	double z;
	
public:
	Event();
	Event(int type, double _x=0, double _y=0, double _z=0);
	
};

void addEvent(EventRef evt);
void addEventTimer();
void addEventIdle();

int hasEvent();
EventRef getEvent(int type);
bool getEvent(Event& event, int type);

bool manageEvents();
bool manageEvents(int type);

bool dispatchEvent(EventRef evt);
