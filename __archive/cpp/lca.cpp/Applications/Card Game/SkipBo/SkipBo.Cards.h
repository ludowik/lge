#pragma once

ImplementClass(SkipBoCards) : public Cards {
public:
	int m_iplayer;

public:
	SkipBoCards();
	virtual ~SkipBoCards();

};

ImplementClass(SkipBoStock) : public SkipBoCards {
public:
	SkipBoStock();
	virtual ~SkipBoStock();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool automatic(bool user);

};

ImplementClass(SkipBoMain) : public SkipBoCards {
public:
	SkipBoMain();
	virtual ~SkipBoMain();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);

};

ImplementClass(SkipBoDefausse) : public SkipBoCards {
public:
	SkipBoDefausse();
	virtual ~SkipBoDefausse();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);

};

ImplementClass(SkipBoSerie) : public SkipBoCards {
public:
	SkipBoSerie();
	virtual ~SkipBoSerie();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool automatic(bool user);

};

ImplementClass(SkipBoTalon) : public SkipBoCards {
public:
	SkipBoTalon();
	virtual ~SkipBoTalon();

public:
	virtual bool canMoveTo(Cards* pile, CardRef card);
	virtual bool automatic(bool user);

};
