#pragma once

#define NEWLINE "\r\n"

ImplementClass(Log) : public Singleton<Log> {
public:
	static LogRef s_instance;

public:
	Log();
	
public:
	void setLogger(LogRef Logger);
	
public:
	void log(const char* format, ...);
	void operator <<(const char* msg);
	
protected:
	virtual void write(String& msg);
	
};

ImplementClass(LogDebug) : public Log {
protected:
	virtual void write(String& msg);
	
};

ImplementClass(LogFile) : public Log {
protected:
	virtual void write(String& msg);
	
};

ImplementClass(LogMsgBox) : public Log {
protected:
	virtual void write(String& msg);
	
};
