hunter_config(CURL VERSION ${HUNTER_CURL_VERSION} CMAKE_ARGS HTTP_ONLY=ON CMAKE_USE_OPENSSL=ON CMAKE_USE_LIBSSH2=OFF CURL_CA_PATH=none)
hunter_config(Boost VERSION 1.81.0
    URL https://github.com/boostorg/boost/releases/download/boost-1.81.0/boost-1.81.0.tar.gz
    SHA1 f71f661f893f39b7b82d66c54980349716f874a2
)

hunter_config(ethash VERSION 1.0.0
    URL https://github.com/RavenCommunity/cpp-kawpow/archive/1.1.0.tar.gz
    SHA1 fff78f555a43900b6726c131305a71be769ef769
)