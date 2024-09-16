#pragma once

class Thread : public std::thread {
public:
    Thread(void f());
    virtual ~Thread();
    
};
