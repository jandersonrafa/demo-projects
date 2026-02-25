cmake_minimum_required(VERSION 3.14)
project(benchmark_cpp_gateway)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Drogon after it's been installed
find_package(Drogon CONFIG REQUIRED)
find_package(cpr CONFIG REQUIRED)

add_executable(gateway
    src/main.cpp
    src/controllers/GatewayController.cpp
)

target_include_directories(gateway PRIVATE
    include
    ${DROGON_INCLUDE_DIRS}
)

target_link_libraries(gateway PRIVATE
    Drogon::Drogon
    cpr::cpr
)
