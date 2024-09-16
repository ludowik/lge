#pragma once

template <class C> C** alloc_array2D(int size_i, int size_j);
template <class C> void release_array2D(C**& array, int size_i, int size_j);
template <class C> void release_array2D(C**& array, int size_i, int size_j, bool del);

template <class C> C*** alloc_array3D(int size_i, int size_j, int size_k);
template <class C> void release_array3D(C***& array, int size_i, int size_j, int size_k);
template <class C> void release_array3D(C***& array, int size_i, int size_j, int size_k, bool del);
