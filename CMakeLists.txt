cmake_minimum_required(VERSION 3.22)

project(qsqlpsql)

# Enable Qt MOC processing
set(CMAKE_AUTOMOC ON)

# Find required Qt components
find_package(Qt6 REQUIRED COMPONENTS Core Sql)

# For Android cross-compilation, manually specify PostgreSQL paths
set(PostgreSQL_FOUND TRUE)
set(PostgreSQL_INCLUDE_DIRS 
    "${CMAKE_CURRENT_SOURCE_DIR}/postgresql-17.6/src/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/postgresql-17.6/src/interfaces/libpq"
)
set(PostgreSQL_LIBRARIES "${CMAKE_CURRENT_SOURCE_DIR}/postgresql-17.6/src/interfaces/libpq/libpq.so")

# Verify the files exist
if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/postgresql-17.6/src/include/postgres_ext.h")
    message(FATAL_ERROR "PostgreSQL header not found at ${CMAKE_CURRENT_SOURCE_DIR}/postgresql-17.6/src/include/postgres_ext.h")
endif()

if(NOT EXISTS "${PostgreSQL_LIBRARIES}")
    message(FATAL_ERROR "PostgreSQL library not found at ${PostgreSQL_LIBRARIES}")
endif()

message(STATUS "Using PostgreSQL headers: ${PostgreSQL_INCLUDE_DIRS}")
message(STATUS "Using PostgreSQL library: ${PostgreSQL_LIBRARIES}")

# Source files
set(SOURCES
    qsql_psql.cpp
    main.cpp
)

set(HEADERS
    qsql_psql_p.h
)

# Create the plugin
qt6_add_plugin(qsqlpsql
    CLASS_NAME QPSQLDriverPlugin
    ${SOURCES}
    ${HEADERS}
)

# Set plugin properties
set_target_properties(qsqlpsql PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/plugins/sqldrivers"
)

# Include directories - add both PostgreSQL and Qt private headers
target_include_directories(qsqlpsql PRIVATE
    ${PostgreSQL_INCLUDE_DIRS}
    /home/hamzah/Qt/6.8.3/android_arm64_v8a/include/QtSql/6.8.3
    /home/hamzah/Qt/6.8.3/android_arm64_v8a/include/QtSql/6.8.3/QtSql
    /home/hamzah/Qt/6.8.3/android_arm64_v8a/include/QtCore/6.8.3
    /home/hamzah/Qt/6.8.3/android_arm64_v8a/include/QtCore/6.8.3/QtCore
)

# Link libraries
target_link_libraries(qsqlpsql
    Qt6::Core
    Qt6::Sql
    ${PostgreSQL_LIBRARIES}
)

# Install the plugin to the correct location
install(TARGETS qsqlpsql
    LIBRARY DESTINATION "plugins/sqldrivers"
)
