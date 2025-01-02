#pragma once

int ftrSet(int featureNum, int newValue);
int ftrGet(int featureNum, int defaultValue=0);

#define FTR_SIPBUTTON 1
#define FTR_TASKBAR   2
#define FTR_STARTICON 3

#define FTR_RGB     10
#define FTR_SIZE    11
#define FTR_PEN     12
#define FTR_ADJUST  13
#define FTR_MODE    14

#define FTR_WIDTH   20
#define FTR_HEIGHT  21

#define FTR_MAGNIFY 30

#define FTR_LAST_FORM 40
