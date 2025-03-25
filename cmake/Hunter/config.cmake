hunter_config(CURL VERSION ${HUNTER_CURL_VERSION} CMAKE_ARGS HTTP_ONLY=ON CMAKE_USE_OPENSSL=ON CMAKE_USE_LIBSSH2=OFF CURL_CA_PATH=none)
hunter_config(Boost VERSION 1.70.0-p2
    URL https://github.com/guruchaithanya/boost/archive/refs/tags/v1.70.0-p2.tar.gz
    SHA1 a417cde3d9c8ce29c7350eb4e844ae835f594635
)

hunter_config(ethash VERSION 1.0.0
    URL https://github.com/RavenCommunity/cpp-kawpow/archive/1.1.0.tar.gz
    SHA1 fff78f555a43900b6726c131305a71be769ef769
)
