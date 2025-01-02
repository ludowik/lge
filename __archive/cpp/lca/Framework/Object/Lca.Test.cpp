#include "System.h"
#include "Lca.Test.h"

Test::Test() : Singleton<Test>(false) {
	m_delete = false;
}

Test::~Test() {
}

void Test::test() {
	Log::getInstance().log("=================================================================================");
	Log::getInstance().log(NEWLINE);

	Iterator i = getIterator();
	while ( i.hasNext() ) {
		TestObject<ObjectRef>* test = (TestObject<ObjectRef>*)i.next();
		test->test();
		
		Log::getInstance().log("Test => %s", test->m_name);
		Log::getInstance().log(NEWLINE);
	}
}
