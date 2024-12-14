#pragma once

const int defaultLen = 1024;
const int minLen = 1;

#define nullText ""

ImplementClass(String) : public Object {
protected:
	char* m_buf;
	int m_size;

public:
	String();
	String(String& str);  
	String(const char* str);
	String(const char* str, int len);
	String(char ch, int repeat=1);
	String(int val);
	String(double val);
	virtual ~String();
	
public:
	void init(int len=0, char ch=0);
	
public:
	int getLen();
	int getSize();
	
	bool isEmpty();
	
public:
	virtual const char* asString();
	
	inline char* getBuf(int len=0) {
//		alloc(len);
		return m_buf ? m_buf : (char*)"";
	}
	
	char* getChar(int len=0) {
//		alloc(len);
		return m_buf ? m_buf : (char*)"";
	}
	
	void format(const char* f, va_list args);
	void format(const char* f, ...);
	
	String left(int len);
	String middle(int i, int len=-1);
	String right(int len);
	
	int compare(const char* str);
    
    bool equal(const char* str);
	
	int find(const char* str, int index=0);
	int findLast(const char* str);
	
	void replace(char from, char to);
	void replace(const char* from, const char* to);
	
	void lower();
	void upper();
	
	char operator [] (int index);
	
	void operator = (String& str);
	void operator = (const char* str);
	void operator = (int val);
	void operator = (double val);
	
	void operator += (String& str);
	void operator += (const char* str);
	    
public:
	void alloc(int len, char ch=0);
	
	void copy(const char* str, int len=-1);
	void append(const char* str, int len=-1);

	operator char* ();
	
};

String operator + (String& s1, String& s2);
String operator + (String& s1, const char* s2);
String operator + (const char* s1, String& s2);

bool operator == (String& s1, String& s2);
bool operator == (String& s1, const char* s2);
bool operator == (const char* s1, String& s2);

bool operator != (String& s1, String& s2);
bool operator != (String& s1, const char* s2);
bool operator != (const char* s1, String& s2);

bool operator <  (String& s1, String& s2);
bool operator <  (String& s1, const char* s2);
bool operator <  (const char* s1, String& s2);

bool operator >  (String& s1, String& s2);
bool operator >  (String& s1, const char* s2);
bool operator >  (const char* s1, String& s2);

bool operator <= (String& s1, String& s2);
bool operator <= (String& s1, const char* s2);
bool operator <= (const char* s1, String& s2);

bool operator >= (String& s1, String& s2);
bool operator >= (String& s1, const char* s2);
bool operator >= (const char* s1, String& s2);
