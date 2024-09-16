#include "System.h"
#include "Oric.h"

#define RES_BASE_ID "Rom"
#define resRom "resRom"

#define Indic(val) ( (val) ? true : false )

#define posN 0
#define posV 1
#define posZ 2
#define posC 3
#define posB 4
#define posD 5
#define posI 6

void MissingWhat()
{
	msgAlertIf(1, "Missing What");
}

void ErreurDePage()
{
	msgAlertIf(1, "Erreur de page !");
}

void ErreurDeDecalage()
{
	msgAlertIf(1, "Erreur de decalage !");
}

void ErreurAdresse()
{
	msgAlertIf(1, "Erreur d'adresse !");
}

Memory::Memory()
{
	m_ptMem = NULL;
	
	m_szPage = 0;
	m_nbPage = 0;
	
	m_szMem = 0;
	
	m_bRedraw = false;
}

Memory::~Memory()
{
	Free();
}

void Memory::Init(int szPage, int nbPage)
{
	m_szPage = szPage;
	m_nbPage = nbPage;
	
	m_szMem = m_szPage * m_nbPage;
	
	m_ptMem = new Page[m_nbPage];
	msgAlertIf(!m_ptMem, "Erreur d'allocation de la memoire !");
	
	for ( int i = 0 ; i < m_nbPage ; ++i )
	{
		m_ptMem[i] = new Byte[m_szPage];
		memset(m_ptMem[i], 0, m_szPage);
		
		msgAlertIf(!m_ptMem[i], "Erreur d'allocation d'une page !");
	}
}

void Memory::Free()
{
	for ( int i = 0 ; i < m_nbPage ; ++i )
	{
		delete[] m_ptMem[i];
	}
	delete[] m_ptMem;
}

Byte* Memory::Cell(Byte iPage, Byte iByte, Byte iDec)
{
	return &m_ptMem[iPage+iDec/256][iByte+iDec%256];
}

Byte* Memory::Cell(Addr addr)
{
	Byte iPage = (Byte)( addr / m_szPage );
	Byte iByte = (Byte)( addr % m_szPage );
	
	return Cell( iPage , iByte );
}

Byte Memory::Peek(Byte iPage, Byte iByte, Byte iDec)
{
	return *Cell(iPage, iByte, iDec);
}

Byte Memory::Peek(Addr addr)
{
	return *Cell(addr);
}

void Memory::Poke(Byte newVal, Byte iPage, Byte iByte, Byte iDec)
{
	if ( iPage == 0xBB ) // TODO : être plus precis
	{
		m_bRedraw = true;
	}
	
	*Cell(iPage, iByte, iDec) = newVal;
}

void Memory::Poke(Byte newVal, Addr addr)
{
	*Cell(addr) = newVal;
}

Emulateur::Emulateur()
{
}

Emulateur::~Emulateur()
{
}

Byte Emulateur::Bit(Byte n, int i)
{
	return (Byte)( n & ( 1 << i ) ? 1 : 0 );
}

Addr Emulateur::MakeAddr(Byte p, Byte q)
{
	return (Addr)( ( p << 8 ) + q );
}

Byte Emulateur::HighAddr(Addr w)
{
	return (Byte)( w >> 8 );
}

Byte Emulateur::LowAddr(Addr w)
{
	return (Byte)( w );
}

EmulateurOric::EmulateurOric()
{
	Init(256, 256);
	
	Res hRom = System::Media::loadResource(resRom, RES_BASE_ID);
	if ( hRom ) {
		for ( int p = 192, i = 0 ; i < 64 ; ++i, ++p ) {
			memcpy(m_ptMem[p], ((Byte*)hRom) + i * 256, 256);
		}
	}
	
	A = 0;
	X = 0;
	Y = 0;
	
	P.val = 0xFB;
	
	SP = 0xFF;
	
	/* TODO
	 PC = MakeAddr( 192, 0 );
	 */
	
	savePC = 0;
	
	/*
	 Poke(0x0E, 0xFFFC);
	 Poke(0xE7, 0xFFFD);
	 */
	
	PC = MakeAddr( Peek(0xFFFD), Peek(0xFFFC) );
	
	Poke(0xBF, 0xFA1A);	/* Diminue le test de memoire */
	
	Poke(0xEA, 0xF9BC);	/* Annule attente chgt attribut ecran */
	Poke(0xEA, 0xF9BD);
	Poke(0xEA, 0xF9BE);
	
	Poke(0xA9, 0xF4AE);	/* Pas de touche */
	Poke(0x00, 0xF4AF);	/* Code touche = 0 */
	Poke(0xEA, 0xF4B0);
	
	Poke(0xA9, 0xF51D);	/* Touche enfoncee = 0x08, sinon 0x00 */
	Poke(0x00, 0xF51E);	/* Pas de touche enfoncee */
	Poke(0xEA, 0xF51F);
	
	int i = 0;
	
	memset(m_listAsmCommand, 0, sizeof(m_listAsmCommand));
	
	while ( g_listAsmCommand[i].asmFct )
	{
		m_listAsmCommand[g_listAsmCommand[i].asmId] = g_listAsmCommand[i];
		i++;
	}
}

EmulateurOric::~EmulateurOric()
{
}

int GetRef(EmulateurOric::ASMFCT asmFct)
{
	int ref = -1;
	
	int i = 0;
	
	while ( EmulateurOric::g_RefIndicateur[i].what && ref == -1 )
	{
		int j = 0;
		while ( EmulateurOric::g_RefIndicateur[i].asmFct[j] )
		{
			if ( EmulateurOric::g_RefIndicateur[i].asmFct[j] == asmFct )
			{
				ref = i;
				break;
			}
			j++;
		}
		
		i++;
	}
	
	return ref;
}

Byte EmulateurOric::CalcRegistreP(Word val, ASMFCT asmFct)
{
	int ref = GetRef(asmFct);
	if ( ref != -1 )
	{
		/* N : Indicateur de signe des nombres avec signe.
		 * Il est communement la replique du bit 7 du nombre resultant d'une operation.
		 */
		switch ( g_RefIndicateur[ref].what[posN] )
		{
			case 'x':
			{
				if ( val & 0x80 )
					P.indicateur.N = true;
				else
					P.indicateur.N = false;
				break;
			}
			case '0':
			{
				P.indicateur.N = 0;
				break;
			}
			default: MissingWhat();
			case ' ':
				break;
		}
		
		/* V : Indicateur de depassement.
		 * Il est mis à 1 quand il y a depassement des capacites de calcul sur des nombres avec signe.
		 */
		switch ( g_RefIndicateur[ref].what[posV] )
		{
			case 'x':
			{
				P.indicateur.V = Indic( val>255 ) | Indic( val<0 ); // TODO
				break;
			}
			case '6':
			{
				P.indicateur.V = Indic( Bit((Byte)val, 6) );
				break;
			}
			default: MissingWhat();
			case ' ':
				break;
		}      
		
		/* B : Indicateur d'interruption.
		 * Il est mis à 1 lorsque l'interruption est provoquee par un break.
		 */
		switch ( g_RefIndicateur[ref].what[posB] )
		{
			case 'x':
			case '0':
			{
				P.indicateur.B = 0;
				break;
			}
			case '1':
			{
				P.indicateur.B = 1;
				break;
			}
			default: MissingWhat();
			case ' ':
				break;
		}
		
		/* D : Indicateur d'emploi du code DCB (1) ou binaire (0).
		 */
		switch ( g_RefIndicateur[ref].what[posD] )
		{
			case '0':
			{
				P.indicateur.D = 0;
				break;
			}
			case '1':
			{
				P.indicateur.D = 1;
				break;
			}
			default: MissingWhat();
			case ' ':
				break;
		}
		
		/* I : Indicateur d'interruption.
		 * Il est mis à 1 lorsqu'une interruption survient.
		 */
		switch ( g_RefIndicateur[ref].what[posI] )
		{
			case '0':
			{
				P.indicateur.I = 0;
				break;
			}
			case '1':
			{
				P.indicateur.I = 1;
				break;
			}
			default: MissingWhat();
			case ' ':
				break;
		}
		
		/* Z : Indicateur de nullite.
		 * Il est mis à 1 lorsque le resultat est 0.
		 */
		switch ( g_RefIndicateur[ref].what[posZ] )
		{
			case 'x':
			{
				P.indicateur.Z = Indic( val == 0 );
				break;
			}
			default: MissingWhat();
			case ' ':
				break;
		}
		
		/* C : Indicateur de report (addition) ou de retenue (soustraction).
		 * Il vaut 1 lorsque le resultat est module 256.
		 */
		switch ( g_RefIndicateur[ref].what[posC] )
		{
			case 'x':
			{
				P.indicateur.C = Indic( val>255 ) | Indic( val<0 ); // TODO
				break;
			}
			default: MissingWhat();
			case ' ':
				break;
		}
	}
	
	return (Byte)val;
}

void EmulateurOric::Push(Byte val)
{
	Poke(val, 1, SP);
	SP--;
}

Byte EmulateurOric::Pop()
{
	SP++;
	return Peek(1, SP);
}

void EmulateurOric::ADC(Addr adr)
{
	CalcRegistreP( (char)A + (char)Peek(adr) + P.indicateur.C , &EmulateurOric::ADC );
	A = (Byte)( A + Peek(adr) + P.indicateur.C );
}

void EmulateurOric::AND(Addr adr)
{
	A = CalcRegistreP( A & Peek(adr) , &EmulateurOric::AND );
}

void EmulateurOric::ASL(Addr adr)
{
	Poke( CalcRegistreP( Peek(adr) << 1 , &EmulateurOric::ASL ) , adr);
}

void EmulateurOric::ASLa(Addr adr)
{
	A = CalcRegistreP( A << 1 , &EmulateurOric::ASL );
}

void EmulateurOric::BCC(Addr adr)
{
	PC = (Addr)( savePC + 2 + ( P.indicateur.C == 0 ? Peek(adr) : 0 ) );
}

void EmulateurOric::BCS(Addr adr)
{
	PC = (Addr)( savePC + 2 + ( P.indicateur.C == 1 ? Peek(adr) : 0 ) );
}

void EmulateurOric::BEQ(Addr adr)
{
	PC = (Addr)( savePC + 2 + ( P.indicateur.Z == 1 ? Peek(adr) : 0 ) );
}

void EmulateurOric::BNE(Addr adr)
{
	PC = (Addr)( savePC + 2 + ( P.indicateur.Z == 0 ? Peek(adr) : 0 ) );
}

void EmulateurOric::BMI(Addr adr)
{
	PC = (Addr)( savePC + 2 + ( P.indicateur.N == 1 ? Peek(adr) : 0 ) );
}

void EmulateurOric::BPL(Addr adr)
{
	PC = (Addr)( savePC + 2 + ( P.indicateur.N == 0 ? Peek(adr) : 0 ) );
	
	if ( PC & 0x80 ) // TODO ?????
	{
		PC -= 0x100;
	}
}

void EmulateurOric::BVC(Addr adr)
{
	PC = (Addr)( savePC + 2 + ( P.indicateur.V == 0 ? Peek(adr) : 0 ) );
}

void EmulateurOric::BVS(Addr adr)
{
	PC = (Addr)( savePC + 2 + ( P.indicateur.V == 1 ? Peek(adr) : 0 ) );
}

void EmulateurOric::BIT(Addr adr)
{
	CalcRegistreP( A & Peek(adr) , &EmulateurOric::BIT );
}

void EmulateurOric::BRK(Addr adr)
{
	PC = (Addr)( savePC + 2 );
	
	Push( HighAddr(PC) );
	Push( LowAddr (PC) );
	
	Push( P.val );
	
	CalcRegistreP( 0 , &EmulateurOric::BRK );
	
	PC = MakeAddr( Peek(0xFF, 0xFF), Peek(0xFF, 0xFE) );
}

void EmulateurOric::CLC(Addr adr)
{
	P.indicateur.C = 0;
}

void EmulateurOric::CLD(Addr adr)
{
	// Met le mode binaire pour ADC et SBC
	P.indicateur.D = 0;
}

void EmulateurOric::CLI(Addr adr)
{
	P.indicateur.I = 0;
}

void EmulateurOric::CLV(Addr adr)
{
	P.indicateur.V = 0;
}

void EmulateurOric::CMP(Addr adr)
{
	CalcRegistreP( A - Peek(adr) , &EmulateurOric::CMP );
}

void EmulateurOric::CPX(Addr adr)
{
	CalcRegistreP( X - Peek(adr) , &EmulateurOric::CPX );
}

void EmulateurOric::CPY(Addr adr)
{
	CalcRegistreP( Y - Peek(adr) , &EmulateurOric::CPY );
}

void EmulateurOric::DEC(Addr adr)
{
	Poke( CalcRegistreP( Peek(adr) - 1 , &EmulateurOric::DEC ) , adr );
}

void EmulateurOric::DEX(Addr adr)
{
	X = CalcRegistreP( X - 1 , &EmulateurOric::DEC );
}

void EmulateurOric::DEY(Addr adr)
{
	Y = CalcRegistreP( Y - 1 , &EmulateurOric::DEC );
}

void EmulateurOric::EOR(Addr adr)
{
	A = CalcRegistreP( A ^ Peek(adr) , &EmulateurOric::EOR );
}

void EmulateurOric::INC(Addr adr)
{
	Poke( CalcRegistreP( Peek(adr) + 1 , &EmulateurOric::INC ) , adr );
}

void EmulateurOric::INX(Addr adr)
{
	X = CalcRegistreP( X + 1 , &EmulateurOric::INC );
}

void EmulateurOric::INY(Addr adr)
{
	Y = CalcRegistreP( Y + 1 , &EmulateurOric::INC );
}

void EmulateurOric::JMP(Addr adr)
{
	PC = adr;
}

void EmulateurOric::JSR(Addr adr)
{
	PC = (Addr)( savePC + 2 );
	
	Push( HighAddr(PC) );
	Push( LowAddr (PC) );
	
	PC = adr;
}

void EmulateurOric::LDA(Addr adr)
{
	A = CalcRegistreP( Peek(adr) , &EmulateurOric::LDA );
}

void EmulateurOric::LDX(Addr adr)
{
	X = CalcRegistreP( Peek(adr) , &EmulateurOric::LDX );
}

void EmulateurOric::LDY(Addr adr)
{
	Y = CalcRegistreP( Peek(adr) , &EmulateurOric::LDY );
}

void EmulateurOric::LSR(Addr adr)
{  
	Poke( CalcRegistreP( Peek(adr) >> 1 , &EmulateurOric::LSR ) , adr );
}

void EmulateurOric::LSRa(Addr adr)
{  
	A = CalcRegistreP( A >> 1 , &EmulateurOric::LSR );
}

void EmulateurOric::NOP(Addr adr)
{
}

void EmulateurOric::ORA(Addr adr)
{
	A = CalcRegistreP( A | Peek(adr) , &EmulateurOric::ORA );
}

void EmulateurOric::PHA(Addr adr)
{
	Push(A);
}

void EmulateurOric::PHP(Addr adr)
{
	Push(P.val);
}

void EmulateurOric::PLA(Addr adr)
{
	A = CalcRegistreP( Pop() , &EmulateurOric::PLA );
}

void EmulateurOric::PLP(Addr adr)
{
	P.val = CalcRegistreP( Pop() , &EmulateurOric::PLP );  
}

void EmulateurOric::ROL(Addr adr)
{
	bool C = P.indicateur.C;
	P.indicateur.C = Indic( Peek(adr) >> 7 );
	
	Poke( (Byte)( ( Peek(adr) << 1 ) | ( C ? 0x01 : 0x00 ) ) , adr );
}

void EmulateurOric::ROLa(Addr adr)
{
	bool C = P.indicateur.C;
	P.indicateur.C = Indic( A >> 7 );
	
	A = (Byte)( ( A << 1 ) | ( C ? 0x01 : 0x00 ) );
}

void EmulateurOric::ROR(Addr adr)
{
	bool C = P.indicateur.C;
	P.indicateur.C = Indic( Peek(adr) & 0x01 );
	
	Poke( (Byte)( ( Peek(adr) >> 1 ) | ( C ? 0x80 : 0x00 ) ) , adr );
}

void EmulateurOric::RORa(Addr adr)
{
	bool C = P.indicateur.C;
	P.indicateur.C = Indic( A & 0x01 );
	
	A = (Byte)( ( A >> 1 ) | ( C ? 0x80 : 0x00 ) );
}

void EmulateurOric::RTI(Addr adr)
{
	P.val = CalcRegistreP( Pop() , &EmulateurOric::RTI );  
	
	Byte l = Pop();
	Byte h = Pop();
	
	PC = MakeAddr( h, l );
}

void EmulateurOric::RTS(Addr adr)
{
	Byte l = Pop();
	Byte h = Pop();
	
	PC = MakeAddr( h, l );
	
	PC++;
}

void EmulateurOric::SBC(Addr adr)
{
	A = CalcRegistreP( A - Peek(adr) - !P.indicateur.C , &EmulateurOric::SBC );
}

void EmulateurOric::SEC(Addr adr)
{
	P.indicateur.C = 1;
}

void EmulateurOric::SED(Addr adr)
{
	// Met le mode decimal pour ADC et SBC
	P.indicateur.D = 1;
}

void EmulateurOric::SEI(Addr adr)
{
	// Masque les interruptions
	P.indicateur.I = 1;
}

void EmulateurOric::STA(Addr adr)
{
	Poke( A , adr );
}

void EmulateurOric::STX(Addr adr)
{
	Poke( X , adr );
}

void EmulateurOric::STY(Addr adr)
{
	Poke( Y , adr );
}

void EmulateurOric::TAX(Addr adr)
{
	X = CalcRegistreP( A, &EmulateurOric::TAX );
}

void EmulateurOric::TAY(Addr adr)
{
	Y = CalcRegistreP( A , &EmulateurOric::TAY );
}

void EmulateurOric::TSX(Addr adr)
{
	X = CalcRegistreP( SP , &EmulateurOric::TSX );
}

void EmulateurOric::TXA(Addr adr)
{
	A = CalcRegistreP( X , &EmulateurOric::TXA );
}

void EmulateurOric::TXS(Addr adr)
{
	SP = X;
}

void EmulateurOric::TYA(Addr adr)
{
	A = CalcRegistreP( Y , &EmulateurOric::TYA );
}

bool EmulateurOric::Run()
{
	/*
	 while ( 1 )
	 */
	{
		static int iCall = 0;
		
		if ( savePC==PC )
		{
			Log::getInstance().log("BOUCLE");
			Log::getInstance().log(NEWLINE);
			return false;
		}
		
		savePC = PC;
		
		Byte asmId = (Byte)Peek(PC);
		if ( m_listAsmCommand[asmId].asmFct==NULL )
		{
			Log::getInstance().log("%5.5d(%4.4X) Not found (%2.2X) ", PC, PC-(0xC000), asmId);
			Log::getInstance().log(NEWLINE);
			return false;
		}
		
		String tab(' ', iCall>=0?mulby2(iCall):0);
		tab += "%5.5d(%4.4X) %s(%2.2X) ";
		Log::getInstance().log(tab.getBuf(), PC, PC-(0xC000), m_listAsmCommand[(int)asmId].asmCommand, asmId);
		
		if ( m_listAsmCommand[asmId].asmFct == &EmulateurOric::BRK ||
			m_listAsmCommand[asmId].asmFct == &EmulateurOric::JSR )
		{
			iCall++;
		}
		else if ( m_listAsmCommand[asmId].asmFct == &EmulateurOric::RTI ||
				 m_listAsmCommand[asmId].asmFct == &EmulateurOric::RTS )
		{
			iCall--;
		}
		
		if ( iCall < 0 )
		{
			Log::getInstance().log("Retour OU ???");
			Log::getInstance().log(NEWLINE);
			return false;
		}
		
		switch ( m_listAsmCommand[asmId].asmNbParam )
		{
			case 1:
			{
				Byte p1 = Peek( (Addr)( PC + 1 ) );
				Log::getInstance().log("%3.3d(%2.2X)", p1, p1);
				break;
			}
			case 2:
			{
				Byte p1 = Peek( (Addr)( PC + 1 ) );
				Byte p2 = Peek( (Addr)( PC + 2 ) );
				Log::getInstance().log("%3.3d(%2.2X) %3.3d(%2.2X)", p1, p1, p2, p2);
				break;
			}
		}
		
		PC++;
		
		Log::getInstance().log(NEWLINE);
		
		Addr ad = (this->*m_listAsmCommand[asmId].asmOpc)();
		(this->*m_listAsmCommand[asmId].asmFct)(ad);
		
		ToScreen();
	}
	
	return true;
}

void EmulateurOric::ToScreen()
{
	GdiRef gdi = 0;
	
	ViewRef view = get_view();
	gdi = view->g_gdi;
	
	int y = 0;
	
	if ( m_bRedraw )
	{
		if ( 0 )
		{
			int p = 0;
			int c = 0;
			
			Addr base = 0;
			for ( p = 0 ; p < 256 ; ++p )
			{
				for ( c = 0 ; c < 256 ; ++c )
				{
					Byte r = (Byte)( 255 - Peek(base) );
					Byte g = r;
					Byte b = r;
					
					gdi->pixel(p, c, Rgb(r,g,b));
					
					base++;
				}
			}
			
			y = c;
		}
		else
		{
			Point sizechar(8,8);
			
			int l = 0;
			int c = 0;
			
			Addr base = MakeAddr( 0xBB, 0x80 );
			for ( l = 0 ; l < 28 ; ++l )
			{
				for ( c = 0 ; c < 40 ; ++c )
				{
					String str((char)Peek(base));
					gdi->text(
							  c * sizechar.x,
							  l * sizechar.y,
							  str.getBuf(),
							  black);
					
					base++;
				}
			}
			
			y = l * sizechar.y;
		}
	}
	
	m_bRedraw = false;
	
	y = 260;
	
	String format("SP\t= %2.2X \t PC\t= %4.4X\n");
	format += "A\t= %2.2X \t P\t= %ld%ld%ld%ld%ld%ld%ld\n";
	format += "X\t= %2.2X\n";
	format += "Y\t= %2.2X";
	
	String csText;
	csText.format(format.getBuf(),
				  SP,
				  PC,
				  A,
				  P.indicateur.C,
				  P.indicateur.Z, 
				  P.indicateur.I, 
				  P.indicateur.D, 
				  P.indicateur.B, 
				  P.indicateur.V, 
				  P.indicateur.N,
				  X,
				  Y);
	
	gdi->text(0, y, csText.getBuf(), black);
}

EmulateurOric::AsmCommand EmulateurOric::g_listAsmCommand[]=
{
	{"ADC", 0x69, 0, &EmulateurOric::ADC , &EmulateurOric::direct},
	{"ADC", 0x6D, 2, &EmulateurOric::ADC , &EmulateurOric::absolu},
	{"ADC", 0x65, 1, &EmulateurOric::ADC , &EmulateurOric::page0},
	{"ADC", 0x7D, 0, &EmulateurOric::ADC , &EmulateurOric::absoluX},
	{"ADC", 0x79, 0, &EmulateurOric::ADC , &EmulateurOric::absoluY},
	{"ADC", 0x75, 1, &EmulateurOric::ADC , &EmulateurOric::page0X},
	{"ADC", 0x61, 1, &EmulateurOric::ADC , &EmulateurOric::indirectX},
	{"ADC", 0x71, 1, &EmulateurOric::ADC , &EmulateurOric::indirectY},
	{"AND", 0x29, 1, &EmulateurOric::AND , &EmulateurOric::direct},
	{"AND", 0x2D, 0, &EmulateurOric::AND , &EmulateurOric::absolu},
	{"AND", 0x25, 1, &EmulateurOric::AND , &EmulateurOric::page0},
	{"AND", 0x3D, 0, &EmulateurOric::AND , &EmulateurOric::absoluX},
	{"AND", 0x39, 0, &EmulateurOric::AND , &EmulateurOric::absoluY},
	{"AND", 0x35, 1, &EmulateurOric::AND , &EmulateurOric::page0X},
	{"AND", 0x21, 1, &EmulateurOric::AND , &EmulateurOric::indirectX},
	{"AND", 0x31, 1, &EmulateurOric::AND , &EmulateurOric::indirectY},
	{"ASL", 0x0A, 0, &EmulateurOric::ASLa, &EmulateurOric::none},
	{"ASL", 0x0E, 2, &EmulateurOric::ASL , &EmulateurOric::absolu},
	{"ASL", 0x06, 1, &EmulateurOric::ASL , &EmulateurOric::page0},
	{"ASL", 0x1E, 2, &EmulateurOric::ASL , &EmulateurOric::absoluX},
	{"ASL", 0x16, 1, &EmulateurOric::ASL , &EmulateurOric::page0X},
	{"BCC", 0x90, 1, &EmulateurOric::BCC , &EmulateurOric::direct},
	{"BCS", 0xB0, 1, &EmulateurOric::BCS , &EmulateurOric::direct},
	{"BEQ", 0xF0, 1, &EmulateurOric::BEQ , &EmulateurOric::direct},
	{"BNE", 0xD0, 1, &EmulateurOric::BNE , &EmulateurOric::direct},
	{"BMI", 0x30, 1, &EmulateurOric::BMI , &EmulateurOric::direct},
	{"BPL", 0x10, 1, &EmulateurOric::BPL , &EmulateurOric::direct},
	{"BVC", 0x50, 1, &EmulateurOric::BVC , &EmulateurOric::direct},
	{"BVS", 0x70, 1, &EmulateurOric::BVS , &EmulateurOric::direct},
	{"BIT", 0x2C, 2, &EmulateurOric::BIT , &EmulateurOric::absolu},
	{"BIT", 0x24, 1, &EmulateurOric::BIT , &EmulateurOric::page0},
	{"BRK", 0x00, 0, &EmulateurOric::BRK , &EmulateurOric::none},
	{"CLC", 0x18, 0, &EmulateurOric::CLC , &EmulateurOric::none},
	{"CLD", 0xD8, 0, &EmulateurOric::CLD , &EmulateurOric::none},
	{"CLI", 0x58, 0, &EmulateurOric::CLI , &EmulateurOric::none},
	{"CLV", 0xB8, 0, &EmulateurOric::CLV , &EmulateurOric::none},
	{"CMP", 0xC9, 1, &EmulateurOric::CMP , &EmulateurOric::direct},
	{"CMP", 0xCD, 2, &EmulateurOric::CMP , &EmulateurOric::absolu},
	{"CMP", 0xC5, 1, &EmulateurOric::CMP , &EmulateurOric::page0},
	{"CMP", 0xDD, 2, &EmulateurOric::CMP , &EmulateurOric::absoluX},
	{"CMP", 0xD9, 2, &EmulateurOric::CMP , &EmulateurOric::absoluY},
	{"CMP", 0xD5, 1, &EmulateurOric::CMP , &EmulateurOric::page0X},
	{"CMP", 0xC1, 1, &EmulateurOric::CMP , &EmulateurOric::indirectX},
	{"CMP", 0xD1, 1, &EmulateurOric::CMP , &EmulateurOric::indirectY},
	{"CPX", 0xE0, 1, &EmulateurOric::CPX , &EmulateurOric::direct},
	{"CPX", 0xEC, 2, &EmulateurOric::CPX , &EmulateurOric::absolu},
	{"CPX", 0xE4, 1, &EmulateurOric::CPX , &EmulateurOric::page0},
	{"CPY", 0xC0, 1, &EmulateurOric::CPY , &EmulateurOric::direct},
	{"CPY", 0xCC, 1, &EmulateurOric::CPY , &EmulateurOric::absolu},
	{"CPY", 0xC4, 1, &EmulateurOric::CPY , &EmulateurOric::page0},
	{"DEC", 0xCE, 2, &EmulateurOric::DEC , &EmulateurOric::absolu},
	{"DEC", 0xC6, 1, &EmulateurOric::DEC , &EmulateurOric::page0},
	{"DEC", 0xDE, 2, &EmulateurOric::DEC , &EmulateurOric::absoluX},
	{"DEC", 0xD6, 1, &EmulateurOric::DEC , &EmulateurOric::page0X},
	{"DEX", 0xCA, 0, &EmulateurOric::DEX , &EmulateurOric::none},
	{"DEY", 0x88, 0, &EmulateurOric::DEY , &EmulateurOric::none},
	{"EOR", 0x49, 1, &EmulateurOric::EOR , &EmulateurOric::direct},
	{"EOR", 0x4D, 2, &EmulateurOric::EOR , &EmulateurOric::absolu},
	{"EOR", 0x45, 1, &EmulateurOric::EOR , &EmulateurOric::page0},
	{"EOR", 0x5D, 2, &EmulateurOric::EOR , &EmulateurOric::absoluX},
	{"EOR", 0x59, 2, &EmulateurOric::EOR , &EmulateurOric::absoluY},
	{"EOR", 0x55, 1, &EmulateurOric::EOR , &EmulateurOric::page0X},
	{"EOR", 0x41, 1, &EmulateurOric::EOR , &EmulateurOric::indirectX},
	{"EOR", 0x51, 1, &EmulateurOric::EOR , &EmulateurOric::indirectY},
	{"INC", 0xEE, 2, &EmulateurOric::INC , &EmulateurOric::absolu},
	{"INC", 0xE6, 1, &EmulateurOric::INC , &EmulateurOric::page0},
	{"INC", 0xFE, 2, &EmulateurOric::INC , &EmulateurOric::absoluX},
	{"INC", 0xF6, 1, &EmulateurOric::INC , &EmulateurOric::page0X},
	{"INX", 0xE8, 1, &EmulateurOric::INX , &EmulateurOric::none},
	{"INY", 0xC8, 1, &EmulateurOric::INY , &EmulateurOric::none},
	{"JMP", 0x4C, 2, &EmulateurOric::JMP , &EmulateurOric::absolu},
	{"JMP", 0x6C, 2, &EmulateurOric::JMP , &EmulateurOric::indirect},
	{"JSR", 0x20, 2, &EmulateurOric::JSR , &EmulateurOric::absolu},
	{"LDA", 0xA9, 1, &EmulateurOric::LDA , &EmulateurOric::direct},
	{"LDA", 0xAD, 2, &EmulateurOric::LDA , &EmulateurOric::absolu},
	{"LDA", 0xA5, 1, &EmulateurOric::LDA , &EmulateurOric::page0},
	{"LDA", 0xBD, 2, &EmulateurOric::LDA , &EmulateurOric::absoluX},
	{"LDA", 0xB9, 2, &EmulateurOric::LDA , &EmulateurOric::absoluY},
	{"LDA", 0xB5, 1, &EmulateurOric::LDA , &EmulateurOric::page0X},
	{"LDA", 0xA1, 1, &EmulateurOric::LDA , &EmulateurOric::indirectX},
	{"LDA", 0xB1, 1, &EmulateurOric::LDA , &EmulateurOric::indirectY},
	{"LDX", 0xA2, 1, &EmulateurOric::LDX , &EmulateurOric::direct},
	{"LDX", 0xAE, 2, &EmulateurOric::LDX , &EmulateurOric::absolu},
	{"LDX", 0xA6, 1, &EmulateurOric::LDX , &EmulateurOric::page0},
	{"LDX", 0xBE, 2, &EmulateurOric::LDX , &EmulateurOric::absoluY},
	{"LDX", 0xB6, 1, &EmulateurOric::LDX , &EmulateurOric::indirectY},
	{"LDY", 0xA0, 1, &EmulateurOric::LDY , &EmulateurOric::direct},
	{"LDY", 0xAC, 2, &EmulateurOric::LDY , &EmulateurOric::absolu},
	{"LDY", 0xA4, 1, &EmulateurOric::LDY , &EmulateurOric::page0},
	{"LDY", 0xBC, 2, &EmulateurOric::LDY , &EmulateurOric::absoluX},
	{"LDY", 0xB4, 1, &EmulateurOric::LDY , &EmulateurOric::page0X},
	{"LSR", 0x4A, 0, &EmulateurOric::LSRa, &EmulateurOric::none},
	{"LSR", 0x4E, 2, &EmulateurOric::LSR , &EmulateurOric::absolu},
	{"LSR", 0x46, 1, &EmulateurOric::LSR , &EmulateurOric::page0},
	{"LSR", 0x5E, 2, &EmulateurOric::LSR , &EmulateurOric::absoluX},
	{"LSR", 0x56, 1, &EmulateurOric::LSR , &EmulateurOric::page0X},
	{"NOP", 0xEA, 0, &EmulateurOric::NOP , &EmulateurOric::none},
	{"ORA", 0x09, 1, &EmulateurOric::ORA , &EmulateurOric::direct},
	{"ORA", 0x0D, 2, &EmulateurOric::ORA , &EmulateurOric::absolu},
	{"ORA", 0x05, 1, &EmulateurOric::ORA , &EmulateurOric::page0},
	{"ORA", 0x1D, 2, &EmulateurOric::ORA , &EmulateurOric::absoluX},
	{"ORA", 0x19, 2, &EmulateurOric::ORA , &EmulateurOric::absoluY},
	{"ORA", 0x15, 1, &EmulateurOric::ORA , &EmulateurOric::page0X},
	{"ORA", 0x01, 1, &EmulateurOric::ORA , &EmulateurOric::indirectX},
	{"ORA", 0x11, 1, &EmulateurOric::ORA , &EmulateurOric::indirectY},
	{"PHA", 0x48, 0, &EmulateurOric::PHA , &EmulateurOric::none},
	{"PHP", 0x08, 0, &EmulateurOric::PHP , &EmulateurOric::none},
	{"PLA", 0x68, 0, &EmulateurOric::PLA , &EmulateurOric::none},
	{"PLP", 0x28, 0, &EmulateurOric::PLP , &EmulateurOric::none},
	{"ROL", 0x2A, 0, &EmulateurOric::ROLa, &EmulateurOric::none},
	{"ROL", 0x2E, 2, &EmulateurOric::ROL , &EmulateurOric::absolu},
	{"ROL", 0x26, 1, &EmulateurOric::ROL , &EmulateurOric::page0},
	{"ROL", 0x3E, 2, &EmulateurOric::ROL , &EmulateurOric::absoluX},
	{"ROL", 0x36, 1, &EmulateurOric::ROL , &EmulateurOric::page0X},
	{"ROR", 0x6A, 0, &EmulateurOric::RORa, &EmulateurOric::none},
	{"ROR", 0x6E, 2, &EmulateurOric::ROR , &EmulateurOric::absolu},
	{"ROR", 0x66, 1, &EmulateurOric::ROR , &EmulateurOric::page0},
	{"ROR", 0x7E, 2, &EmulateurOric::ROR , &EmulateurOric::absoluX},
	{"ROR", 0x76, 1, &EmulateurOric::ROR , &EmulateurOric::page0X},
	{"RTI", 0x40, 0, &EmulateurOric::RTI , &EmulateurOric::none},
	{"RTS", 0x60, 0, &EmulateurOric::RTS , &EmulateurOric::none},
	{"SBC", 0xE9, 1, &EmulateurOric::SBC , &EmulateurOric::direct},
	{"SBC", 0xED, 2, &EmulateurOric::SBC , &EmulateurOric::absolu},
	{"SBC", 0xE5, 1, &EmulateurOric::SBC , &EmulateurOric::page0},
	{"SBC", 0xFD, 2, &EmulateurOric::SBC , &EmulateurOric::absoluX},
	{"SBC", 0xF9, 2, &EmulateurOric::SBC , &EmulateurOric::absoluY},
	{"SBC", 0xF5, 1, &EmulateurOric::SBC , &EmulateurOric::page0X},
	{"SBC", 0xE1, 1, &EmulateurOric::SBC , &EmulateurOric::indirectX},
	{"SBC", 0xF1, 1, &EmulateurOric::SBC , &EmulateurOric::indirectY},
	{"SEC", 0x38, 0, &EmulateurOric::SEC , &EmulateurOric::none},
	{"SED", 0xF8, 0, &EmulateurOric::SED , &EmulateurOric::none},
	{"SEI", 0x78, 0, &EmulateurOric::SEI , &EmulateurOric::none},
	{"STA", 0x8D, 2, &EmulateurOric::STA , &EmulateurOric::absolu},
	{"STA", 0x85, 1, &EmulateurOric::STA , &EmulateurOric::page0},
	{"STA", 0x9D, 2, &EmulateurOric::STA , &EmulateurOric::absoluX},
	{"STA", 0x99, 2, &EmulateurOric::STA , &EmulateurOric::absoluY},
	{"STA", 0x95, 1, &EmulateurOric::STA , &EmulateurOric::page0X},
	{"STA", 0x81, 1, &EmulateurOric::STA , &EmulateurOric::indirectX},
	{"STA", 0x91, 1, &EmulateurOric::STA , &EmulateurOric::indirectY},
	{"STX", 0x8E, 2, &EmulateurOric::STX , &EmulateurOric::absolu},
	{"STX", 0x86, 1, &EmulateurOric::STX , &EmulateurOric::page0},
	{"STX", 0x96, 1, &EmulateurOric::STX , &EmulateurOric::page0Y},
	{"STY", 0x8C, 2, &EmulateurOric::STY , &EmulateurOric::absolu},
	{"STY", 0x84, 1, &EmulateurOric::STY , &EmulateurOric::page0},
	{"STY", 0x94, 1, &EmulateurOric::STY , &EmulateurOric::page0X},
	{"TAX", 0xAA, 0, &EmulateurOric::TAX , &EmulateurOric::none},
	{"TAY", 0xA8, 0, &EmulateurOric::TAY , &EmulateurOric::none},
	{"TSX", 0xBA, 0, &EmulateurOric::TSX , &EmulateurOric::none},
	{"TXA", 0x8A, 0, &EmulateurOric::TXA , &EmulateurOric::none},
	{"TXS", 0x9A, 0, &EmulateurOric::TXS , &EmulateurOric::none},
	{"TYA", 0x98, 0, &EmulateurOric::TYA , &EmulateurOric::none},
	
	{0},
	
};

EmulateurOric::RefIndicateur EmulateurOric::g_RefIndicateur[] = 
{
	/*0123456*/
	/*NVZCBDI*/
	{"xxxx   ", {&EmulateurOric::ADC, &EmulateurOric::SBC, &EmulateurOric::PLP, &EmulateurOric::RTI, 0}},
	{"x xx   ", {&EmulateurOric::ASL, &EmulateurOric::ASLa, &EmulateurOric::CMP, &EmulateurOric::CPX, &EmulateurOric::CPY, &EmulateurOric::ROL, &EmulateurOric::ROR, 0}},
	{"0 xx   ", {&EmulateurOric::LSR, &EmulateurOric::LSRa, 0}},
	{"x x    ", {&EmulateurOric::AND, &EmulateurOric::DEC, &EmulateurOric::DEX, &EmulateurOric::DEY, &EmulateurOric::EOR, &EmulateurOric::INC, &EmulateurOric::INX, &EmulateurOric::INY, &EmulateurOric::LDA, &EmulateurOric::LDX, &EmulateurOric::LDY, &EmulateurOric::ORA, &EmulateurOric::PLA, &EmulateurOric::TAX, &EmulateurOric::TAY, &EmulateurOric::TXA, &EmulateurOric::TYA, &EmulateurOric::TSX, 0}},
	{"x6x    ", {&EmulateurOric::BIT, 0}},
	{"   0   ", {&EmulateurOric::CLC, 0}},
	{"     0 ", {&EmulateurOric::CLD, 0}},
	{" 0     ", {&EmulateurOric::CLV, 0}},
	{"   1   ", {&EmulateurOric::SEC, 0}},  
	{"     1 ", {&EmulateurOric::SED, 0}},
	{"      0", {&EmulateurOric::CLI, 0}},
	{"      1", {&EmulateurOric::SEI, 0}},
	{"       ", {&EmulateurOric::PLP, &EmulateurOric::RTI, 0}},
	{"    1 1", {&EmulateurOric::BRK, 0}},
	
	{0},
	
};

Addr EmulateurOric::none()
{
	return 0;
}

Addr EmulateurOric::direct()
{
	return PC++;
}

Addr EmulateurOric::absolu()
{
	Byte q = Peek( PC++ );
	Byte p = Peek( PC++ );
	
	return MakeAddr( p , q );
}

Addr EmulateurOric::page0()
{
	Byte q = Peek( PC++ );
	
	return MakeAddr( 0 , q );
}

Addr EmulateurOric::absoluX()
{
	Byte q = Peek( PC++ );
	Byte p = Peek( PC++ );
	
	return (Byte) ( MakeAddr( p , q ) + X );
}

Addr EmulateurOric::absoluY()
{
	Byte q = Peek( PC++ );
	Byte p = Peek( PC++ );
	
	return (Byte) ( MakeAddr( p , q ) + Y );
}

Addr EmulateurOric::page0X()
{
	Byte q = Peek( PC++ );
	
	return (Byte) ( MakeAddr( 0 , q ) + X );
}

Addr EmulateurOric::page0Y()
{
	Byte q = Peek( PC++ );
	
	return (Byte) ( MakeAddr( 0 , q ) + Y );
}

Addr EmulateurOric::indirect()
{
	Byte q = Peek( PC++ );
	Byte p = Peek( PC++ );
	
	Addr temp = MakeAddr( p , q );
	
	Byte l = Peek( temp++ );
	Byte h = Peek( temp );
	
	return MakeAddr( h , l );
}

Addr EmulateurOric::indirectX()
{
	Byte d = Peek( PC++ );
	
	Addr temp = (Byte) ( MakeAddr( 0 , d ) + X );
	
	Byte l = Peek( temp++ );
	Byte h = Peek( temp );
	
	return MakeAddr( h , l );
}

Addr EmulateurOric::indirectY()
{
	Byte d = Peek( PC++ );
	
	Addr temp = MakeAddr( 0 , d );
	
	Byte l = Peek( temp++ );
	Byte h = Peek( temp );
	
	return (Byte) ( MakeAddr( h , l ) + Y );
}

bool EmulateurOric::idle() {
	if ( !Run() ) {
		m_view->m_close = true;
	}
	
	return true;
}
