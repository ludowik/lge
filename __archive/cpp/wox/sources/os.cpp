#include "headers.h"
#include "os.h"

enum class Os : unsigned char {
	os_win = 1,
	os_mac = 2
};

#ifdef _WIN32
const Os os = Os::os_win;
#elif __APPLE__
const Os  os = Os::os_mac;
#endif

bool is_os_win() {
	return os == Os::os_win;
}

bool is_os_mac() {
	return os == Os::os_mac;
}