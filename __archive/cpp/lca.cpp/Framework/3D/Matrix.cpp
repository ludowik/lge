#include "System.h"
#include "Matrix.h"

MatrixBase::MatrixBase() {
	m_matrix = 0;

	m_di = 0;
	m_dj = 0;
}

MatrixBase::~MatrixBase() {
	release();
}

void MatrixBase::alloc(int di, int dj) {
	release();

	m_di = di > 0 ? di : 1;
	m_dj = dj > 0 ? dj : 1;

	m_matrix = new double*[m_di];

	fromto(int, i, 0, m_di) {
		m_matrix[i] = new double[m_dj];

		fromto(int, j, 0, m_dj) {
			m_matrix[i][j] = 0.;
		}
	}
}

void MatrixBase::release() {
	if ( m_matrix ) {
		fromto(int, i, 0, m_di) {
			delete[] m_matrix[i];
		}
		delete[] m_matrix;
		m_matrix = 0;

		m_di = 0;
		m_dj = 0;
	}
}

int MatrixBase::di() {
	return m_di;
}

int MatrixBase::dj() {
	return m_dj;
}

double MatrixBase::set(int i, int j, double val) {
	if ( i >= 0 && i < m_di  && j >= 0 && j < m_dj ) {
		double oldval = m_matrix[i][j];
		m_matrix[i][j] = val;
		return oldval;
	}
	else {
		assert(0);
	}

	return 0.;
}

double MatrixBase::get(int i, int j) {
	if ( i >= 0 && i < m_di && j >= 0 && j < m_dj ) {
		return m_matrix[i][j];
	}
	else {
		assert(0);
	}

	return 0.;
}

Matrix::Matrix() {
}

Matrix::Matrix(Matrix& matrix) {
	*this = matrix;
}

Matrix::Matrix(int di, int dj) {
	alloc(di, dj);
}

Matrix::Matrix(double v0, double v1, double v2, double v3) {
	alloc(4, 1);
	init(true, v0, v1, v2, v3);
}

Matrix::Matrix(double v0, double v1, double v2) {
	alloc(3, 1);
	init(true, v0, v1, v2);
}

Matrix::Matrix(double v00, double v10, double v20,
	double v01, double v11, double v21,
	double v02, double v12, double v22) {
		alloc(3, 3);
		init(true,
			v00, v10, v20,
			v01, v11, v21,
			v02, v12, v22);
}

Matrix::Matrix(double v00, double v10, double v20, double v30,
	double v01, double v11, double v21, double v31,
	double v02, double v12, double v22, double v32,
	double v03, double v13, double v23, double v33) {
		alloc(4, 4);
		init(true,
			v00, v10, v20, v30,
			v01, v11, v21, v31,
			v02, v12, v22, v32,
			v03, v13, v23, v33);
}

Matrix::~Matrix() {
}

void Matrix::init(Matrix& rMatrix) {
	if ( di() != rMatrix.di() || dj() != rMatrix.dj() ) {
		alloc(rMatrix.di(), rMatrix.dj());
	}
	
	fromto(int, i, 0, di()) {
		fromto(int, j, 0, dj()) {
			set(i, j, rMatrix.get(i,j));
		}
	}
}

/* Lecture de di par dj
Si bFloat==true alors double
sinon                 int
*/
void Matrix::init(bool bFloat, ...) {
	va_list rListe;
	va_start(rListe, bFloat);

	init(bFloat, rListe);

	va_end(rListe);
}

void Matrix::init(bool bFloat, va_list& rListe) {
	double val = 0.;
	fromto(int, j, 0, dj()) {
		fromto(int, i, 0, di()) {
			if ( bFloat )
				val = (double)va_arg(rListe, double);
			else
				val = (double)va_arg(rListe, int);
			set(i, j, val);
		}
	}
}

Matrix operator * (Matrix& rMatrix1, Matrix& rMatrix2) {
	Matrix result;

	if ( rMatrix1.dj() != rMatrix2.di() ) {
		assert(0);
		return result;
	}

	result.alloc(rMatrix1.di(), rMatrix2.dj());

	double val = 0.;

	for ( int ri = 0 ; ri < result.di() ; ++ri ) {
		for ( int rj = 0 ; rj < result.dj() ; ++rj ) {
			val = 0.;
			for ( int i = 0 ; i < rMatrix1.dj() ; ++i ) { 
				val += rMatrix1.get(ri, i) * rMatrix2.get(i, rj);
			}
			result.set(ri, rj, val);
		}
	}

	return result;
}

void Matrix::operator *= (Matrix& rMatrix2) {
	Matrix rMatrix1(*this);
	Matrix result;
	
	if ( rMatrix1.dj() != rMatrix2.di() ) {
		assert(0);
	}
	
	result.alloc(rMatrix1.di(), rMatrix2.dj());
	
	double val = 0.;
	
	for ( int ri = 0 ; ri < result.di() ; ++ri ) {
		for ( int rj = 0 ; rj < result.dj() ; ++rj ) {
			val = 0.;
			for ( int i = 0 ; i < rMatrix1.dj() ; ++i ) { 
				val += rMatrix1.get(ri, i) * rMatrix2.get(i, rj);
			}
			result.set(ri, rj, val);
		}
	}
	
	init(result);
}

void Matrix::operator = (Matrix& rMatrix) {
	init(rMatrix);
}

bool Matrix::transpose() {
	Matrix tempo;
	tempo = *this;

	alloc(dj(), di());

	fromto(int, i, 0, dj()) {
		fromto(int, j, 0, di()) {
			set(j, i, tempo.get(i,j));
		}
	}

	return true;
}

/* La fonction ci-dessous permute deux lignes d'une matrice donnee.
¿ noter que dans une matrice ‡ m lignes et n colonnes, les numeros de lignes ‡ permuter se notent k et l o˘ k et l sont strictement positifs
et inferieurs ou egaux ‡ m.
*/
bool Matrix::exchangeRow(int k, int l) {
	if ( k <= 0 || l <= 0 || k > di() || l > di() || k == l ) {
		return false;
	}

	double tmp = 0;

	for ( int j = 0 ; j < dj() ; ++j ) {
		tmp = get(k-1, j);

		set(k-1, j, get(l-1, j));
		set(l-1, j, tmp);
	}

	return true;
}

/* Le code ci-dessous implemente la methode du pivot de Gauss-Jordan pour inverser une matrice carree inversible.
Le type de retour de la fonction etant booleen, si la matrice n'est pas inversible, elle retourne ´ false ª,
autrement elle retourne ´ true ª. Cette fonction utilise une fonction de permutation des lignes (conformement ‡ la methode du pivot) en fin de code.
Cette fonction de permutation est implementee ci-dessous egalement.
*/
bool Matrix::inverse() {
	if ( di() != dj() ) {
		Log::getInstance().log("Matrice non carree");
		return false;
	}

	if ( di() == 1 ) {
		set(0, 0, 1. / get(0, 0));
		return true;
	}

	int m = di();
	int n = di();

	// Pour stocker les lignes pour lesquels un pivot a dej‡ ete trouve
	bool* I = new bool[di()];
	fromto(int,i,0,di()) {
		I[i] = false;
	}

	// Pour stocker les colonnes pour lesquels un pivot a dej‡ ete trouve
	bool* J = new bool[dj()];
	fromto(int,j,0,dj()) {
		J[j] = false;
	}

	// Pour calculer l'inverse de la matrice initiale
	Matrix A;

	Matrix B;
	B.alloc(m,n);

	// Copie de M dans A et Mise en forme de B : B=I
	A = *this;
	for ( int i = 0 ; i < n ; ++i ) {
		for ( int j = 0 ; j < n ; ++j ) {
			if ( i == j ) {
				B.set(i, j, 1);
			}
			else {
				B.set(i, j, 0);
			}
		}
	}

	// ParamËtres permettant l'arrÍt premature des boucles ci-dessous si calcul impossible	
	bool bk = true;
	bool bl = true;

	// ParamËtres de contrÙle pour la recherche de pivot
	int cnt_row = 0;
	int cnt_col = 0;

	// ParamËtre de stockage de coefficients
	double a = 0.;
	double tmp = 0.;

	for ( int k = 0 ; k < n && bk ; ++k ) {
		if ( !I[k] ) {
			I[k] = true;

			cnt_row++;
			bl = true;
			for ( int l = 0 ; l < n && bl ; ++l ) {
				if ( !J[l] ) {
					a = A.get(k, l);
					if ( a != 0 ) {
						J[l] = true;
						cnt_col++;			    
						bl = false; //permet de sortir de la boucle car le pivot a ete trouve
						for ( int p = 0 ; p < n ; ++p ) {
							if ( p != k ) {
								tmp = A.get(p, l);
								for ( int q = 0 ; q < n ; ++q ) {
									A.set(p, q, A.get(p, q) - A.get(k, q) * ( tmp / a ));
									B.set(p, q, B.get(p, q) - B.get(k, q) * ( tmp / a ));
								}
							}	
						}
					}			
				}
			}
			if ( cnt_row != cnt_col ) {
				// Matrix is singular
				// Pas de pivot possible, donc pas d'inverse possible! On sort de la boucle
				bk = false;
				k = n; 
			}	       
		}
	}

	delete[] I;
	delete[] J;

	if ( !bk ) {
		// Le pivot n'a pas pu Ítre trouve precedemment, ce qui a donne bk = false
		Log::getInstance().log("Matrix is singular");
		for ( int i = 0 ; i < n ; ++i ) {
			for ( int j = 0 ; j < n ; ++j ) {
				B.set(j, i, get(j, i));
			}
		}
		return false;
	}
	else {
		// Reorganisation des colonnes de sorte que A=I et B=Inv(M). Methode de Gauss-Jordan
		for ( int l = 0 ; l < n ; ++l ) {
			for ( int k = 0 ; k < n ; ++k ) {
				a = A.get(k, l);
				if ( a != 0 ) {
					A.set(k, l, 1);
					for ( int p = 0 ; p < n ; ++p ) {
						B.set(k, p, B.get(k, p) / a);
					}
					if ( k != l ) {
						A.exchangeRow(k+1, l+1);
						B.exchangeRow(k+1, l+1);
					}
					k = n; // Pour sortir de la boucle car le coefficient non nul a ete trouve
				}
			}
		}

		*this = B;

		return true;	
	}
}

void Matrix::initMatrix(double v0, double v1, double v2, double v3) {
	alloc(4, 1);
	init(true, v0, v1, v2, v3);
}

void Matrix::initMatrix(double v0, double v1, double v2) {
	alloc(3, 1);
	init(true, v0, v1, v2);
}

void Matrix::initMatrix(double v00, double v10, double v20,
						double v01, double v11, double v21,
						double v02, double v12, double v22) {
	alloc(3, 3);
	init(true,
		 v00, v10, v20,
		 v01, v11, v21,
		 v02, v12, v22);
}

void Matrix::initMatrix(double v00, double v10, double v20, double v30,
						double v01, double v11, double v21, double v31,
						double v02, double v12, double v22, double v32,
						double v03, double v13, double v23, double v33) {
	alloc(4, 4);
	init(true,
		 v00, v10, v20, v30,
		 v01, v11, v21, v31,
		 v02, v12, v22, v32,
		 v03, v13, v23, v33);
}
