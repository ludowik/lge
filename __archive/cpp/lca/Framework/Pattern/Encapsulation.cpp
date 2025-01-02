#include "System.h"

template <class cl> class CHiddenData
{
private:
  cl* c;

public:
  CHiddenData();
  virtual ~CHiddenData();

};

template <class cl> CHiddenData<cl>::CHiddenData()
{
  c = new cl();
}

template <class cl> CHiddenData<cl>::~CHiddenData()
{
  if ( c )
    delete c;
}

class CData;

class CMyData : public CHiddenData<CData>
{
public:
  CMyData()
  {
  };

};

class CData
{
public:
  CData()
  {
  }

};
