#pragma once

template<typename type> class TableIterator {
protected:
	type* m_table;
	int m_n;
	int m_i;
	
public:
	TableIterator(type* table, int n);
	
	virtual void begin();
	virtual void end  ();
	
	virtual bool hasNext    ();
	virtual bool hasPrevious();
	
	virtual type next    ();
	virtual type previous();
	
	virtual void remove();
	
};

template<typename type> TableIterator<type>::TableIterator(type* table, int n)
{
	m_table = table;
	m_n = n;
	m_i = 0;
}

template<typename type> void TableIterator<type>::begin()
{
	m_i = 0;
}

template<typename type> void TableIterator<type>::end()
{
	m_i = m_n-1;
}

template<typename type> bool TableIterator<type>::hasNext()
{
	return m_i < m_n ? true : false;
}

template<typename type> bool TableIterator<type>::hasPrevious()
{
	return m_i >= 0 ? true : false;
}

template<typename type> type TableIterator<type>::next()
{
	return m_table[m_i++];
}

template<typename type> type TableIterator<type>::previous()
{
	return m_table[m_i--];
}

template<typename type> void TableIterator<type>::remove()
{
	assert(0);
}
