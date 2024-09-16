#include "headers.h"
#include "pnj.h"

Pnj::Pnj() :
m_position_previous(0),
m_position_old(0),
m_direction(0),
m_direction_eye(0),
m_speed(0),
m_phi(0), m_theta(0), m_dtheta(0),
m_testCollision(true),
m_flyingMode(true) {
    createCube(origin, 0.8f);
    center();
}

Pnj::~Pnj() {
}
    
void Pnj::update(int time) {
    Model::update(time);

    if ( ( m_direction.x || m_direction.y ) && m_speed.y ) {
        vec3 direction = normalize(vec3(m_direction.x, m_direction.y, 0));
        direction *= distance_by_frame(m_speed.y, time);
        m_position += direction;
    }
    
    if ( ( m_direction.x || m_direction.y || m_direction.z ) && m_speed.x ) {
        vec3 ortho = normalize(cross(axe_z, m_direction));
        ortho *= distance_by_frame(m_speed.x, time);
        m_position += ortho;
    }
    
    if ( m_speed.z ) {
        vec3 elevation = vec3(0, 0, m_speed.z);
        m_position += elevation;
    }
}

void Pnj::compute_direction() {
    get_direction(m_direction, m_phi, m_theta);
    get_direction(m_direction_eye, m_phi, m_theta + m_dtheta);
}
