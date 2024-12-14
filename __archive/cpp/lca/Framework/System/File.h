#pragma once

#define DECLARE_IO_TYPE(_type)\
  void operator << (_type );\
  void operator >> (_type&);

ImplementClass(File) : public Object {
public:
	String m_path;
	
	String m_volume;
	String m_dir;
	String m_name;
	String m_fname;
	String m_ext;
	
	String m_label;
	
	FILE* m_file;
	
public:
	File(const char* path=0, const char* label=0);
	virtual ~File();

public:
	bool exist();
	
	FILE* open(const char* path, const char* mode);
	bool close();
	
	void del(const char* path=0);
	
	void write(const char* pFormat, ...);
	
	void write(int len, void* pdata);
	void Read (int len, void* pdata);
	
	void Seek(int len);
	
public:
	DECLARE_IO_TYPE(Object);
	
	DECLARE_IO_TYPE(bool);
	
	DECLARE_IO_TYPE(unsigned char);
	DECLARE_IO_TYPE(char);
	DECLARE_IO_TYPE(signed char);
	
	DECLARE_IO_TYPE(unsigned short);
	DECLARE_IO_TYPE(short);
	
	DECLARE_IO_TYPE(unsigned int);
	DECLARE_IO_TYPE(int);
	
	DECLARE_IO_TYPE(unsigned long);
	DECLARE_IO_TYPE(long);
	
	DECLARE_IO_TYPE(float);
	
	DECLARE_IO_TYPE(double);
	
	void operator << (String& v);
	void operator >> (String& v);
	
};

void split(const char* path, const char* label, String& spath, String& s4volume, String& sdir, String& sname, String& sfname, String& slabel, String& sext);

void make(String& spath, String& svolume, String& sdir, String& sname, String& sext);

