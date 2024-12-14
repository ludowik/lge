#include "System.h"
#include "SudokuView.h"
#include "SudokuCell.h"

ApplicationObject<SudokuView, SudokuModel> appSudoku("Sudoku", "Sudoku", "sudoku.png");

SudokuView::SudokuView() : BoardView() {
	m_annoted = false;
	m_showPossibilities = true;
}

SudokuView::~SudokuView() {
}

void SudokuView::createUI() {
	m_numbers = startPanel(); {
		add(new ButtonControl(" "))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("1"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("2"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("3"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("4"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("5"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("6"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("7"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("8"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
		add(new ButtonControl("9"))->setListener(m_model, (FunctionRef)&SudokuModel::onNumber);
	}
	endPanel();
}

void SudokuView::createToolBar() {	
	m_toolbar = (ToolBarControlRef)startPanel(0, new ToolBarControl()); {
		add(new ButtonControl("End"))->setListener(m_model, (FunctionRef)&ModelGame::onClose);
		add(new ButtonControl("New"))->setListener(m_model, (FunctionRef)&ModelGame::onNew);
		add(new ButtonControl("Gen"))->setListener(m_model, (FunctionRef)&SudokuModel::onGenerate);
		add(new ButtonControl("Reset"))->setListener(m_model, (FunctionRef)&SudokuModel::onReset);
		add(new ButtonControl("Resolve"))->setListener(m_model, (FunctionRef)&SudokuModel::onResolve);
		add(new ButtonControl("?"))->setListener(m_model, (FunctionRef)&ModelGame::onHelp);
	}
	endPanel();
}

void SudokuView::computeSize(GdiRef gdi) {
	int layout = System::Media::getOrientation() == orientationPortrait ? posRight : posNextLine;
	foreach ( ControlRef , obj , *m_numbers ) {
		obj->m_fontSize = fontVeryLarge;
		obj->m_marginEx.setwMargin((int)( 6 * System::Media::getCoefInterface() ));
		obj->m_layout = layout;
	}

	BoardView::computeSize(gdi);
}
