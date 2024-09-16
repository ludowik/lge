#include "System.h"
#include "Lca.String.h"

String::String() : Object("String") {
	init();
}

String::String(String& str) : Object("String") {
	init(str.getLen());
	copy(str.getBuf());
}

String::String(const char* str) : Object("String") {
	if ( str ) {
		init(strlen(str));
		copy(str);
	}
	else {
		init();
	}
}

String::String(const char* str, int len) : Object("String") {
	if ( str && len > 0 ) {
		len = min(len, strlen(str));
		init(len);
		copy(str, len);
	}
	else {
		init();
	}
}

String::String(char ch, int repeat) : Object("String") {
	init(repeat, ch);
}

String::String(int val) : Object("String") {
	init();
	format("%d", val);
}

String::String(double val) : Object("String") {
	init();
	format("%g", val);
}

String::~String() {
	if ( m_buf ) {
		free(m_buf);
	}
}

void String::init(int len, char ch) {
	m_buf = 0;
	m_size = 0;
	
	alloc(len, ch);
}

int String::getLen() {
	return m_buf ? strlen(m_buf) : 0;
}

int String::getSize() {
	return m_size;
}

bool String::isEmpty() {
	return m_buf && m_buf[0] ? false : true;
}

const char* String::asString() {
	return getBuf();
}

String String::left(int len) {
	if ( len > 0 ) {
		return String(m_buf, len);
	}
	
	return String("");
}

String String::middle(int index, int len) {
	if ( index < 0 ) {
		return String("");
	}
	else if ( len > 0 ) {
		return String(&m_buf[index], len);
	}
	
	return String(&m_buf[index]);
}

String String::right(int len) {
    return middle(max(0,getLen()-len));
}

int String::compare(const char* str) {
	return str ? strcmp(getBuf(), str) : -1;
}

bool String::equal(const char* str) {
	return str ? strcmp(getBuf(), str) == 0 : false;
}

int String::find(const char* str, int index) {
	char* buf = getBuf();
	char* pfind = strstr(&getBuf()[index], str);
	return (int)(pfind ? pfind-buf : -1);
}

int String::findLast(const char* str) {
	int index = find(str);
	int ilast = -1;
	
	while ( index != -1 ) {
		ilast = index;
		index = find(str, index+1);
	}
	return ilast;
}

void String::replace(char from, char to) {
	int len = getLen();
	for ( int i = 0 ; i < len ; ++i ) {
		if ( m_buf[i] == from ) {
			m_buf[i] = to;
		}
	}
}

void String::replace(const char* from, const char* to) {
	// TODO
}

void String::lower() {
	int len = getLen();
	for ( int i = 0 ; i < len ; ++i ) {
		m_buf[i] = tolower(m_buf[i]);
	}
}

void String::upper() {
	int len = getLen();
	for ( int i = 0 ; i < len ; ++i ) {
		m_buf[i] = toupper(m_buf[i]);
	}
}

String::operator char*() {
	return m_buf ? m_buf : 0;
}

char String::operator [] (int index) {
	return m_buf ? m_buf[index] : (char)0;
}

void String::operator = (String& str) {
	alloc(str.getLen());
	copy(str.m_buf);
}

void String::operator = (const char* str) {
	str = str ? str : "";
	alloc(strlen(str));
	copy(str);
}

void String::operator = (int val) {
	format("%d", val);
}

void String::operator = (double val) {
	format("%g", val);
}

void String::operator += (String& str) {
	append(str.m_buf);
}

void String::operator += (const char* str) {
	append(str);
}

String operator + (String& s1, String& s2) {
	String str;
	
	str.alloc((int)(s1.getLen() + s2.getLen()));
	
	str.copy(s1);
	str.append(s2);
	
	return str;
}

String operator + (String& s1, const char* s2) {
	String str;
	
	str.alloc((int)(s1.getLen() + strlen(s2)));
	
	str.copy(s1);
	str.append(s2);
	
	return str;
}

String operator + (const char* s1, String& s2) {
	String str;
	
	str.alloc((int)(strlen(s1) + s2.getLen()));
	
	str.copy(s1);
	str.append(s2);
	
	return str;
}

bool operator == (String& s1, String& s2) {
	return s1.compare(s2) == 0;
}

bool operator == (String& s1, const char* s2) {
	return s1.compare(s2) == 0;
}

bool operator == (const char* s1, String& s2) {
	return s2.compare(s1) == 0;
}

bool operator != (String& s1, String& s2) {
	return s1.compare(s2) != 0;
}

bool operator != (String& s1, const char* s2) {
	return s1.compare(s2) != 0;
}

bool operator != (const char* s1, String& s2) {
	return s2.compare(s1) != 0;
}

bool operator < (String& s1, String& s2) {
	return s1.compare(s2) < 0;
}

bool operator < (String& s1, const char* s2) {
	return s1.compare(s2) < 0;
}

bool operator < (const char* s1, String& s2) {
	return s2.compare(s1) > 0;
}

bool operator > (String& s1, String& s2) {
	return s1.compare(s2) > 0;
}

bool operator > (String& s1, const char* s2) {
	return s1.compare(s2) > 0;
}

bool operator > (const char* s1, String& s2) {
	return s2.compare(s1) < 0;
}

bool operator <= (String& s1, String& s2) {
	return s1.compare(s2) <= 0;
}

bool operator <= (String& s1, const char* s2) {
	return s1.compare(s2) <= 0;
}

bool operator <= (const char* s1, String& s2) {
	return s2.compare(s1) >= 0;
}

bool operator >= (String& s1, String& s2) {
	return s1.compare(s2) >= 0;
}

bool operator >= (String& s1, const char* s2) {
	return s1.compare(s2) >= 0;
}

bool operator >= (const char* s1, String& s2) {
	return s2.compare(s1) <= 0;
}

void String::alloc(int len, char ch) {
	int nalloc = max(len+1, m_size);
	
	if ( nalloc > m_size || !m_buf ) {
		char* buf = (char*)malloc(sizeof(char)*nalloc);
		assert(buf);

		for ( int i = 0 ; i < len ; ++i ) {
			buf[i] = ch;
		}
		buf[len] = (char)0;
		
		if ( m_size && m_buf ) {
			memcpy(buf, m_buf, sizeof(char)*m_size);
		}
		
		if ( m_buf ) {
			free(m_buf);
		}
		
		m_buf = buf;
		m_size = nalloc;
	}
}

void String::format(const char* f, va_list args) {
	static char stream[STRING_SIZE];
	int size = vsprintf(stream, f, args);
	alloc(size);
	
	vsprintf(m_buf, f, args);
}

void String::format(const char* f, ...) {
	va_list args;
	va_start(args, f);
	
	format(f, args);
	
	va_end(args);
}

void String::copy(const char* str, int n) {
	int nextSize = 0;
	if ( n > 0 )
		nextSize = n;
	else
		nextSize = strlen(str);

	alloc(nextSize);

	if ( n > 0 )
		strncpy(m_buf, str, n);
	else
		strcpy(m_buf, str);
}

void String::append(const char* str, int n) {
	int nextSize = strlen(m_buf);
	if ( n > 0 )
		nextSize += n;
	else
		nextSize += strlen(str);

	alloc(nextSize);

	if ( n > 0 )
		strncat(m_buf, str, n);
	else
		strcat(m_buf, str);
}
