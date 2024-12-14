#include "System.h"
#include "OricView.h"

OricView::OricView() : View() {
	m_class = "Oric";
	emul = new EmulateurOric();
}

OricView::~OricView() {
	delete emul;
}

bool OricView::onKey(char c) {
	Byte Touche = (Byte)c;

	if ( Touche >= 0x61 && Touche <= 0x7A ) {
		Touche = (Byte)( Touche - 0x20 ); // Lettres majuscules
	}

	if ( Touche == 0x0A ) {
		Touche = 0x0D; // RETURN
	}

	if ( c == 0x08 ) {
		Touche = 0x7F; // BACKSPACE
	}

	// Force la touche
	emul->Poke(Touche, 0xF4AF); // TODO : 0x02DF

	// Touche enfoncee = 0x08, sinon 0x00
	emul->Poke(0x08, 0xF51E);

	return true;
}
