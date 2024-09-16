#pragma once

ImplementClass(Directory);

ImplementClass(DirectoryIterator) : public Iterator {
private:
  Directory* m_dir;

  String m_mask;

public:
  DirectoryIterator(Directory* dir, char* mask);
  virtual ~DirectoryIterator();

  void recurse(char* path);

};
