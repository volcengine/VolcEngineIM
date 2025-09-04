//
// Created on 2023/8/24.
//

#ifndef VCBASEKIT_MUTEX_H
#define VCBASEKIT_MUTEX_H

/// @cond HIDDEN_SYMBOLS

// Enable thread safety attributes only with clang.
// The attributes can be safely erased when compiling with other compilers.
#if defined(__clang__) && (!defined(SWIG))
 #if defined(__WINDOWS__)
    #define THREAD_ANNOTATION_ATTRIBUTE__(x)   // no-op
 #else
    #define THREAD_ANNOTATION_ATTRIBUTE__(x)   __attribute__((x))
 #endif
#else
#define THREAD_ANNOTATION_ATTRIBUTE__(x)   // no-op
#endif

#define CAPABILITY(x) \
  THREAD_ANNOTATION_ATTRIBUTE__(capability(x))

#define SHARED_CAPABILITY(x) \
  THREAD_ANNOTATION_ATTRIBUTE__(shared_capability(x))

#define SCOPED_CAPABILITY \
  THREAD_ANNOTATION_ATTRIBUTE__(scoped_lockable)

#define GUARDED_BY(x) \
  THREAD_ANNOTATION_ATTRIBUTE__(guarded_by(x))

#define PT_GUARDED_BY(x) \
  THREAD_ANNOTATION_ATTRIBUTE__(pt_guarded_by(x))

#define ACQUIRED_BEFORE(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(acquired_before(__VA_ARGS__))

#define ACQUIRED_AFTER(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(acquired_after(__VA_ARGS__))

#define REQUIRES(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(requires_capability(__VA_ARGS__))

#define REQUIRES_SHARED(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(requires_shared_capability(__VA_ARGS__))

#define ACQUIRE(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(acquire_capability(__VA_ARGS__))

#define ACQUIRE_SHARED(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(acquire_shared_capability(__VA_ARGS__))

#define RELEASE(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(release_capability(__VA_ARGS__))

#define RELEASE_SHARED(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(release_shared_capability(__VA_ARGS__))

#define RELEASE_GENERIC(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(release_generic_capability(__VA_ARGS__))

#define TRY_ACQUIRE(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(try_acquire_capability(__VA_ARGS__))

#define TRY_ACQUIRE_SHARED(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(try_acquire_shared_capability(__VA_ARGS__))

#define EXCLUDES(...) \
  THREAD_ANNOTATION_ATTRIBUTE__(locks_excluded(__VA_ARGS__))

#define ASSERT_CAPABILITY(x) \
  THREAD_ANNOTATION_ATTRIBUTE__(assert_capability(x))

#define ASSERT_SHARED_CAPABILITY(x) \
  THREAD_ANNOTATION_ATTRIBUTE__(assert_shared_capability(x))

#define RETURN_CAPABILITY(x) \
  THREAD_ANNOTATION_ATTRIBUTE__(lock_returned(x))

#define NO_THREAD_SAFETY_ANALYSIS \
  THREAD_ANNOTATION_ATTRIBUTE__(no_thread_safety_analysis)

/// @endcond

#include "attributes.h"
#include "time_util.h"
#include "vcbkit.h"


VCB_NAMESPACE_BEGIN

/// @cond HIDDEN_SYMBOLS

#if __ANDROID__
    #if defined(__LP64__)
        #define VCBKIT_MUTEX_SIZE 40
        #define VCBKIT_COND_VAR_SIZE 48
    #else
        #define VCBKIT_MUTEX_SIZE 4
        #define VCBKIT_COND_VAR_SIZE 4
    #endif
    #define VCBKIT_MUTEX_ALIGN sizeof(int)
    #define VCBKIT_COND_VAR_ALIGN sizeof(int)
#elif __MACH__
    #if defined(__LP64__)
        #define VCBKIT_MUTEX_SIZE 64
        #define VCBKIT_COND_VAR_SIZE 48
    #else
        #define VCBKIT_MUTEX_SIZE 44
        #define VCBKIT_COND_VAR_SIZE 28
    #endif
    #define VCBKIT_MUTEX_ALIGN sizeof(void*)
    #define VCBKIT_COND_VAR_ALIGN sizeof(void*)
#elif __OHOS__
    #if defined(__LP64__)
        #define VCBKIT_MUTEX_SIZE 40
        #define VCBKIT_COND_VAR_SIZE 48
    #else
        #define VCBKIT_MUTEX_SIZE 24
        #define VCBKIT_COND_VAR_SIZE 48
    #endif
    #define VCBKIT_MUTEX_ALIGN sizeof(void*)
    #define VCBKIT_COND_VAR_ALIGN sizeof(void*)
#elif __WINDOWS__
    #if defined(_WIN64)
        #define VCBKIT_MUTEX_SIZE 40
        #define VCBKIT_COND_VAR_SIZE 8
    #else
        #define VCBKIT_MUTEX_SIZE 24
        #define VCBKIT_COND_VAR_SIZE 4
    #endif
    #define VCBKIT_MUTEX_ALIGN sizeof(void*)
    #define VCBKIT_COND_VAR_ALIGN sizeof(void*)
#elif __linux__
    #if defined(__LP64__)
        #define VCBKIT_MUTEX_SIZE 40
        #define VCBKIT_COND_VAR_SIZE 48
    #endif
    #define VCBKIT_MUTEX_ALIGN sizeof(void*)
    #define VCBKIT_COND_VAR_ALIGN sizeof(void*)
    // linux 32-bit not support
#endif

typedef struct alignas(VCBKIT_MUTEX_ALIGN) {
    char opaque[VCBKIT_MUTEX_SIZE];
} MutexT;
typedef struct alignas(VCBKIT_COND_VAR_ALIGN) {
    char opaque[VCBKIT_COND_VAR_SIZE];
} CondVarT;

/// @endcond

class CondVar;


/**
 * @brief A cross platform mutex without using std library
 */
class VCBASEKIT_PUBLIC CAPABILITY("mutex") Mutex final {

public:

    Mutex();
    ~Mutex();

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

private:
    MutexT mutex;
    friend class CondVar;
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(Mutex);
};

static_assert(sizeof(Mutex) == sizeof(MutexT), "size must match");


/**
 * @brief A cross platform condition variable without using std library
 */
class VCBASEKIT_PUBLIC CondVar final {

public:
    CondVar();
    ~CondVar();

    void wait(Mutex& m) REQUIRES(m);
  
    /**
     * return true if not get signal, include timeout and error.
     * If delta <= 0, waitTimeout returns true immediately
     */
    bool waitTimeout(Mutex& m, const TimeDelta &delta) REQUIRES(m);

    /**
     * if delta <= 0, this method wait until get signal, like wait().
     * <br>
     * else this method wait with timeout, like waitTimeout()
     */
    bool waitOrTimeout(Mutex &m, const TimeDelta &delta) REQUIRES(m) {
        if (delta > TimeDelta::zero()) {
            return waitTimeout(m, delta);
        } else {
            wait(m);
            return false;
        }
    }

    void signal();
    void signalAll();
private:
    CondVarT condvar;
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(CondVar);
};

static_assert(sizeof(CondVar) == sizeof(CondVarT), "size must match");


VCB_NAMESPACE_END

#endif // VCBASEKIT_MUTEX_H
