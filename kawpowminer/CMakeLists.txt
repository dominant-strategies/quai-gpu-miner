cmake_policy(SET CMP0015 NEW)

aux_source_directory(. SRC_LIST)

include_directories(BEFORE ..)

set(EXECUTABLE quai-gpu-miner)

file(GLOB HEADERS "*.h")

add_executable(${EXECUTABLE} ${SRC_LIST} ${HEADERS})
if(MSVC)
	target_sources(${EXECUTABLE} PRIVATE kawpowminer.rc)
endif()

hunter_add_package(CLI11)
find_package(CLI11 CONFIG REQUIRED)

target_link_libraries(quai-gpu-miner PRIVATE ethcore poolprotocols devcore kawpowminer-buildinfo CLI11::CLI11 Boost::filesystem Boost::system)

if(ETHDBUS)
	find_package(PkgConfig)
	set( ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:/usr/lib/x86_64-linux-gnu/pkgconfig" )
	pkg_check_modules(DBUS dbus-1)
	include_directories(${DBUS_INCLUDE_DIRS})
	link_directories(${DBUS_LIBRARY_DIRS})
	target_link_libraries(quai-gpu-miner PRIVATE ${DBUS_LIBRARIES})
endif()

if(APICORE)
	target_link_libraries(quai-gpu-miner PRIVATE apicore)
endif()

include(GNUInstallDirs)
install(TARGETS quai-gpu-miner DESTINATION ${CMAKE_INSTALL_BINDIR})
if(MSVC)
    install(FILES $<TARGET_PDB_FILE:quai-gpu-miner> DESTINATION ${CMAKE_INSTALL_BINDIR} OPTIONAL)
endif()
