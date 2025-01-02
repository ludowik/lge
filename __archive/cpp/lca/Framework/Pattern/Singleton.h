#pragma once

template<class cl> class CSingleton
{
private:
  static cl* singleton; 

protected:
  CSingleton();
  virtual ~CSingleton(); 

public:
  static cl& getInstance();
  static void releaseInstance(); 

};

template<class cl> CSingleton<cl>::CSingleton() {
}

template<class cl> CSingleton<cl>::~CSingleton() {
}

template<class cl> cl* CSingleton<cl>::singleton = 0;
template<class cl> cl& CSingleton<cl>::getInstance()
{
  if ( !singleton ) {
    singleton = new cl();
  }
  return *singleton;
}

template<class cl> void CSingleton<cl>::releaseInstance()
{
  if ( singleton ) {
    delete singleton;
    singleton = NULL;
  }
}
