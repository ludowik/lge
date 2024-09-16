#include "System.h"
#include "BejeweledView.h"
#include "BejeweledModel.h"

ApplicationObject<BejeweledView, BejeweledModel> appBejeweled("Bejeweled", "Bejeweled", "bejeweled.png", 0, pageBoardGame);

BejeweledView::BejeweledView() : BoardView() {
}

BejeweledView::~BejeweledView() {
}

void BejeweledView::loadResource() {
	m_resources.loadMultipleRes("gems.png", 15, 14, m_wcell, m_wcell);
}
