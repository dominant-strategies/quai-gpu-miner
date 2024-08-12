set(SOURCES
	PoolURI.cpp PoolURI.h
	PoolClient.h
	PoolManager.h PoolManager.cpp
	testing/SimulateClient.h testing/SimulateClient.cpp
	stratum/EthStratumClient.h stratum/EthStratumClient.cpp
	stratum/utilstrencodings.h stratum/utilstrencodings.cpp
	stratum/uint256.h stratum/uint256.cpp
	stratum/arith_uint256.h stratum/arith_uint256.cpp
	getwork/EthGetworkClient.h getwork/EthGetworkClient.cpp
)

hunter_add_package(OpenSSL)
find_package(OpenSSL REQUIRED)

add_library(poolprotocols ${SOURCES})
target_link_libraries(poolprotocols PRIVATE devcore kawpowminer-buildinfo ethash::ethash Boost::system jsoncpp_lib_static OpenSSL::SSL OpenSSL::Crypto)
target_include_directories(poolprotocols PRIVATE ..)
