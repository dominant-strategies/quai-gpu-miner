#pragma once

#include <stdint.h>
#include <string>

// blocks before changing the random program
#define PROGPOW_PERIOD          10
// lanes that work together calculating a hash
#define PROGPOW_LANES           16
// uint32 registers per lane
#define PROGPOW_REGS            32
// uint32 loads from the DAG per lane
#define PROGPOW_DAG_LOADS       4
// size of the cached portion of the DAG
#define PROGPOW_CACHE_BYTES     (16*1024)
// DAG accesses, also the number of loops executed
#define PROGPOW_CNT_DAG         64
// random cache accesses per loop
#define PROGPOW_CNT_CACHE       11
// random math instructions per loop
#define PROGPOW_CNT_MATH        18

#define EPOCH_LENGTH            388800 // 4320 primes per day * 90 days

class ProgPow
{
public:
    typedef enum
    {
        KERNEL_CUDA,
        KERNEL_CL
    } kernel_t;


	static std::string getKern(std::string kernel_code, uint64_t seed, kernel_t kern);
    static void calculate_fast_mod_data(uint32_t divisor, uint32_t& reciprocal, uint32_t& increment, uint32_t& shift);
private:
    static std::string math(std::string d, std::string a, std::string b, uint32_t r);
    static std::string merge(std::string a, std::string b, uint32_t r);

    static uint32_t fnv1a(uint32_t &h, uint32_t d);
    // KISS99 is simple, fast, and passes the TestU01 suite
    // https://en.wikipedia.org/wiki/KISS_(algorithm)
    // http://www.cse.yorku.ca/~oz/marsaglia-rng.html
    typedef struct {
        uint32_t z, w, jsr, jcong;
    } kiss99_t;
    static uint32_t kiss99(kiss99_t &st);

    static uint32_t clz(uint32_t a)
    {
#ifdef _MSC_VER
        unsigned long index;
        _BitScanReverse(&index, a);
        return 31 - index;
#else
        return __builtin_clz(a);
#endif
    }
};
