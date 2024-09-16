#pragma once

#include "model.h"

class Pnj : public Model {
public:
    Pnj();
    virtual ~Pnj();
    
public:
    virtual void update(int time);
    
    void compute_direction();

public:
    vec3 m_position_previous;
    vec3 m_position_old;
    
    float m_phi;
    float m_theta;
    float m_dtheta;

    vec3 m_direction;
    vec3 m_direction_eye;
    
    vec3 m_speed;

    bool m_testCollision;
    bool m_flyingMode;

};
