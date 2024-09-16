#pragma once

class CHeroesForm : public Form
{
public:
  Board* m_pboard;

public:
	CHeroesForm();
  virtual ~CHeroesForm();

public:
  virtual void InitUI();

  virtual void OnDraw(Gdi& gdi);

};
