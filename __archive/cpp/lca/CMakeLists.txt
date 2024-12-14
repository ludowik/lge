# lca
cmake_minimum_required (VERSION 3.8)

# recurse add headers path
MACRO(HEADER_DIRECTORIES return_list)
    FILE(GLOB_RECURSE new_list *.h)
    SET(dir_list "")
    FOREACH(file_path ${new_list})
        GET_FILENAME_COMPONENT(dir_path ${file_path} PATH)
        SET(dir_list ${dir_list} ${dir_path})
    ENDFOREACH()
    LIST(REMOVE_DUPLICATES dir_list)
    SET(${return_list} ${dir_list})
ENDMACRO()

HEADER_DIRECTORIES(header_dir_list)

list(LENGTH header_dir_list header_dir_list_count)
message(STATUS "[INFO] Found ${header_dir_list_count} header directories.")
# recurse add headers path

project ("lca")

set(CMAKE_PREFIX_PATH "../../libraries/glew/glew")
set(CMAKE_LIBRARY_PATH "../../libraries/bin")

file (GLOB_RECURSE ENGINE_SOURCE ./framework/*.cpp)
file (GLOB_RECURSE APPS_SOURCE ./applications/*.cpp)

link_directories (C:/Users/lmilhau/Documents/Divers/archive/libraries/bin)

add_executable (${PROJECT_NAME} WIN32 source.cpp ${ENGINE_SOURCE} ${APPS_SOURCE})

target_sources(${PROJECT_NAME} PRIVATE engine.rc)

target_include_directories (${PROJECT_NAME} PUBLIC ../../libraries/glew/glew/include)
target_include_directories (${PROJECT_NAME} PUBLIC ../../libraries/sdl/sdl2/include)
target_include_directories (${PROJECT_NAME} PUBLIC ../../libraries/sdl_image/sdl2_image/include)
target_include_directories (${PROJECT_NAME} PUBLIC ../../libraries/glm/glm)

target_include_directories(
    ${PROJECT_NAME} 
    PUBLIC
    ${header_dir_list} # Recursive
)

target_include_directories (${PROJECT_NAME} PUBLIC ./framework/system)

find_package(GLEW REQUIRED)
find_library (SDL_LIBRARY sdl2 C:/Users/lmilhau/Documents/Divers/archive/libraries/bin)
find_library (SDL_IMAGE_LIBRARY sdl2_image C:/Users/lmilhau/Documents/Divers/archive/libraries/bin)
find_library (OPENGL_LIBRARY opengl32) 
find_library (GDI_LIBRARY gdi32) 
find_library (GDI_PLUS_LIBRARY gdiplus) 
find_library (IMG_LIBRARY msimg32)
find_library (WINMM_LIBRARY winmm)

message(${GLEW_LIBRARIES})
message(${SDL_LIBRARY})
message(${SDL_IMAGE_LIBRARY})
message(${OPENGL_LIBRARY})
message(${GDI_LIBRARY})
message(${GDI_PLUS_LIBRARY})
message(${IMG_LIBRARY})
message(${WINMM_LIBRARY})

target_link_libraries (${PROJECT_NAME} ${SDL_LIBRARY} ${SDL_IMAGE_LIBRARY} ${GLEW_LIBRARIES} ${OPENGL_LIBRARY} ${GDI_LIBRARY} ${GDI_PLUS_LIBRARY} ${IMG_LIBRARY} ${WINMM_LIBRARY})

# TODO: Ajoutez des tests et installez des cibles si nécessaire.
