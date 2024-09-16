#include "headers.h"
#include "array.h"
#include "chunk.h"

template <class C> C** alloc_array2D(int size_i, int size_j) {
    C** array = (C**)mem_alloc(size_i * sizeof(C*));
    
    for ( int i = 0; i < size_i; ++i ) {
		array[i] = (C*)mem_alloc(size_j * sizeof(C));
        memset(array[i], 0, size_j * sizeof(C));
	}
    
    return array;
}

template <class C> void release_array2D(C**& array, int size_i, int size_j) {
    if ( array != NULL ) {
        for ( int i = 0; i < size_i; ++i ) {
            mem_free(array[i]);
        }
        mem_free(array);
        
        array = NULL;
    }
}

template <class C> void release_array2D(C**& array, int size_i, int size_j, bool del) {
    if ( array != NULL ) {
        for ( int i = 0; i < size_i; ++i ) {
            if ( del ) {
                for ( int j = 0; j < size_j; ++j ) {
                    delete array[i][j];
                }
            }
            mem_free(array[i]);
        }
        mem_free(array);
        
        array = NULL;
    }
}

template <class C> C*** alloc_array3D(int size_i, int size_j, int size_k) {
    C*** array = (C***)mem_alloc(size_i * sizeof(C**));
    
    for ( int i = 0; i < size_i; ++i ) {
		array[i] = (C**)mem_alloc(size_j * sizeof(C*));
        
        for ( int j = 0; j < size_j; ++j ) {
			array[i][j] = (C*)mem_alloc(size_k * sizeof(C));
            memset(array[i][j], 0, size_k * sizeof(C));
		}
	}
    
    return array;
}

template <class C> void release_array3D(C***& array, int size_i, int size_j, int size_k) {
    if ( array != NULL ) {
        for ( int i = 0; i < size_i; ++i ) {
            for ( int j = 0; j < size_j; ++j ) {
                mem_free(array[i][j]);
            }
            mem_free(array[i]);
        }
        mem_free(array);
        
        array = NULL;
    }
}

template <class C> void release_array3D(C***& array, int size_i, int size_j, int size_k, bool del) {
    if ( array != NULL ) {
        for ( int i = 0; i < size_i; ++i ) {
            for ( int j = 0; j < size_j; ++j ) {
                if ( del ) {
                    for ( int k = 0; k < size_k; ++k ) {
                        delete array[i][j][k];
                    }
                }
                mem_free(array[i][j]);
            }
            mem_free(array[i]);
        }
        mem_free(array);
        
        array = NULL;
    }
}

void implement() {
    block*** blocks = alloc_array3D<block>(0, 0, 0);
    release_array3D<block>(blocks, 0, 0, 0);

    Chunk*** chunks = alloc_array2D<Chunk*>(0, 0);
    release_array2D(chunks, 0, 0, false);
}
