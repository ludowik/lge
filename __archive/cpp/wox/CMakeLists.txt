# wox
cmake_minimum_required (VERSION 3.8)

project ("wox")

set(CMAKE_PREFIX_PATH "../../libraries/glew/glew")
set(CMAKE_LIBRARY_PATH "../../libraries/bin")

file (GLOB WOX_SOURCE ./wox/*.cpp)
file (GLOB ENGINE_SOURCE ./sources/*.cpp)

link_directories (C:/Users/lmilhau/Documents/Divers/archive/libraries/bin)

add_executable (${PROJECT_NAME}  ${WOX_SOURCE} ${ENGINE_SOURCE})

target_include_directories (${PROJECT_NAME} PUBLIC ../../libraries/glew/glew/include)
target_include_directories (${PROJECT_NAME} PUBLIC ../../libraries/sdl/sdl2/include)
target_include_directories (${PROJECT_NAME} PUBLIC ../../libraries/sdl_image/sdl2_image/include)
target_include_directories (${PROJECT_NAME} PUBLIC ../../libraries/glm/glm)

find_package(GLEW REQUIRED)
find_library (SDL_LIBRARY sdl2 C:/Users/lmilhau/Documents/Divers/archive/libraries/bin)
find_library (SDL_IMAGE_LIBRARY sdl2_image C:/Users/lmilhau/Documents/Divers/archive/libraries/bin)
find_library (OPENGL_LIBRARY opengl32) 

message(${GLEW_LIBRARIES})
message(${SDL_LIBRARY})
message(${SDL_IMAGE_LIBRARY})
message(${OPENGL_LIBRARY})

target_link_libraries (${PROJECT_NAME} ${SDL_LIBRARY} ${SDL_IMAGE_LIBRARY} ${GLEW_LIBRARIES} ${OPENGL_LIBRARY})

# TODO: Ajoutez des tests et installez des cibles si nécessaire.
