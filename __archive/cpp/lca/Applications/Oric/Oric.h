#pragma once

typedef unsigned char Byte;

typedef long Word;

typedef unsigned long Addr;

typedef Byte* Page;

ImplementClass(Memory) {
public:
	Page* m_ptMem;

	int m_szPage;
	int m_nbPage;

	int m_szMem;

	bool m_bRedraw;

public:
	Memory();
	virtual ~Memory();

	void Init(int szPage, int nbPage);
	void Free();

	Byte* Cell(Byte iPage, Byte iByte, Byte iDec=0);
	Byte* Cell(Addr addr);

	Byte Peek(Byte iPage, Byte iByte, Byte iDec=0);
	Byte Peek(Addr addr);

	void Poke(Byte newVal, Byte iPage, Byte iByte, Byte iDec=0);
	void Poke(Byte newVal, Addr addr);  

};

ImplementClass(Emulateur) : public Memory, public Model {
public:
	Emulateur();
	virtual ~Emulateur();

public:
	Byte Bit(Byte n, int i);

	Addr MakeAddr(Byte p, Byte q);

	Byte HighAddr(Addr w);
	Byte LowAddr(Addr w);

};

typedef struct {
	bool C:1;
	bool Z:1;
	bool I:1;
	bool D:1;
	bool B:1;

	bool unused:1;

	bool V:1;
	bool N:1;
}
Indicateur;

typedef union {
	Indicateur indicateur;
	Byte val;
}
RegistreP;

ImplementClass(EmulateurOric) : public Emulateur {
public:

	Byte A;
	Byte X;
	Byte Y;

	RegistreP P;

	Byte SP;

	Addr PC;
	Addr savePC;

	typedef void (EmulateurOric::*ASMFCT)(Addr);
	typedef Addr (EmulateurOric::*ASMOPC)();

	typedef struct
	{
		const char* what; // NVZCBDI
		ASMFCT asmFct[20];
	}
	RefIndicateur;
	static RefIndicateur g_RefIndicateur[];

	typedef struct
	{
		const char* asmCommand;

		int asmId;
		int asmNbParam;

		ASMFCT asmFct;
		ASMOPC asmOpc;
	}
	AsmCommand;
	static AsmCommand g_listAsmCommand[];

	AsmCommand m_listAsmCommand[256];

public:
	EmulateurOric();
	virtual ~EmulateurOric();

	Byte CalcRegistreP(Word val, ASMFCT asmFct);

	void Push(Byte val);
	Byte Pop();

	void ADC (Addr adr);
	void AND (Addr adr);
	void ASLa(Addr adr);
	void ASL (Addr adr);
	void BCC (Addr adr);
	void BCS (Addr adr);
	void BEQ (Addr adr);
	void BNE (Addr adr);
	void BMI (Addr adr);
	void BPL (Addr adr);
	void BVC (Addr adr);
	void BVS (Addr adr);
	void BIT (Addr adr);
	void BRK (Addr adr);
	void CLC (Addr adr);
	void CLD (Addr adr);
	void CLI (Addr adr);
	void CLV (Addr adr);
	void CMP (Addr adr);
	void CPX (Addr adr);
	void CPY (Addr adr);
	void DEC (Addr adr);
	void DEX (Addr adr);
	void DEY (Addr adr);
	void EOR (Addr adr);
	void INC (Addr adr);
	void INX (Addr adr);
	void INY (Addr adr);
	void JMP (Addr adr);
	void JSR (Addr adr);
	void LDA (Addr adr);
	void LDX (Addr adr);
	void LDY (Addr adr);
	void LSR (Addr adr);
	void LSRa(Addr adr);
	void NOP (Addr adr);
	void ORA (Addr adr);
	void PHA (Addr adr);
	void PHP (Addr adr);
	void PLA (Addr adr);
	void PLP (Addr adr);
	void ROLa(Addr adr);
	void ROL (Addr adr);
	void RORa(Addr adr);
	void ROR (Addr adr);
	void RTI (Addr adr);
	void RTS (Addr adr);
	void SBC (Addr adr);
	void SEC (Addr adr);
	void SED (Addr adr);
	void SEI (Addr adr);
	void STA (Addr adr);
	void STX (Addr adr);
	void STY (Addr adr);
	void TAX (Addr adr);
	void TAY (Addr adr);
	void TSX (Addr adr);
	void TXA (Addr adr);
	void TXS (Addr adr);
	void TYA (Addr adr);

	Addr none();

	Addr direct();

	Addr absolu();

	Addr page0();

	Addr absoluX();
	Addr absoluY();

	Addr page0X();  
	Addr page0Y();

	Addr indirect();
	Addr indirectX();
	Addr indirectY();

	bool Run();

	void ToScreen();

	virtual bool idle();

};
