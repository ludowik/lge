#pragma once

std::string string_format(const std::string fmt, ...);

std::string as_string(int i);
std::string as_string(double f);
std::string as_string(vec2 v);
std::string as_string(vec3 v);
std::string as_string(vec4 v);

void info(string txt, ...);
void warning(string txt, ...);
void error(string txt, ...);

void get_direction(vec3 &direction, float phi, float theta);
void get_angle(vec3 direction, float &phi, float &theta);

float distance_by_frame(float vitesse, int frame_time);
vec3 distance_by_frame(vec3 vitesse, int frame_time);

float angle_by_frame(float vitesse, int frame_time);

void update_angle(float &angle, float vitesse, int frame_time);

int get_delay(Uint32 time);

float interpolate(float a, float b, float t);

class Delay {
public:
    Delay(string traitement);
    virtual ~Delay();
    
private:
    string m_traitement;
    
    Uint32 m_start_ticks;
    
};

#define LogTime(traitement) Delay delay(traitement)

std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems);
std::vector<std::string> split(const std::string &s, char delim);
