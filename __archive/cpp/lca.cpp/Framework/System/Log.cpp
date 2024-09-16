#include "System.h"
#include "Log.h"

LogDebug traceDebug;

LogRef Log::s_instance = &traceDebug;

Log::Log() {
}

void Log::setLogger(LogRef log) {
	if ( log ) {
		s_instance = log;
	}
	else {
		delete s_instance;
	}
}

void Log::log(const char* format, ...) {
	va_list pargList;
	va_start(pargList, format);
	
	String str;  
	str.format(format, pargList);
	
	if ( s_instance ) {
		s_instance->write(str);
	}
}

void Log::operator <<(const char* msg) {
	String s(msg);
	write(s);
}

void Log::write(String& Msg) {
	s_instance->write(Msg);
}

void LogDebug::write(String& msg) {
	System::Debug::trace(msg.getBuf());
}

void LogFile::write(String& msg) {
	/*File file;
	 
	 static bool init = false;
	 if ( !init ) {
	 file.del("Dump.txt");
	 file.open("Dump.txt", fileModeReadWrite);
	 }
	 
	 file.open("Dump.txt", fileModeReadWrite);  
	 file.write(msg);
	 file.write("\r\n");
	 
	 file.close();
	 */
}

void LogMsgBox::write(String& msg) {
	/*System::MsgBox(msg);
	 */
}
