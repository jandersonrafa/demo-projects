cmake_minimum_required(VERSION 3.14)
project(benchmark_cpp_gateway)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(DROGON REQUIRED drogon)
pkg_check_modules(CPR REQUIRED cpr)

add_executable(gateway)

target_sources(gateway PRIVATE
    src/main.cpp
    src/controllers/GatewayController.cpp
    src/services/HttpClientService.cpp
)

target_include_directories(gateway PRIVATE
    include
    ${DROGON_INCLUDE_DIRS}
    ${CPR_INCLUDE_DIRS}
)

target_link_libraries(gateway PRIVATE
    ${DROGON_LIBRARIES}
    ${CPR_LIBRARIES}
)

target_compile_options(gateway PRIVATE
    ${DROGON_CFLAGS_OTHER}
    ${CPR_CFLAGS_OTHER}
)
