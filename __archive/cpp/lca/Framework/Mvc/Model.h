#pragma once

ImplementClass(View);

ImplementClass(Model) : public Object {
protected:
	int m_version;
	
public:
	View* m_view;
	
public:
	Model();
	virtual ~Model();
	
public:
	virtual void init();
	virtual void release();
	
public:
	virtual bool idle();
	
public:
	virtual bool save();
	virtual bool save(File& file);

	virtual bool load();
	virtual bool load(File& file);
	
};
