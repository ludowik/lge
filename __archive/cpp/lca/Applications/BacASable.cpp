#include "System.h"

int chercheNbEntiers(int max, bool* &nbentier) {
	assert(!nbentier);
	nbentier = (bool*)calloc(max+1, sizeof(bool));

	nbentier[0] = false;
	fromto(int, i, 1, max+1) {
		nbentier[i] = true;
	}

	int racine = (int)(sqrt(max)+1.);
	for ( int j = 2 ; j < racine ; ++j ) {
		if ( nbentier[j] ) {
			int nj = (int)(max/j+1.);
			for (int k = nj-1 ; k >= 2 ; --k ) {
				if ( nbentier[k] ) {
					int produit = j*k;
					if ( produit <= max ) {
						nbentier[produit] = false;
					}
				}
			}
		}
	}

	int nb = 0;
	fromto(int, i, 1, max+1) {
		if ( nbentier[i] ) {
			nb++;
		}
	}

	return nb;
}

int chercheNbEntiersRef(int max, bool* &nbentier) {
	assert(!nbentier);
	nbentier = (bool*)calloc(max+1, sizeof(bool));

	nbentier[0] = false;
	fromto(int, i, 1, max+1) {
		nbentier[i] = true;
	}

	for ( int j = 2 ; j < max ; ++j ) {
		for (int k = 2 ; k < max ; ++k ) {
			int produit = j*k;
			if ( produit <= max ) {
				nbentier[produit] = false;
			}
		}
	}

	int nb = 0;
	fromto(int, i, 1, max+1) {
		if ( nbentier[i] ) {
			nb++;
		}
	}

	return nb;
}

void basASable() {
	bool* nbentier1 = 0;
	bool* nbentier2 = 0;

	int nb = 10000;
	
	int m1 = chercheNbEntiers(nb, nbentier1);
	int m2 = chercheNbEntiersRef(nb, nbentier2);

	assert(m1==m2);

	fromto(int, i, 0, nb+1) {
		assert(nbentier1[i]==nbentier2[i]);
	}

	free(nbentier1);
	free(nbentier2);
}
