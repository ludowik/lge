#pragma once

void mem_init();
void mem_info();

size_t mem_alloc_size();

#ifdef TRACK_MEMORY

#ifdef _WIN32
#define THROW_BAD_ALLOC 
#elif __APPLE__
#define THROW_BAD_ALLOC throw(std::bad_alloc)
#endif

void* mem_alloc_dbg(size_t size, void* old, const char* file, int line);
void mem_free_dbg(void* ptr);

void* mem_new(bool malloc_or_new, void* ptr, size_t size, const char* file, int line);
void* mem_delete(void* ptr);

void* operator new   (size_t size, const char* file, int line) THROW_BAD_ALLOC;
void* operator new[] (size_t size, const char* file, int line) THROW_BAD_ALLOC;

void operator delete   (void* ptr, const char* file, int line) throw();
void operator delete[] (void* ptr, const char* file, int line) throw();

void operator delete   (void* ptr) throw();
void operator delete[] (void* ptr) throw();

#ifndef TRACK_MEMORY_IMPLEMENTATION

#define DEBUG_NEW new(__FILE__, __LINE__)
#define new DEBUG_NEW

#define mem_alloc(size) mem_alloc_dbg(size, NULL, __FILE__, __LINE__)
#define mem_realloc(size, old) mem_alloc_dbg(size, old, __FILE__, __LINE__)
#define mem_free(ptr) mem_free_dbg(ptr)

#define malloc(size) Don_t_use_malloc_but_mem_alloc
#define realloc(ptr,size) Don_t_use_realloc_but_mem_alloc
#define free(ptr) Don_t_use_free_but_mem_free

#endif

#else

#define mem_alloc(size) malloc(size)
#define mem_realloc(size, old) realloc(old, size)
#define mem_free(ptr) free(ptr)

#endif
