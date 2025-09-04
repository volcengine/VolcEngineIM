//
// Created by Dancer on 2023/8/24.
//

#ifndef VCBASEKIT_LOCKER_H
#define VCBASEKIT_LOCKER_H

#include "mutex.h"
#include "wait_event.h"

VCB_NAMESPACE_BEGIN

/**
 * @brief A class that represents a scoped lock.
 * 
 * The ScopedLock class provides a convenient way to acquire and release a lock
 * on a mutex. It ensures that the lock is always released when
 * the ScopedLock object goes out of scope.
 *
 * @note This class is annotated with SCOPED_CAPABILITY, indicating that it acquires and releases a mutex.
 * @see ScopedABLock Mutex
 */
class VCBASEKIT_PUBLIC SCOPED_CAPABILITY ScopedLock final {
public:
    /**
     * @brief Constructs a ScopedLock object and acquires the specified mutex.
     * 
     * @param m The mutex to acquire.
     */
    explicit ScopedLock(Mutex& m) ACQUIRE(m);

    /**
     * @brief Destructor that releases the lock.
     */
    ~ScopedLock() RELEASE();

    /// @cond HIDDEN_SYMBOLS

    /**
     * @brief Constructs a ScopedLock object and acquires the mutex associated with the wait event.
     * 
     * @param we The wait event to acquire.
     */
    explicit ScopedLock(WaitEvent& we) ACQUIRE(we.mMutex);

    /// @endcond


    /**
     * @brief Releases the lock.
     */
    void drop() RELEASE();

private:
    Mutex* mutex;
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(ScopedLock);
};


/**
 * @brief A scoped lock that acquires and releases a mutex.
 *
 * This class provides a convenient way to acquire and release a mutex using a scoped approach.
 * It ensures that the mutex is always released, even in the case of an exception or early return.
 * The lock is acquired upon construction and released upon destruction.
 * 
 * @see ScopedLock Mutex
 */
class VCBASEKIT_PUBLIC SCOPED_CAPABILITY ScopedABLock final {
public:
    /**
     * @brief Constructs a ScopedABLock object and acquires the specified mutex.
     *
     * @param m The mutex to acquire.
     * @param lock Whether to acquire the mutex upon construction. Default is true.
     *             If set to false, the mutex will not be acquired upon construction.
     */
    explicit ScopedABLock(Mutex& m, bool lock = true) ACQUIRE(m);

    /**
     * @brief Destructor that releases the mutex if it was acquired upon construction.
     */
    ~ScopedABLock() RELEASE();

    /**
     * @brief Releases the acquired mutex if it was acquired upon construction.
     */
    void drop() RELEASE();

private:
    Mutex* mutex { nullptr }; // The mutex being acquired and released.
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(ScopedABLock);
};


template <typename T>
class Locker;

template <typename T>
class Locked final {
private:
    Locked(T& value, Mutex& m) :mValue(value),mMutex(m) {
        mMutex.lock();
    }

public:
    ~Locked() {
        mMutex.unlock();
    }

    Locked(const Locked &) = delete;
    Locked(Locked &&) = delete;

    T& unwrap() {
       return mValue;
    }

    template <typename F>
    friend class Locker;
private:
    T& mValue;
    Mutex& mMutex;
};

template <typename T>
class Locker final {

public:
    Locker() = default;

    Locked<T> asLock()  {
        return {mValue, mMutex};
    }

    Locked<const T> asLock() const {
        return {mValue, mMutex};
    }
private:
    T mValue;
    mutable Mutex mMutex;
};

VCB_NAMESPACE_END

#endif // VCBASEKIT_LOCKER_H
