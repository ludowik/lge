#include "headers.h"
#include "opengl_engine.h"

OpenGLEngine* g_engine = NULL;

OpenGLEngine::OpenGLEngine(const char* wndTitle, int w, int h) :
m_wnd(0),
m_wndTitle(wndTitle),
m_w(w),
m_h(h),
m_perspective_fovy(65.0f),
m_perspective_aspect((GLfloat)w / h),
m_perspective_near(0.01f),
m_perspective_far(10000.0f),
m_nvertices_total(0),
m_nvertices_visible(0),
m_gravity(9 * 60 * 60 / 1000.f),
m_nframes(0),
m_frames_delay(0),
m_frame_rate(32),
m_frame_time(1000 / m_frame_rate),
m_fps(),
m_fps_theoric(0) {
}

OpenGLEngine::~OpenGLEngine() {
    release();
}

bool OpenGLEngine::init() {
    if ( init_sdl() ) {
		if ( init_gl() ) {
            shader::init();
            texture::init();
            color::init();
            
            if ( game_init() && model_init() ) {
                return true;
            }
		}
	}
	return false;
}

bool OpenGLEngine::init_sdl() {
    // Initialisation de la SDL
    if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) {
        error("Erreur lors de l'initialisation de la SDL : {1}", SDL_GetError());
        SDL_Quit();
        return false;
    }
    
#ifdef __APPLE__
    
    // Version d'OpenGL
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
    
#else
    
    // Version d'OpenGL
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);
    
#endif
    
    // Double Buffer
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
    
    // Création de la fenêtre
    m_wnd = SDL_CreateWindow(m_wndTitle.c_str(),
                             SDL_WINDOWPOS_CENTERED,
                             SDL_WINDOWPOS_CENTERED,
                             m_w, m_h,
                             SDL_WINDOW_BORDERLESS | SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL/*| SDL_WINDOW_FULLSCREEN*/);
    
    if ( m_wnd == 0 ) {
        error(SDL_GetError());
        SDL_Quit();
        return false;
    }
    
    /* SDL_SetWindowFullscreen(m_wnd, SDL_TRUE);
     */
    
    SDL_GetWindowSize(m_wnd, &m_w, &m_h);
    
    // Création du contexte OpenGL
    m_contextOpenGL = SDL_GL_CreateContext(m_wnd);
    if ( m_contextOpenGL == 0 ) {
        error(SDL_GetError());
        SDL_DestroyWindow(m_wnd);
        SDL_Quit();
        return false;
    }
    
#ifdef _WIN32
    
    // On initialise GLEW
    GLenum initialisationGLEW(glewInit());
    
    // Si l'initialisation a échouée :
    if ( initialisationGLEW != GLEW_OK ) {
        // On affiche l'erreur grâce à la fonction : glewGetErrorString(GLenum code)
        error("Erreur d'initialisation de GLEW : {1}", glewGetErrorString(initialisationGLEW));
        
        // On quitte la SDL
        SDL_GL_DeleteContext(m_contextOpenGL);
        SDL_DestroyWindow(m_wnd);
        SDL_Quit();
        
        return false;
    }
    
#endif
    
    return true;
}

bool OpenGLEngine::init_gl() {
    // Activation du Depth Buffer
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);

    exitOnGLError("ERROR: Could not set OpenGL depth testing options");
    
    // Activation du Culling
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    glFrontFace(GL_CCW);
    exitOnGLError("ERROR: Could not set OpenGL culling options");
    
    // Blend
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glEnable(GL_LINE_SMOOTH);
    glEnable(GL_POLYGON_SMOOTH);
    
    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
    glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
    
    return true;
}

bool OpenGLEngine::game_init() {
    m_player.m_direction = vec3(0.,1.,-0.5);
    
    get_angle(m_player.m_direction, m_player.m_phi, m_player.m_theta);
    
    return true;
}

bool OpenGLEngine::model_init() {
    m_models.init(this);
    return true;
}

void OpenGLEngine::release() {
    model_release();
    
    texture::release();
    shader::release();
    
    SDL_SetWindowFullscreen(m_wnd, SDL_FALSE);
    SDL_GL_DeleteContext(m_contextOpenGL);
    SDL_DestroyWindow(m_wnd);
    SDL_Quit();
}

void OpenGLEngine::model_release() {
    m_models.release();
}

void OpenGLEngine::run() {
    m_input.captureMouse(true);
    
    m_ticks_second = SDL_GetTicks();
    
    while ( !m_input.m_quit ) {
        m_ticks_frame = SDL_GetTicks();

        iteration();
    }

    m_input.captureMouse(false);
}

void OpenGLEngine::iteration() {
    // position courante
    m_player.m_position_old = m_player.m_position;
    
    // prise en compte des actions du joueur
    input(m_frame_time);
    
    // maj de la caméra
    m_player.compute_direction();
    
    // maj du jeu
    game_update(m_frame_time);
    
    // rendering
    draw();
    
    // maj des données de frame rate
    m_frame_delay = get_delay(m_ticks_frame);
    m_frames_delay += m_frame_delay;
    
    m_nframes++;
    
    // maj du modèle
    if ( m_frame_delay < m_frame_time ) {
        model_update(m_ticks_frame);
    }
    
    // respect du frame rate
    int delay = m_frame_time - get_delay(m_ticks_frame);
    if ( delay > 1 ) {
        SDL_Delay(delay);
    }
    
    // maj des infos techniques
    if ( get_delay(m_ticks_second) >= 1000 ) {
        info_update();
    }
    
    // maj du feedback
    info_feedback();
}

void OpenGLEngine::game_update(int time) {
    m_player.update(time);
    m_models.update(time);
}

void OpenGLEngine::model_update(int ticks_frame) {
}

void OpenGLEngine::info_update() {
    m_nvertices_total = 0;
    m_nvertices_visible = 0;
            
    m_fps = m_nframes;
    m_fps_theoric = (int)( (float)m_nframes * get_delay(m_ticks_second) / m_frames_delay );
    
    m_ticks_second = SDL_GetTicks();
    m_nframes = 0;
    m_frames_delay = 0;
}

void OpenGLEngine::info_feedback() {
    ostringstream str_out_stream;
    str_out_stream
    << "fps        : " << m_fps.as_string() << " theoric (" << m_fps_theoric << ")" << std::endl
    << "ticks      : " << m_frame_delay.as_string() << " frame time (" << m_frame_time << ")" << std::endl
    << "pos        : " << as_string(m_player.m_position) << std::endl
    << "dir        : " << as_string(m_player.m_direction) << std::endl
    << "phi        : " << as_string(m_player.m_phi) << std::endl
    << "theta      : " << as_string(m_player.m_theta) << std::endl
    << "triangles  : " << m_nvertices_visible / 3 << " / " << m_nvertices_total / 3 << std::endl
    << "perspective: " << as_string(m_perspective_fovy) << ", " << as_string(m_perspective_aspect) << ", " << as_string(m_perspective_near) << ", " << as_string(m_perspective_far) << std::endl
    << "alloc      : " << ( (double)mem_alloc_size() / 1024. / 1024. ) << endl
    << "collision  : " << ( m_player.m_testCollision ? "on" : "off" ) << endl
    << "gravity    : " << ( m_player.m_flyingMode == false ? "on" : "off" ) << endl
    << "indice     : " << ( prop_mode_indices ? "yes" : "no") << endl
    << "voxel      : " << ( prop_voxel_mode ? "yes" : "no") << endl
    << "lighting   : " << ( prop_with_light ? "yes" : "no") << endl
    << "noise      : " << ( prop_with_noise ? "yes" : "no");
    
    m_str_out = str_out_stream.str();
}

void OpenGLEngine::draw() {
    // Nettoyage de l'écran
    glClearColor(light_blue);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Matrice de visualisation
    m_modelView = lookAt(m_player.m_position, m_player.m_position + m_player.m_direction_eye, axe_z);
    
    m_perspective_aspect = (GLfloat)m_w / m_h;
    m_projection = perspective(m_perspective_fovy, m_perspective_aspect, m_perspective_near, m_perspective_far);
    
    // Tracé
    model_draw();
    
    // Affichage des infos de debug
    ::draw(this, m_str_out, 0, 0);

    // Actualisation de la fenêtre
    SDL_GL_SwapWindow(m_wnd);
}

void OpenGLEngine::model_draw() {
    // La scène
    m_models.draw(this);
}

void OpenGLEngine::set_origin() {
    m_player.m_position = origin;
}

void OpenGLEngine::set_up() {
    m_player.m_position.z = 100;
}

void OpenGLEngine::set_down() {
    m_player.m_position.z = 0;
}
