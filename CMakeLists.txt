cmake_minimum_required(VERSION 3.20)
project(viewtouchf VERSION 2.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ── Dependencies ──────────────────────────────────────────────
find_package(PkgConfig REQUIRED)
find_package(Protobuf REQUIRED)
find_package(gRPC CONFIG QUIET)

# If gRPC was not found via CMake config, fall back to pkg-config
if(NOT gRPC_FOUND)
    pkg_check_modules(GRPC REQUIRED grpc++ grpc)
endif()

pkg_check_modules(CUPS REQUIRED cups)

# ── Protobuf / gRPC code generation ──────────────────────────
set(PROTO_SRC_DIR ${CMAKE_SOURCE_DIR}/proto)
set(PROTO_GEN_DIR ${CMAKE_BINARY_DIR}/generated)
file(MAKE_DIRECTORY ${PROTO_GEN_DIR})

find_program(PROTOC protoc REQUIRED)
find_program(GRPC_CPP_PLUGIN grpc_cpp_plugin REQUIRED)

set(PROTO_FILE ${PROTO_SRC_DIR}/pos_service.proto)

set(PB_CC  ${PROTO_GEN_DIR}/pos_service.pb.cc)
set(PB_H   ${PROTO_GEN_DIR}/pos_service.pb.h)
set(GRPC_CC ${PROTO_GEN_DIR}/pos_service.grpc.pb.cc)
set(GRPC_H  ${PROTO_GEN_DIR}/pos_service.grpc.pb.h)

add_custom_command(
    OUTPUT ${PB_CC} ${PB_H} ${GRPC_CC} ${GRPC_H}
    COMMAND ${PROTOC}
        --proto_path=${PROTO_SRC_DIR}
        --cpp_out=${PROTO_GEN_DIR}
        --grpc_out=${PROTO_GEN_DIR}
        --plugin=protoc-gen-grpc=${GRPC_CPP_PLUGIN}
        ${PROTO_FILE}
    DEPENDS ${PROTO_FILE}
    COMMENT "Generating protobuf/gRPC C++ sources"
)

# ── Core library (no gRPC dependency) ─────────────────────────
add_library(vt_core STATIC
    src/core/pos_manager.cpp
    src/core/ticket.cpp
    src/core/menu_item.cpp
    src/printing/cups_printer.cpp
)
target_include_directories(vt_core PUBLIC
    ${CMAKE_SOURCE_DIR}/include
    ${CUPS_INCLUDE_DIRS}
)
target_link_libraries(vt_core PUBLIC ${CUPS_LIBRARIES})

# ── gRPC server daemon ───────────────────────────────────────
add_executable(vt_daemon
    src/server/main.cpp
    src/server/pos_service_impl.cpp
    ${PB_CC}
    ${GRPC_CC}
)
target_include_directories(vt_daemon PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${PROTO_GEN_DIR}
    ${CUPS_INCLUDE_DIRS}
)

if(gRPC_FOUND)
    target_link_libraries(vt_daemon PRIVATE
        vt_core
        gRPC::grpc++
        protobuf::libprotobuf
    )
else()
    target_include_directories(vt_daemon PRIVATE ${GRPC_INCLUDE_DIRS})
    target_link_libraries(vt_daemon PRIVATE
        vt_core
        ${GRPC_LIBRARIES}
        ${Protobuf_LIBRARIES}
    )
endif()
