//
// Created on 2023/5/18.
//

#ifndef VCBASEKIT_THREAD_H
#define VCBASEKIT_THREAD_H

#include <cstring>
#include "attributes.h"
#include "base_ref.h"
#include "ref_ptr.h"
#include "vcbkit.h"
#include "compat.h"
#include "function.h"
#include "time_util.h"

VCB_NAMESPACE_BEGIN

/**
 * The <code>Block</code> interface should be implemented by any
 * class whose instances are intended to be executed by a Thread. The
 * class must define a method of no arguments called run().
 * <p>
 * This interface is designed to provide a common protocol for objects that
 * wish to execute code. For example, Block is implemented by class Thread.
 */
class VCBASEKIT_PUBLIC Block : virtual public BaseRef {
public:
    virtual int run() = 0;
};

/**
 * ThreadEnv is a pure abstract interface for thread environment manager.
 * @see Thread ThreadHelper
 */
class VCBASEKIT_PUBLIC ThreadEnv : public BaseRef {
public:
    /**
     * setup resource before thread execute a Block.
     */
    virtual void setup() = 0;

    /**
     * cleanup  resource after thread execute a Block.
     */
    virtual void cleanup() = 0;
};

class ThreadHelper;
class ThreadPool;

/**
 * Thread wrap system thread to robust and easy use API.
 * <p>
 * Construct Thread need a Block parameter,
 * Thread start a os thread, setup resource, and then execute the Block,
 * finally, Thread cleanup the resource.
 * @attention This class is thread-safe.
 * @see ThreadHelper
 */
class VCBASEKIT_PUBLIC Thread : public Block, public AnyCall {

public:

    enum VCBASEKIT_PUBLIC Priority : int {
        /**
         * Unspecified priority.
         * On Android, new thread inherit it's parent thread thread.
         * On Apple, new thread is always PriorityDefault
         */
        PriorityUnspecified = 0,

        PriorityLow = 1,
        PriorityUtility = 2,
        PriorityDefault = 3,
        PriorityHigh = 4,
        PriorityHigher = 5,
        PriorityCritical = 6,
    };

    class This {
    public:
        /**
         * return the thread id of current thread.
         * This method is useful when Thread::current return null;
         */
        static uint64_t getId();
        This() = delete;
    private:
        VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(This);
    };
public:

    /**
     * Check if thread is running on current thread.
     */
    VCB_NODISCARD virtual bool isCurrent() const = 0;

    /**
     * Set priority of the current thread.
     */
    void setPriority(Thread::Priority priority);

    /**
     * Blocks the calling thread until the thread identified by <code>*this</code>
     * finished its input Block::run execution.
     * If thread is already finished, this method return immediately
     */
    virtual void join() = 0;

    /**
     * Same as join, but with timeout.
     * If thread is already finished, this method return true immediately
     * @param delta The time delta to be waiting.
     * @return true if thread finished within timeout, else return false
     * @see join
     */
    bool tryJoin(TimeDelta delta);

    /**
     * Non-blocking method, return the thread id.
     * If a thread is just created but not running, we can't get is thread id.
     * In this case, this method return 0.
     * @return the native thread id, or 0 if thread is not ready
     */
    virtual uint64_t getId() const = 0;

    /**
     * Get smart pointer of Thread if the calling thread is create from Thread.
     * @return null if current thread is not create from Thread, such as main thread,
     * else return the smart pointer of current instance of Thread
     */
    static RefPtr<Thread> current();

protected:
    /**
     * Thread is pure abstract class, this constructor is used by subclass
     */
    Thread() = default;

    virtual int start() = 0;

    virtual void release() = 0;

    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(Thread);

    friend class ThreadHelper;
    friend class ThreadPoolHelper;
};
#if defined(__WINDOWS__)
static_assert(sizeof(Thread) == sizeof(void*)*5);
#else
static_assert(sizeof(Thread) == sizeof(void*)*4);
#endif

/**
 * Builder for ThreadAttr flags
 */
class VCBASEKIT_PUBLIC ThreadFlags final {
private:
    int64_t flags {0};
    friend struct ThreadAttr;
    explicit ThreadFlags(int64_t flags): flags(flags) {};
public:
    ThreadFlags() = default;

    ThreadFlags& withPriority(Thread::Priority priority) {
        flags = (flags >> 4 << 4) | priority;
        return *this;
    }
    /**
     * @brief enable jni env auto cache and cleanup for a thread
     *
     * @return ThreadFlags& return self
     */
    ThreadFlags& autoJniEnv() {
        flags = flags | 0x10;
        return *this;
    }

    ThreadFlags& reportHangs() {
        flags = flags | 0x20;
        return *this;
    }
};

struct VCBASEKIT_PUBLIC ThreadAttr final {
public: // this should be private
    /// @cond HIDDEN_SYMBOLS

    size_t stackSize{0};

    /**
     * bit flags
     * ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- xxxx,  low 4 bits used for thread priority.
     * ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---x ----,  5th bit used for android thread jni env.
     * ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --x- ----,  6th bit used for report thread hangs
     */
    int    flags{0};
    char   name[16]{};

    /// @endcond

public:
    /**
     * @brief Construct a new ThreadAttr object with defult value
     */
    ThreadAttr();

    /**
     * @brief Construct a new ThreadAttr object
     *
     * @param stackSize If don't want change stacksize, set it 0.
     * @param name Name of the thread.
     */
    ThreadAttr(int stackSize, const char *name);

    /**
     * @brief Construct a new ThreadAttr object
     *
     * @param stackSize If don't want change stacksize, set it 0.
     * @param name Name of the thread.
     * @param flags @see ThreadFlags
     */
    ThreadAttr(int stackSize, const char *name, const ThreadFlags& flags);

private:

    friend class Thread;
    friend class PThread;
    friend class ReuseThread;
    friend class PoolThread;
    friend class ThreadBase;
    friend class ThreadPool;

    VCB_NODISCARD inline bool isAutoJniEnv() const {
        return flags & 0x10;
    }

    VCB_NODISCARD inline bool isReportHangs() const {
        return flags & 0x20;
    }

    VCB_NODISCARD inline Thread::Priority getPriority() const {
        return static_cast<Thread::Priority>(flags & 0xF);
    }

    VCB_NODISCARD inline ThreadFlags getFlags() const {
        return ThreadFlags(flags);
    }
};
static_assert(sizeof(ThreadAttr) == sizeof(size_t)*2+ sizeof(char)*16);


/**
 * FunBlock convert a lambda function to Block.
 */
class FunBlock: public Block {
public:
    /**
     * Convert lambda into Block. For example:
     * @code
     * auto blk = RefPtr<FunBlock>::makeNew([]{
     *      print("hello block");
     * });
     * @endcode
     */
    FunBlock(const Function<void()> &f):fun(f){} // NOLINT(*-explicit-constructor)

private:
    int run() override {
        fun();
        return 0;
    }
private:
    Function<void()> fun;
};

/**
 * @see Thread ThreadPoolHelper
 */
class VCBASEKIT_PUBLIC ThreadHelper {
public:
    static void runBlk(const RefPtr<Block> &blk);
    static void runBlk(const Function<void()> &f);
    static int startThread(RefPtr<Thread> &thread, const RefPtr<Block> &blk);

    static int startThread(RefPtr<Thread> &thread,
                           const RefPtr<Block> &blk,
                           const ThreadAttr &attr,
                           const RefPtr<ThreadEnv> &env);
};

VCB_NAMESPACE_END

#endif // VCBASEKIT_THREAD_H
