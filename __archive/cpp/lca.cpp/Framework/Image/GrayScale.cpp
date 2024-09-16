#include "System.h"
#include "TransformImage.h"
#include "GrayScale.h"

GrayScale::GrayScale(GdiRef source) : TraitementImage(source) {
	m_txt = "N&B";
}

GrayScale::~GrayScale() {
}

Color GrayScale::traitementPixel(int x, int y) {
	byte v = grayScaleValue(getPixel(m_source, x, y));
	return Rgb(v, v, v);
}
