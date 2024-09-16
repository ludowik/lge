#define TRACK_MEMORY_IMPLEMENTATION

#include "headers.h"
#include "memory.h"

#define UNKNOWN_FILE "unknown file"
#define UNKNOWN_LINE -1

struct memory_block {
    bool malloc_or_new;
    size_t size;
    const char* file;
    int line;
};

typedef std::map<void*, memory_block> map_memory;

typedef std::pair<void*, memory_block> pair_memory;

map_memory gal;
map_memory& g_alloc_list = gal;

size_t g_alloc_size = 0;

void mem_init() {
    g_alloc_list = gal;
    g_alloc_list.clear();
    
    g_alloc_size = 0;
}

size_t mem_alloc_size() {
    return g_alloc_size;
}

void mem_info() {
    cout << "#ptr = " << g_alloc_list.size() << " - size = " << mem_alloc_size() << endl;
    
	if ( g_alloc_list.size() > 0 ) {
        for ( pair_memory o : g_alloc_list) {
			cout << "pair = " << o.second.size << endl;
			cout << "file = " << o.second.file << endl;
			cout << "line = " << o.second.line << endl;
			cout << "malloc = " << o.second.malloc_or_new << endl;
			break;
		}
	}
}

#ifdef TRACK_MEMORY

void* mem_alloc_dbg(size_t size, void* old, const char* file, int line) {
    if ( size > 0 ) {
        void* ptr;
        if ( old == NULL ) {
            ptr = malloc(size);
        } else {
            mem_delete(old);
            ptr = realloc(old, size);
        }
        mem_new(true, ptr, size, file, line);
        return ptr;
    }
    return NULL;
}

void mem_free_dbg(void* ptr) {
    if ( ptr != NULL ) {
        mem_delete(ptr);
        free(ptr);
    }
}

void* mem_new(bool malloc_or_new, void* ptr, size_t size, const char* file, int line) {
    static bool in_new = false;
    
    if ( !in_new ) {
        in_new = true;
        
        // did malloc succeed?
        if ( ptr == NULL ) {
            // ANSI/ISO compliant behavior
            throw std::bad_alloc();
        }
        
        memory_block mb = {malloc_or_new, size, file, line};
        
        g_alloc_list[ptr] = mb;
        g_alloc_size += size;
        
        in_new = false;
    }
    
    return ptr;
}

void* mem_delete(void* ptr) {
    static bool in_delete = false;
    
    if ( !in_delete ) {
        in_delete = true;
        
        memory_block mb = g_alloc_list[ptr];
        g_alloc_size -= mb.size;

        g_alloc_list.erase(ptr);
        
        in_delete = false;
    }
    return ptr;
}

#ifdef _WIN32
void* operator new (size_t size) {
#elif __APPLE__
void* operator new (size_t size) throw(std::bad_alloc) {
#endif
    return malloc(size);
}

#ifdef _WIN32
void* operator new (size_t size, const char* file, int line) {
#elif __APPLE__
void* operator new (size_t size, const char* file, int line) { // throw(std::bad_alloc) {
#endif
    if ( size > 0 ) {
        void* ptr = ::operator new (size);
        mem_new(false, ptr, size, file, line);
        return ptr;
    }
    
    return NULL;
}

#ifdef _WIN32
void* operator new[] (size_t size) {
#elif __APPLE__
void* operator new[] (size_t size) throw(std::bad_alloc) {
#endif
    return malloc(size);
}

#ifdef _WIN32
void* operator new[] (size_t size, const char* file, int line) {
#elif __APPLE__
void* operator new[] (size_t size, const char* file, int line) throw(std::bad_alloc) {
#endif
    if ( size > 0 ) {
        void* ptr = ::operator new[] (size);
        mem_new(false, ptr, size, file, line);        
        return ptr;
    }
    
    return NULL;
}

void operator delete (void* ptr) throw() {
    mem_delete(ptr);
    free(ptr);
}

void operator delete (void* ptr, const char* file, int line) throw() {
    if ( ptr != NULL ) {
        ::operator delete (ptr);
    }
}

void operator delete[] (void* ptr) throw() {
    mem_delete(ptr);
    free(ptr);
}

void operator delete[] (void* ptr, const char* file, int line) throw() {
    if ( ptr != NULL ) {
        ::operator delete[] (ptr);
    }
}

#endif
