#include "System.h"
#include "File.h"

File::File(const char* path, const char* label) : Object("File") {
	m_file = 0;
	split(path, label, m_path, m_volume, m_dir, m_name, m_fname, m_label, m_ext);
}

File::~File() {
}

bool File::exist() {
	assert(0);
	return true;
}

FILE* File::open(const char* path, const char* mode) {
	split(path, 0, m_path, m_volume, m_dir, m_name, m_fname, m_label, m_ext);
	m_file = System::File::fileOpen(path, mode);
	return m_file;
}

bool File::close() {
	if ( m_file ) {
		System::File::fileClose(m_file);
		return true;
	}
	return false;
}

void File::del(const char* path) {
	if ( path ) {
		split(path, 0, m_path, m_volume, m_dir, m_name, m_fname, m_label, m_ext);
	}
	System::File::fileDelete(m_path.getBuf());
}

void File::write(const char* pformat, ...) {
	va_list pargList;
	va_start(pargList, pformat);
	
	String text;
	text.format(pformat, pargList);
	
	va_end(pargList);
	
	System::File::fileWrite(m_file, text.getBuf(), text.getLen(), 1);
}

void File::write(int len, void* pdata) {
	System::File::fileWrite(m_file, pdata, len, 1);
}

void File::Read(int len, void* pdata) {
	System::File::fileRead(m_file, pdata, len, 1);
}

void File::Seek(int len) {
	System::File::fileSeek(m_file, len);
}

void File::operator << (String& v) {
	int len = v.getLen();
	System::File::fileWrite(m_file, &len, sizeof(len), 1);
	
	if ( len > 0 ) {
		System::File::fileWrite(m_file, v.getBuf(), len*sizeof(char), 1);
	}
}

void File::operator >> (String& v) {
	int len = 0;
	System::File::fileRead(m_file, &len, sizeof(len), 1);
	
	if ( len > 0 ) {
		char* buf = v.getBuf(len);
		System::File::fileRead(m_file, buf, len*sizeof(char), 1);
		buf[len] = 0;
	}
}

void File::operator << (Object o) {
	o.save(*this);
}

void File::operator >> (Object& o) {
	o.load(*this);
}

#define IMPLEMENT_IO_TYPE(type)\
void File::operator << (type v) {\
	System::File::fileWrite(m_file, &v, sizeof(type), 1);\
}\
void File::operator >> (type& v) {\
	System::File::fileRead(m_file, &v, sizeof(type), 1);\
}

IMPLEMENT_IO_TYPE(bool);

IMPLEMENT_IO_TYPE(unsigned char);
IMPLEMENT_IO_TYPE(char);
IMPLEMENT_IO_TYPE(signed char);

IMPLEMENT_IO_TYPE(unsigned short);
IMPLEMENT_IO_TYPE(short);

IMPLEMENT_IO_TYPE(unsigned int);
IMPLEMENT_IO_TYPE(int);

IMPLEMENT_IO_TYPE(unsigned long);
IMPLEMENT_IO_TYPE(long);

IMPLEMENT_IO_TYPE(float);

IMPLEMENT_IO_TYPE(double);

void split(const char* path, const char* label, String& spath, String& svolume, String& sdir, String& sname, String& sfname, String& slabel, String& sext) {
	if ( path ) {
		String stempPath(path);
		
		int iindex = stempPath.find(":");
		if ( iindex != -1 ) {
			svolume = stempPath.left(iindex);
			stempPath = stempPath.right(iindex+1);
		}
		
		iindex = stempPath.findLast("/");
		if ( iindex == -1 ) {
			iindex = stempPath.findLast("\\");
		}
		if ( iindex != -1 ) {
			sdir = stempPath.left(iindex);
			stempPath = stempPath.right(iindex+1);
		}
		
		sname = stempPath;
		
		iindex = stempPath.findLast(".");
		if ( iindex != -1 ) {
			sfname = stempPath.left(iindex);
			sext = stempPath.right(iindex+1);
			sext.lower();
		}
		
		if ( label ) {
			slabel = label;
		}
		else {
			slabel = sname;
		}
		
		make(spath, svolume, sdir, sfname, sext);
	}
}

void make(String& spath, String& svolume, String& sdir, String& sfname, String& sext) {
	if ( svolume.getLen() ) {
		spath = svolume;
		spath += ":";
	}
	else {
		spath = "";
	}
	
	spath += sdir;
	
	if ( sfname.getLen() ) {
		spath += "\\";
		spath += sfname;
	}
	if ( sext.getLen() ) {
		spath += ".";
		spath += sext;
	}
}
