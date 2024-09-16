#include "headers.h"
#include "threads.h"

Thread::Thread(void f()) : std::thread(f) {
}

Thread::~Thread() {
    join();
}
