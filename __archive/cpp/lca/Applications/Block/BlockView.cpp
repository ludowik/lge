#include "System.h"
#include "BlockView.h"

ApplicationObject<BlockView, BlockModel> appBlock("Block", "Block", "blocks.png", 0, pageBoardGame);

BlockView::BlockView() : BoardView() {
	m_right2left = true;
}

BlockView::~BlockView() {
}

void BlockView::loadResource() {
	addResource("ruby.png");
	addResource("amber.png");
	addResource("topaz.png");
	addResource("saphire.png");
}
