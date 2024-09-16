#include "System.h"
#include "Physic.h"

#include "3dpoint.h"
#include "3dvector.h"

#define carre(x) (x*x)

/* Gestion d'une particule
 */
ImplementClass(Particle) : Vector {
public:
	Vector m_pos;
	
	Vector previous;
	Vector accum;
	
};

/* Interface de declaration d'une contrainte
 */
ImplementClass(Constraint) : public Object {
public:
	Constraint();
	
public:
	virtual void maintainConstraint()=0;
	
};

Constraint::Constraint() {
}

// Gestion d'une contrainte de distance entre deux particules
ImplementClass(ConstraintDistance) : public Constraint {
private:
	ParticleRef m_p1;
	ParticleRef m_p2;
	
	double m_distance;
	
public:
	ConstraintDistance(ParticleRef p1, ParticleRef p2, double distance);
	
public:
	virtual void maintainConstraint();
	
};

ConstraintDistance::ConstraintDistance(ParticleRef p1, ParticleRef p2, double distance) {
	m_p1 = p1;
	m_p2 = p2;
}

void ConstraintDistance::maintainConstraint() {
	// Calcul de la distance en les deux particules
	double distance = Vector::GetNorm(&m_p1->m_pos, &m_p2->m_pos);
	
	// Validation de la contrainte
	if ( distance != m_distance ) {
		// Maintien de la contrainte
	}
}

// Gestion d'une contrainte d'espace pour une  particule
ImplementClass(ConstraintEspace) : public Constraint {
private:
	ParticleRef m_p;
	
	Rect m_espace;
	
public:
	ConstraintEspace(ParticleRef p, Rect espace);
	
public:
	virtual void maintainConstraint();
	
};

ConstraintEspace::ConstraintEspace(ParticleRef p, Rect espace) {
	m_p = p;
	m_espace = espace;
}

void ConstraintEspace::maintainConstraint() {
	// Maintien de la contrainte X
	if ( m_p->m_pos.x < m_espace.x ) {
		m_p->m_pos.x = m_espace.x;
	}
	else if ( m_p->m_pos.x > m_espace.x+m_espace.w ) {
		m_p->m_pos.x = m_espace.x+m_espace.w;
	}
	
	// Maintien de la contrainte Y
	if ( m_p->m_pos.y < m_espace.y ) {
		m_p->m_pos.y = m_espace.y;
	}
	else if ( m_p->m_pos.y > m_espace.y+m_espace.h ) {
		m_p->m_pos.y = m_espace.y+m_espace.h;
	}
	
	/* Maintien de la contrainte Z
	 if ( m_p->m_pos.z < m_espace.z ) {
	 m_p->m_pos.z = m_espace.z;
	 }
	 else if ( m_p->m_pos.z > m_espace.z+m_espace.p ) {
	 m_p->m_pos.z = m_espace.z+m_espace.p;
	 }
	 */
}

// Maintien d'une liste de contrainte
// i doit-être ajuste...
/*void maintainConstraint() {
 // Creation d'une contrainte d'espace dans le cadre de l'iphone
 Rect3D screen;
 screen.w = wscreen;
 screen.h = hscreen;
 
 ConstraintEspace constraintEspace(0, screen);
 
 fori(i,0,3) {
 // Maintien des contraintes
 foreach(ConstraintRef, constraint, list) {
 constraint->maintainConstraint();
 }
 
 // Maintien des contraintes generiques
 foreach(ParticleRef, particle, list) {
 constraintEspace->m_p = particle;
 constraintEspace->maintainConstraint();
 }
 }
 }*/

Vector vGravity;

ImplementClass(Physic) : public Object {
public:
	Collection m_particles;
public:
	Physic();
	
public:
	void verletIntegration();
	
	void satisfyConstraint();
	void accumulateForce();
	
};

void Physic::verletIntegration() {
	Iterator iter = m_particles.getIterator();
	while ( iter.hasNext() ) {
		//ParticleRef particle = (ParticleRef)iter.next();
	}
}


