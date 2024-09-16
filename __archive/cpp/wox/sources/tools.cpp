#define TOOLS

#include "headers.h"
#include "map.h"
#include "tools.h"

bool replace(std::string& str, const std::string& from, const std::string& to) {
    size_t start_pos = str.find(from);
    if ( start_pos == std::string::npos ) {
        return false;
    }
    
    str.replace(start_pos, from.length(), to);
    return true;
}

std::string string_format(const std::string fmt, ...) {
    int size = 100;
    std::string str;
    va_list ap;
    while (1) {
        str.resize(size);
        va_start(ap, fmt);
#ifdef _WIN32
        int n = vsnprintf_s((char *)str.c_str(), size, size, fmt.c_str(), ap);
#elif __APPLE__
        int n = vsnprintf((char *)str.c_str(), size, fmt.c_str(), ap);
#endif
        va_end(ap);
        if (n > -1 && n < size) {
            str.resize(n);
            return str;
        }
        if (n > -1)
            size = n + 1;
        else
            size *= 2;
    }
    return str;
}

string as_string(int i) {
    string str = string_format("%d", i);
    return str;
}

string as_string(double d) {
    string str = string_format("%.2f", d);
    return str;
}

string as_string(vec2 v) {
    string str = string_format("X=%.2f Y=%.2f", v.x, v.y);
    return str;
}

string as_string(vec3 v) {
    string str = string_format("X=%.2f Y=%.2f Z=%.2f", v.x, v.y, v.z);
    return str;
}

string as_string(vec4 v) {
    string str = string_format("X=%.2f Y=%.2f Z=%.2f W=%.2f", v.x, v.y, v.z, v.w);
    return str;
}

void log(string str, va_list list) {
    int i = 1;
    
    const char* arg;
    
    arg = va_arg(list, const char*);
    while ( arg ) {
        string ref_arg = "{";
        ref_arg += (i++ +'0');
        ref_arg += "}";

		if ( str.find(ref_arg) == -1 ) {
			break;
		}

        replace(str, ref_arg.c_str(), arg);
        
        arg = va_arg(list, const char*);
    }
    
    std::cout << str << std::endl;
}

void info(string str, ...) {
    va_list list;
    va_start(list, str);
    
    log("Info: " + str, list);
}

void warning(string str, ...) {
    va_list list;
    va_start(list, str);
    
    log("Warning: " + str, list);
}

void error(string str, ...) {
    va_list list;
    va_start(list, str);
    
    log("Error: " + str, list);
}

void get_direction(vec3 &direction, float phi, float theta) {
    // La caméra
    direction.x = cosf(phi) * sinf(theta);
    direction.y = cosf(phi) * cosf(theta);
    direction.z = sinf(phi);
}

void get_angle(vec3 direction, float &phi, float &theta) {
    direction = normalize(direction);
    
    phi = asinf((float)direction.z);
    
    float cos_phi = cosf(phi);
    float cos_theta = (float)direction.y / cos_phi;
    
    theta = acosf(minmax(cos_theta, -1, 1));
    
    if ( direction.x < 0 ) {
        theta *= -1;
    }
}

// vitesse en kmh
float distance_by_frame(float vitesse, int frame_time) {
    static const float t_tick = 1000. / ( 60. * 60. * 1000. );

    float distance_by_tick = vitesse * t_tick;
    float distance_by_frame = distance_by_tick * frame_time;
    
    return distance_by_frame;
}

// vitesse en kmh
vec3 distance_by_frame(vec3 vitesse, int frame_time) {
    vec3 distance(distance_by_frame(vitesse.x, frame_time),
                  distance_by_frame(vitesse.y, frame_time),
                  distance_by_frame(vitesse.z, frame_time));
    
    return distance;
}

// vitesse en tm
GLfloat angle_by_frame(float vitesse, int frame_time) {
    static const float t_tick = DEGREE_MAX / ( 60. * 1000. );
    float angle_by_tick = vitesse * t_tick;
    float angle_by_frame = angle_by_tick * frame_time;
    
    return angle_by_frame;
}

void update_angle(float &angle, float vitesse, int frame_time) {
    angle += angle_by_frame(vitesse, frame_time);
    
    if ( angle >= DEGREE_MAX ) {
        angle -= DEGREE_MAX;
    } else if ( angle <= -DEGREE_MAX ) {
        angle += DEGREE_MAX;
    }
}

int get_delay(Uint32 time) {
    return SDL_GetTicks() - time + 1;
}

float interpolate(float a, float b, float t) {
    return minmax(a + ( b - a ) * t, a, b);
}

Delay::Delay(string traitement) {
    m_traitement = traitement;
    m_start_ticks = SDL_GetTicks();
}

Delay::~Delay() {
    cout << m_traitement << " : " << SDL_GetTicks() - m_start_ticks << endl;
}

std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems) {
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}


std::vector<std::string> split(const std::string &s, char delim) {
    std::vector<std::string> elems;
    split(s, delim, elems);
    return elems;
}
