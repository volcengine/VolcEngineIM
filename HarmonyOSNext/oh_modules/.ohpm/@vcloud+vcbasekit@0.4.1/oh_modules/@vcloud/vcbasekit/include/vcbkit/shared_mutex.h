//
// Created on 2024/4/09.
//

#ifndef VCBASEKIT_SHARED_MUTEX_H
#define VCBASEKIT_SHARED_MUTEX_H

#include "attributes.h"
#include "vcbkit.h"
#include "mutex.h"

VCB_NAMESPACE_BEGIN

/// @cond HIDDEN_SYMBOLS

#if __ANDROID__
    #if defined(__LP64__)
        #define VCBKIT_SHARED_MUTEX_SIZE 56
    #else
        #define VCBKIT_SHARED_MUTEX_SIZE 40
    #endif
    #define VCBKIT_SHARED_MUTEX_ALIGN sizeof(int)
#elif __MACH__
    #if defined(__LP64__)
        #define VCBKIT_SHARED_MUTEX_SIZE 200
    #else
        #define VCBKIT_SHARED_MUTEX_SIZE 128
    #endif
    #define VCBKIT_SHARED_MUTEX_ALIGN sizeof(void*)
#elif __OHOS__
    #if defined(__LP64__)
        #define VCBKIT_SHARED_MUTEX_SIZE 56
    #else
        #define VCBKIT_SHARED_MUTEX_SIZE 32
    #endif
    #define VCBKIT_SHARED_MUTEX_ALIGN sizeof(void*)
#elif __WINDOWS__
    #if defined(_WIN64)
        #define VCBKIT_SHARED_MUTEX_SIZE 8
    #else
        #define VCBKIT_SHARED_MUTEX_SIZE 4
    #endif
    #define VCBKIT_SHARED_MUTEX_ALIGN sizeof(void*)
#elif __linux__
    #if defined(__LP64__)
        #define VCBKIT_SHARED_MUTEX_SIZE 56
    #endif
    #define VCBKIT_SHARED_MUTEX_ALIGN sizeof(void*)
    // linux 32-bit not support
#endif

typedef struct alignas(VCBKIT_SHARED_MUTEX_ALIGN) {
    char opaque[VCBKIT_SHARED_MUTEX_SIZE];
} SharedMutexT;

/// @endcond

/*
 * @brief A cross platform shared mutex without using std library
 */ 
class VCBASEKIT_PUBLIC SHARED_CAPABILITY("mutex") SharedMutex final {

public:

    SharedMutex();
    ~SharedMutex();

    /**
     * @brief Acquire the lock on the mutex
     * 
     */
    void lock() ACQUIRE();

    /**
    * Attempts to acquire the lock on the mutex.
    * 
    * @return true if the lock was acquired successfully, false otherwise.
    */
    bool tryLock() TRY_ACQUIRE(true);

    /**
     * @brief Release the lock on the mutex
     */
    void unlock() RELEASE();

    /**
     * @brief Acquire the shared lock on the mutex
     */
    void lockShared() ACQUIRE_SHARED();

    /*
     * @brief Attempts to acquire the shared lock on the mutex
     *
     * @retuen true if the lock was acquired successfully, false otherwise.
     */
    bool tryLockShared() TRY_ACQUIRE_SHARED(true);

    /*
     * @brief Release the Shared lock on the mutex
     */
    void unlockShared() RELEASE_SHARED();

private:
    SharedMutexT mutex;
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(SharedMutex);
};

static_assert(sizeof(SharedMutex) == sizeof(SharedMutexT), "size must match");


VCB_NAMESPACE_END


#endif