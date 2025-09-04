//
// Created on 2023/5/19.
//

#ifndef VCBASEKIT_WAIT_EVENT_H
#define VCBASEKIT_WAIT_EVENT_H

#include "vcbkit/vcbkit.h"
#include "vcbkit/mutex.h"
#include "vcbkit/base_ref.h"
#include "vcbkit/attributes.h"

VCB_NAMESPACE_BEGIN

class AutoWaitEvent;
class ManualWaitEvent;
class ScopedLock;
class ThreadBase;

/**
 * @attention WaitEvent is not exported as public symbols.
 * Please use AutoWaitEvent and ManualWaitEvent.
 */
class VCB_HELPER_HIDDEN WaitEvent final {

protected:
    WaitEvent() = default;

public:
    void signal() EXCLUDES(mMutex);

    void signalOnLock() REQUIRES(mMutex);

    void wait(bool reset = true) EXCLUDES(mMutex);

private:
    /**
     * Wait the signal with a timedelta
     * if signal not triggered after timedelta, this method return true[timeout reached of error occurs]
     *
     * @param reset if reset is true, when event is signaled,
     *                only one call of wait returns,
     *                others call of wait still hangs or return timeout
     *              else if reset is false, all wait[Timeout] will return when signal
     * @param delta The time delta to be waiting.
     * @return true if not get the signal, include timeout and error, else return false
     */
    bool waitTimeout(bool reset, const TimeDelta &delta) EXCLUDES(mMutex);

    void signalAll() EXCLUDES(mMutex);

    bool value() const EXCLUDES(mMutex);

private:
    CondVar mCond;
    mutable Mutex mMutex;
    volatile bool mSignaled GUARDED_BY(mMutex) = false;

    friend class ScopedLock;
    friend class ManualWaitEvent;
    friend class AutoWaitEvent;
    friend class ThreadBase;

    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(WaitEvent);
};

/**
 * @brief An event that can be signaled and waited on. This automatically
 * returns to the unsignaled state after unblocking one waiter.
 * @see ManualWaitEvent
 * @attention This class is thread-safe.
 */
class VCBASEKIT_PUBLIC AutoWaitEvent final{
public:
    AutoWaitEvent() = default;

    /**
     * Put the event in the signaled state. Exactly one wait() will be unblocked,
     * or one waitTimeout() with false return value will be unblocked.
     * And the event will be returned to the unsignaled state.
     */
    void signal();

    /**
     * Blocks the calling thread until the event is signaled. Upon unblocking,
     * the event is returned to the unsignaled state
     */
    void wait();

    /**
     * Like wait(), but with a timeout.
     * The event is returned to the unsignaled state if it return false
     * @param delta The time delta to be waiting.
     * @return  it returns false in case with being signaled within \p delta,
     * otherwise returns true which include \p delta expires or some error occurs
     */
    bool waitTimeout(const TimeDelta &delta);
private:
    WaitEvent mImpl;
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(AutoWaitEvent);
};

/**
 * An event that can be signaled and waited on. This remains signaled
 * until explicitly reset.
 * @see AutoWaitEvent
 * @attention This class is thread-safe.
 */
class VCBASEKIT_PUBLIC ManualWaitEvent final {
public:
    ManualWaitEvent() = default;
    /**
     * Put the event in the signaled state.
     * It wakes one waiting threads (blocked on wait() or waitTimeout()).
     * After wakes waiting threads, it remains signaled.
     */
    void signal();

    /**
     * Put the event in the signaled state.
     * It wakes all waiting threads (blocked on wait() or waitTimeout()).
     * After wakes waiting threads, it remains signaled.
     */
    void signalAll();

    /**
     * Check if the event is signaled.
     * @return true if the event is signaled, false otherwise.
     */
    bool isSignaled() const;

    /**
     * Blocks the calling thread until the event is signaled.
     * If the event is already signaled, this return immediately without block.
     */
    void wait();

    /**
     * Like wait(), but with a timeout.
     * If the event is already signaled, this return false immediately without block.
     * @param delta The time delta to be waiting.
     * @return it returns false in case with being signaled within \p delta,
     * otherwise returns true which include \p delta expires or some error occurs
     */
    bool waitTimeout(const TimeDelta &delta);

    /**
     * Put the event into the unsignaled state.
     */
    void reset();
private:
    WaitEvent mImpl;
    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(ManualWaitEvent);
};

/**
 * An event that can be signaled and waited on.
 * The signal serial is monotonically increasing.
 * @attention This class is thread-safe.
 */
class SerialWaitEvent : public BaseRef {

public:
    SerialWaitEvent() = default;

    bool isSignaled(int serial) const;

    void signal(int serial);

    void signalAll(int serial);

    void wait(int serial);

    bool waitTimeout(int serial, const TimeDelta &delta);

private:
    CondVar mCond;
    mutable Mutex mMutex;
    int mSerial GUARDED_BY(mMutex) = 0;
};
VCB_NAMESPACE_END

#endif // VCBASEKIT_WAIT_EVENT_H
