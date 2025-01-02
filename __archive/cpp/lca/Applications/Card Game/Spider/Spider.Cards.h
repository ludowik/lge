#pragma once

ImplementClass(SpiderTas) : public Cards {
public:
  virtual bool canMoveTo(Cards* pile, CardRef card);
	
  virtual bool canMoveTo(CardRef card1, CardRef card2);
  virtual bool canFollow(CardRef card1, CardRef card2);

};
