#include "System.h"
#include "directoryIterator.h"

DirectoryIterator::DirectoryIterator(Directory* dir, char* mask) {
  m_dir = dir;
  m_mask = mask;
  m_collect = new List();

  recurse(m_dir->m_path.getBuf());

  m_iter = m_collect->getIterator();
}

DirectoryIterator::~DirectoryIterator() {
  delete m_collect;
}

void DirectoryIterator::recurse(char* path) {
  /*
  String find = path;
  find += L"\\*.*";
  
  WIN32_FIND_DATA ffd;
  HANDLE hFind;

  hFind = FindFirstFile(find, &ffd);
  if ( INVALID_HANDLE_VALUE == hFind ) {
    return;
  } 
  
  do {
    if ( ffd.cFileName[0] != '.' && ffd.cFileName[1] != '.' && ffd.cFileName[2] != '\0'
      || ffd.cFileName[0] != '.' && ffd.cFileName[1] != '\0' ) {
      if ( ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY ) {
        String subpath = path;
        subpath += L"\\";
        subpath += ffd.cFileName;

        recurse(subpath);
      }
    }
  }
  while ( FindNextFile(hFind, &ffd) != 0 );

  FindClose(hFind);
  
  find = path;
  find += L"\\";
  find += m_mask;

  hFind = FindFirstFile(find, &ffd);
  if ( INVALID_HANDLE_VALUE == hFind ) {
    return;
  } 
  
  do {
    if ( ffd.cFileName[0] != '.' && ffd.cFileName[1] != '.' && ffd.cFileName[2] != '\0'
      || ffd.cFileName[0] != '.' && ffd.cFileName[1] != '\0' ) {
      if ( ! ( ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY ) ) {
        String file = path;
        file += L"\\";
        file += ffd.cFileName;

        m_collect->add(new String(file));
      }
    }
  }
  while ( FindNextFile(hFind, &ffd) != 0 );

  FindClose(hFind);
  */
}
