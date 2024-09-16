#pragma once

template <class T> class Variable {
public:
    Variable() :
    m_val(0),
    m_val_accum(0),
    m_val_count(0),
    m_val_accum_inst(0),
    m_val_count_inst(0),
    m_val_inst(0),
    m_val_min(+9999),
    m_val_max(-9999) {
    }
    
    void set(T val) {
        m_val = val;
        
        m_val_accum += val;
        m_val_count++;
        
        m_val_accum_inst += val;
        m_val_count_inst++;
        
        if ( m_val_count_inst == 10 ) {
            m_val_inst = (double)m_val_accum_inst / m_val_count_inst;
            
            m_val_accum_inst = 0;
            m_val_count_inst = 0;
        }
        
        m_val_min = min(m_val_min, val);
        m_val_max = max(m_val_max, val);
    };
    
    void operator = (T val) {
        set(val);
    };
    
    operator T () {
        return m_val;
    };
    
    T get() {
        return m_val;
    };
    
    T get_min() {
        return m_val_min;
    };
    
    T get_max() {
        return m_val_max;
    };
    
    double get_average() {
        return (double)m_val_accum / m_val_count;
    };
    
    string as_string() {
        string str = string_format("%s <= %s <= %s",
                                   ::as_string(m_val_min).c_str(),
                                   ::as_string(m_val_inst).c_str(),
                                   ::as_string(m_val_max).c_str());
        return str;
    };
    
private:
    T m_val;
    
    T m_val_accum;
    int m_val_count;
    
    T m_val_accum_inst;
    int m_val_count_inst;
    
    double m_val_inst;
    
    T m_val_min;
    T m_val_max;
    
};

typedef Variable<int> var_int;

