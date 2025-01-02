#include "System.h"

ImplementClass(TimerView) : public View {
public:
	int m_maxTimer;

	TimerControlRef m_timerInc;
	TimerControlRef m_timerDec;
	
	GaugeControlRef m_gaugeDec;
	
	ListControlRef m_listDelay;
	
	TimeControlRef m_time;
	DateControlRef m_date;
	
	bool m_timerOnInc;
	bool m_timerOnDec;
	
	AudioClip m_ring;
	
public:
	TimerView();
	virtual ~TimerView();

public:
	virtual void createUI();
	virtual void loadResource();
	
public:
	virtual bool timer();
	
public:
	virtual bool onPlayStop(ObjectRef obj);
	virtual bool onReset   (ObjectRef obj);
	virtual bool onSetDelay(ObjectRef obj);

};
