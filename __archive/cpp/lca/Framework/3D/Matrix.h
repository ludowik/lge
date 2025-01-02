#pragma once

ImplementClass(MatrixBase) : public Object {
private:
	int m_di;
	int m_dj;
	
private:
	double** m_matrix;

public:
	MatrixBase();
	virtual ~MatrixBase();

public:	
	void alloc(int di=4, int dj=4);
	void release();

public:
	int di();
	int dj();

public:
	double set(int i, int j, double val);
	double get(int i, int j);

};

ImplementClass(Matrix) : public MatrixBase {
public:
	Matrix();
	Matrix(Matrix& matrix);
	
	Matrix(int di, int dj);
	
	Matrix(double v0, double v1, double v2);
	Matrix(double v0, double v1, double v2, double v3);
	Matrix(double v00, double v10, double v20,
		   double v01, double v11, double v21,
		   double v02, double v12, double v22);
	Matrix(double v00, double v10, double v20, double v30,
		   double v01, double v11, double v21, double v31,
		   double v02, double v12, double v22, double v32,
		   double v03, double v13, double v23, double v33);

	virtual ~Matrix();

public:
	void init(Matrix& rMatrix);
	
	void init(bool bFloat, ...);
	void init(bool bFloat, va_list& rListe);
	
	void initMatrix(double v0, double v1, double v2);
	void initMatrix(double v0, double v1, double v2, double v3);
	void initMatrix(double v00, double v10, double v20,
					double v01, double v11, double v21,
					double v02, double v12, double v22);
	void initMatrix(double v00, double v10, double v20, double v30,
					double v01, double v11, double v21, double v31,
					double v02, double v12, double v22, double v32,
					double v03, double v13, double v23, double v33);
	
	void operator  = (Matrix& rMatrix);
	void operator *= (Matrix& rMatrix);
	
public:
	bool exchangeRow(int k, int l);

	bool inverse();

	bool transpose();
	
};

Matrix operator * (Matrix& rMatrix1, Matrix& rMatrix2);
