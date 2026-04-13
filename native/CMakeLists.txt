cmake_minimum_required(VERSION 3.16)
project(agrotrilho_native VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Source files
set(SOURCES
    src/tracking_data.cpp
    src/gps_utils.cpp
)

# Header files
set(HEADERS
    include/agrotrilho/tracking_data.h
    include/agrotrilho/gps_utils.h
    include/agrotrilho/animal_data.h
)

# Library target
add_library(agrotrilho_native STATIC ${SOURCES})

target_include_directories(agrotrilho_native PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Install
install(TARGETS agrotrilho_native DESTINATION lib)
install(DIRECTORY include/ DESTINATION include)
