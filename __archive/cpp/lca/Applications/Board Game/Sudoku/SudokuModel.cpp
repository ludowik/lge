#include "System.h"
#include "SudokuModel.h"
#include "SudokuCell.h"
#include "SudokuGrid.h"

SudokuModel::SudokuModel(int b) : GameBoardModel(b*b, b*b, 0) {	
	m_level = 0;
	
	m_version = 2;
	
	m_b = b;
	m_n = b*b;
}

CellRef SudokuModel::newCell(int id, int c, int l) {
	return new SudokuCell(c, l, &m_board->m_values[ c + l * m_cMax ], id);
}

void SudokuModel::init() {
	BoardModel::init();
	
	m_level++;
	m_level = m_level % ( sizeof(g_sudokus) / sizeof(char*) );
	
	for ( int x = 0 ; x < m_n ; ++x ) {
		for ( int y = 0 ; y < m_n ; ++y ) {
			SudokuCell* checkcell = (SudokuCell*)get(x, y);
			checkcell->m_value = g_sudokus[m_level][x + y * m_n]-'0';
			
			if ( checkcell->m_value != 0 ) {
				checkcell->m_system = true;
			}
			else {
				checkcell->m_system = false;
			}
		}
	}
	
	CheckBoard();
}

void SudokuModel::reset(bool resetBoard) {
	for ( int x = 0 ; x < m_n ; ++x ) {
		for ( int y = 0 ; y < m_n ; ++y ) {
			SudokuCell* cell = (SudokuCell*)get(x, y);
			if ( resetBoard || !cell->m_system  ) {
				cell->m_value = 0;
				cell->m_system = false;
			}
		}
	}
	CheckBoard();
}

/* Generer une grille aleatoire */
void SudokuModel::generate() {
	generate(System::Math::random(INT_MAX));
}

/* Generer une grille (tjrs la meme) */
void SudokuModel::generate(int srand) {
	reset(true);
	
	System::Math::seed(srand);

	// Toutes les cases doivent être renseignees
	for ( int x = 0 ; x < m_n ; ++x ) {
		for ( int y = 0 ; y < m_n ; ++y ) {
			int value = System::Math::random(m_n);
			
			CheckBoard();
			
			SudokuCell* cell = (SudokuCell*)get(x, y);
			
			// On fixe la valeur de la cellule aleatoirement
			if ( cell->m_number[value] ) {
				cell->m_value = value+1;
				cell->m_system = true;
			}
			else {
				for ( value = 0 ; value < m_n ; ++value ) {
					if ( cell->m_number[value] ) {
						cell->m_value = value+1;
						cell->m_system = true;
						break;
					}
				}
			}

			// On tente de resoudre pour finaliser la grille
			// Cela permettra à terme de gerer le niveau de difficulte de la grille
			if ( resolve() ) {
				break;
			}
			else {
				reset(false);
			}
		}
	}
}

bool SudokuModel::resolve() {
	CheckBoard();
	
	while ( CandidateBoard() ) {
		CheckBoard();
	}
	
	return CheckBoard();
}

bool SudokuModel::action(CellRef cell) {
	if ( !cell ) {
		return false;
	}
		
	unselect();
	
	int value = cell->m_value;
	
	m_curCell = cell->m_id;
	cell->m_selected = true;
	
	for ( int l = 0 ; l < m_lMax ; ++l ) {
		SudokuCellRef line = (SudokuCellRef)get(cell->m_posInBoard.m_x, l);
		line->m_checked = true;
	}
	
	for ( int c = 0 ; c < m_cMax ; ++c ) {
		SudokuCellRef column = (SudokuCellRef)get(c, cell->m_posInBoard.m_y);
		column->m_checked = true;
	}
	
	int x = ((int)(cell->m_posInBoard.m_x/m_b))*m_b;
	int y = ((int)(cell->m_posInBoard.m_y/m_b))*m_b;
	
	for ( int c = 0 ; c < m_b ; ++c ) {
		for ( int l = 0 ; l < m_b ; ++l ) {
			SudokuCellRef region = (SudokuCellRef)get(x+c, y+l);
			region->m_checked = true;
		}
	}

	if ( cell->m_value != 0 ) {
		for ( int x = 0 ; x < m_n ; ++x ) {
			for ( int y = 0 ; y < m_n ; ++y ) {
				SudokuCellRef cell = (SudokuCellRef)get(x, y);
				if ( cell->m_value == value ) {
					cell->m_selectNumber = true;
				}
			}
		}
	}
	
	return true;
}

bool SudokuModel::save(File& file) {
	if ( BoardModel::save(file) ) {
		file << m_level;
		return true;
	}
	return false;
}

bool SudokuModel::load(File& file) {
	if ( BoardModel::load(file) ) {
		file >> m_level;
		CheckBoard();
		return true;
	}
	return false;
}

/* Les valeurs possibles
 */
bool SudokuModel::CheckBoard() {
	bool bok = true;
	
	for ( int x = 0 ; x < m_n ; ++x ) {
		for ( int y = 0 ; y < m_n ; ++y ) {
			bok &= CheckCell(x, y);
		}
	}
	
	return bok;
}

bool SudokuModel::CheckCell(int x, int y) {
	int i;
	int j;
	
	/* La cellule en cours de traitement
	 */
	SudokuCell* checkcell = (SudokuCell*)get(x, y);
	
	/* Fixe par le jeu ?
	 */
	if ( checkcell->m_system ) {
		for ( i = 0 ; i < m_n ; ++i ) {
			checkcell->m_number[i] = false;
		}
		checkcell->m_number[checkcell->m_value-1] = true;
		return true;
	}
	
	/* Reinitialisation de tous les candidats
	 */
	for ( i = 0 ; i < m_n ; ++i ) {
		checkcell->m_number[i] = true;
	}
	
	/* Les candidats : en ligne
	 */
	for ( i = 0 ; i < m_n ; ++i ) {
		if ( i != x ) {
			SudokuCell* cell = (SudokuCell*)get(i, y);
			if ( cell->m_value != 0 ) {
				checkcell->m_number[cell->m_value-1] = false;
			}
		}
	}
	
	/* Les candidats : en colonne
	 */
	for ( i = 0 ; i < m_n ; ++i ) {
		if ( i != y ) {
			SudokuCell* cell = (SudokuCell*)get(x, i);
			if ( cell->m_value != 0 ) {
				checkcell->m_number[cell->m_value-1] = false;
			}
		}
	}
	
	/* Les candidats : en bloc
	 */  
	int xb = ((int)(x/m_b))*m_b;
	int yb = ((int)(y/m_b))*m_b;
	
	for ( i = xb ; i < xb+m_b ; ++i ) {
		for ( j = yb ; j < yb+m_b ; ++j ) {
			if ( i != x || j != y ) {
				SudokuCell* cell = (SudokuCell*)get(i, j);
				if ( cell->m_value != 0 ) {
					checkcell->m_number[cell->m_value-1] = false;
				}
			}
		}
	}
	
	/* Est-ce la bonne solution
	 */
	if ( checkcell->m_value != 0 ) {
		if ( checkcell->m_value == checkcell->get1Candidat() ) {
			return true;
		}
	}
	
	return false;
}

/* Resolution automatique
 */
bool SudokuModel::CandidateBoard() {
	bool bok = false;
	
	for ( int x = 0 ; x < m_n ; ++x ) {
		for ( int y = 0 ; y < m_n ; ++y ) {
			bok |= CandidateCell(x, y);
		}
	}
	
	return bok;
}

bool SudokuModel::CandidateCell(int x, int y) {
	int i;
	
	/* La cellule en cours de traitement
	 */
	SudokuCell* cell = (SudokuCell*)get(x, y);
	if ( cell->m_value != 0 ) {
		return false;
	}
	
	int value = cell->get1Candidat();
	
	if ( value != 0 ) {
		cell->m_value = value;
		return true;
	}
	
	for ( i = 0 ; i < m_n ; ++i ) {
		if ( cell->m_number[i] ) {
			int x2;
			int y2;
			
			/* Ligne
			 */
			for ( x2 = 0 ; x2 < m_n ; ++x2 ) {
				if ( x != x2 ) {
					SudokuCell* cell = (SudokuCell*)get(x2, y);
					if ( cell->m_number[i] ) {
						break;
					}
				}
			}
			
			if ( x2 < m_n ) {
				break;
			}
			
			/* Colonne
			 */
			for ( y2 = 0 ; y2 < m_n ; ++y2 ) {
				if ( y != y2 ) {
					SudokuCell* cell = (SudokuCell*)get(x, y2);
					if ( cell->m_number[i] ) {
						break;
					}
				}
			}
			
			if ( y2 < m_n ) {
				break;
			}
			
			/* Bloc
			 */
			int xb = ((int)(x/m_b))*m_b;
			int yb = ((int)(y/m_b))*m_b;
			
			for ( x2 = xb ; x2 < xb+m_b ; ++x2 ) {
				for ( y2 = yb ; y2 < yb+m_b ; ++y2 ) {
					if (   x2 != x
						|| y2 != y ) {
						SudokuCell* cell = (SudokuCell*)get(x2, y2);
						if ( cell->m_number[i] ) {
							break;
						}
					}
				}
				
				if ( y2 < yb+m_b ) {
					break;
				}
			}
			
			if ( x2 < xb+m_b ) {
				break;
			}
			
			cell->m_value = i+1;
			
			return true;
		}
	}
	
	return false;
}

bool SudokuModel::onGenerate(ObjectRef obj) {
	generate();
	return true;
}

bool SudokuModel::onReset(ObjectRef obj) {
	reset(false);
	return true;
}

bool SudokuModel::onResolve(ObjectRef obj) {
	resolve();	
	return true;
}

bool SudokuModel::onNumber(ObjectRef obj) {
	if ( m_curCell != -1 ) {
		SudokuCellRef cell = (SudokuCellRef)get(m_curCell);
		if ( cell ) {
			if ( !cell->m_system ) {
				ControlRef ctrl = (ControlRef)obj;
				int value = ctrl->m_text.getBuf()[0]-'0';
				
				if ( value > 0 && value < 10 ) {
					cell->m_value = value;
				}
				else {
					cell->m_value = 0;
				}
				
				action(cell);
				
				CheckBoard();
			}
		}
	}
	return true;
}