//
// Created on 2023/7/11.
//

#ifndef VCBASEKIT_THREAD_POOL_HELPER_H
#define VCBASEKIT_THREAD_POOL_HELPER_H

#include "thread.h"
#include "attributes.h"
#include "time_util.h"

VCB_NAMESPACE_BEGIN

class ThreadPool;

/**
 * @see ThreadPoolHelper
 */
class VCBASEKIT_PUBLIC ThreadPoolMgr : public BaseRef {
public:
    /**
     * This delegate is called at the beginning of get thread from pool
     */
    virtual void onTake() = 0;

    /**
     * This delegate is called at the end if giveback a thread to pool
     */
    virtual void onBack() = 0;
};


/**
 * @brief 
 * @attention This class is thread-safe.
 * @see Thread ThreadHelper
 */
class VCBASEKIT_PUBLIC ThreadPoolHelper {
public:

    explicit ThreadPoolHelper(int maxSize);
    ThreadPoolHelper(int maxSize, int stackSize, const char *idleName);
    ~ThreadPoolHelper();

    void runBlk(const RefPtr<Block> &blk);
    void runBlk(const Function<void()> &f);

    int startThread(RefPtr<Thread> &thread, const RefPtr<Block> &blk);

    int startThread(RefPtr<Thread> &thread, const RefPtr<Block> &blk,
                    const ThreadAttr &attr, const RefPtr<ThreadEnv> &env);

    void setPoolMgr(const RefPtr<ThreadPoolMgr> &mgr);

    /**
     * Get the size of free thread queue
     */
    VCB_NODISCARD size_t getFreeCount() const;

    /*
     * Get the busy thread count.
     * each thread get from pool, the busy count++
     * each thread giveback to pool, the busy count--
     */
    VCB_NODISCARD size_t getBusyCount() const;

    /**
     * Get the free timedelta for a free thread.
     * The time is started when thread giveback to pool.
     * The thread in free queue is sorted by the giveback time.
     * @param index A python array style index, negative value is allowed. -1 return the last thread
     */
    TimeDelta getFreeDelta(int index);

    /**
     * Allow new Thread and save to the free thread queue.
     * @param num The count of threads to alloc
     */
    void fillThreads(size_t num);

    /**
     * Remove threads from the free thread queue.
     * @param num The count of threads to be removed.
     */
    void shrinkThreads(size_t num);

    VCB_DISALLOW_COPY_ASSIGN_AND_MOVE(ThreadPoolHelper);
private:
    RefPtr<ThreadPool> mPool;
};

VCB_NAMESPACE_END

#endif // VCBASEKIT_THREAD_POOL_HELPER_H
