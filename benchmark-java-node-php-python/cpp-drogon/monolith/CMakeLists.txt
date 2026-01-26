cmake_minimum_required(VERSION 3.14)
project(benchmark_cpp_monolith)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Drogon after it's been installed
find_package(Drogon CONFIG REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_check_modules(PQXX REQUIRED libpqxx)

add_executable(monolith)

target_sources(monolith PRIVATE
    src/main.cpp
    src/controllers/BonusController.cpp
    src/models/Bonus.cpp
    src/models/Client.cpp
    src/services/BonusService.cpp
    src/repositories/BonusRepository.cpp
    src/repositories/ClientRepository.cpp
    src/config/DatabaseConfig.cpp
)

target_include_directories(monolith PRIVATE
    include
    ${DROGON_INCLUDE_DIRS}
    ${PQXX_INCLUDE_DIRS}
)

target_link_libraries(monolith PRIVATE
    Drogon::Drogon
    ${PQXX_LIBRARIES}
)

target_compile_options(monolith PRIVATE
    ${PQXX_CFLAGS_OTHER}
)
