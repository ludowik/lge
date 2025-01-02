#include "System.h"

TestObject<String> testString("String");

template<> void TestObject<String>::test() {
	String u;
	
	// Default global len
	u.alloc(0,0);
	assert(u.getSize()==1);
	assert(u.getBuf()!=0);
	
	// Min global len
	u.alloc(1,0);
	assert(u.getSize()==1+1);
	assert(u.getBuf()!=0);
	
	// alloc to size+1
	u.alloc(100,0);
	assert(u.getSize()==100+1);
	
	// Realloc to size+1
	u.alloc(200,0);
	assert(u.getSize()==200+1);
	
	// compare
	u = "azerty";
	assert(u.equal("azerty"));
	assert(u.equal("AZERTY")==false);
	
	// init from char
	u = "The NEW Value";
	assert(u.equal("The NEW Value"));
	
	u = "The NEW Value";
	assert(u.equal("The NEW Value"));
	
	// init from char and Len
	String s1("The NEW Value", 7);
	u = s1;
	assert(u.equal("The NEW"));
	
	// set to n character
	String s2((char)'a', 7);
	u = s2;
	assert(u.equal("aaaaaaa"));
	
	// init from double
	u = 28.45;
	assert(u.equal("28.45"));
	
	String s3(28.45);
	u = s3;
	assert(u.equal("28.45"));
	
	// init from int
	u = 2845;
	assert(u.equal("2845"));
	
	String s4(2845);
	u = s4;
	assert(u.equal("2845"));
	
	// add string
	u = "Start";
	u += "End";
	assert(u.equal("StartEnd"));
		
	// Check len
	u = "123456789";
	assert(u.getLen()==9);
	
	// Check content
	u = "Non vide";
	assert(!u.isEmpty());
	
	u = "";
	assert(u.isEmpty());
	
	// get left part
	String s("azerty");
	u = s.left(2);
	assert(u.equal("az"));
	
	u = String("azerty").left(-1);
	assert(u.equal(""));
	
	u = String("azerty").left(10000);
	assert(u.equal("azerty"));
	
	// get right part
	u = String("azerty").middle(2, 2);
	assert(u.equal("er"));
	
	u = String("azerty").middle(2, 1000);
	assert(u.equal("erty"));
	
	u = String("azerty").middle(2, -1);
	assert(u.equal("erty"));
	
	u = String("azerty").middle(-1, 100);
	assert(u.equal(""));
	
	// find part
	u = "azerty";
	int i = u.find("er");
	assert(i==2);
	
	i = u.find("er", i);
	assert(i==2);
	
	i = u.find("er", i+1);
	assert(i==-1);
	
	i = u.findLast("er");
	assert(i==2);
	
	i = u.findLast("re");
	assert(i==-1);
	
	// replace
	u = "azerty";
	u.replace('r', 'z');
	i = u.findLast("ez");
	assert(i==2);
	assert(u.equal("azezty"));
	
	// upper
	u = "AzErTy";
	u.upper();
	assert(u.equal("AZERTY"));
	
	// lower
	u = "AzErTy";
	u.lower();
	assert(u.equal("azerty"));
}
