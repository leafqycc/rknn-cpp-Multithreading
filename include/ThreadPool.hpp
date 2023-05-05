#ifndef THREADPOOL_H
#define THREADPOOL_H

#include <cassert>
#include <condition_variable>
#include <functional>
#include <future>
#include <memory>
#include <mutex>
#include <queue>
#include <thread>
#include <unordered_map>

namespace dpool
{

    class ThreadPool
    {
    public:
        using MutexGuard = std::lock_guard<std::mutex>;
        using UniqueLock = std::unique_lock<std::mutex>;
        using Thread = std::thread;
        using ThreadID = std::thread::id;
        using Task = std::function<void()>;

        ThreadPool()
            : ThreadPool(Thread::hardware_concurrency())
        {
        }

        explicit ThreadPool(size_t maxThreads)
            : quit_(false),
              currentThreads_(0),
              idleThreads_(0),
              maxThreads_(maxThreads)
        {
        }

        // disable the copy operations
        ThreadPool(const ThreadPool &) = delete;
        ThreadPool &operator=(const ThreadPool &) = delete;

        ~ThreadPool()
        {
            {
                MutexGuard guard(mutex_);
                quit_ = true;
            }
            cv_.notify_all();

            for (auto &elem : threads_)
            {
                assert(elem.second.joinable());
                elem.second.join();
            }
        }

        template <typename Func, typename... Ts>
        auto submit(Func &&func, Ts &&...params)
            -> std::future<typename std::result_of<Func(Ts...)>::type>
        {
            auto execute = std::bind(std::forward<Func>(func), std::forward<Ts>(params)...);

            using ReturnType = typename std::result_of<Func(Ts...)>::type;
            using PackagedTask = std::packaged_task<ReturnType()>;

            auto task = std::make_shared<PackagedTask>(std::move(execute));
            auto result = task->get_future();

            MutexGuard guard(mutex_);
            assert(!quit_);

            tasks_.emplace([task]()
                           { (*task)(); });
            if (idleThreads_ > 0)
            {
                cv_.notify_one();
            }
            else if (currentThreads_ < maxThreads_)
            {
                Thread t(&ThreadPool::worker, this);
                assert(threads_.find(t.get_id()) == threads_.end());
                threads_[t.get_id()] = std::move(t);
                ++currentThreads_;
            }

            return result;
        }

        size_t threadsNum() const
        {
            MutexGuard guard(mutex_);
            return currentThreads_;
        }

    private:
        void worker()
        {
            while (true)
            {
                Task task;
                {
                    UniqueLock uniqueLock(mutex_);
                    ++idleThreads_;
                    auto hasTimedout = !cv_.wait_for(uniqueLock,
                                                     std::chrono::seconds(WAIT_SECONDS),
                                                     [this]()
                                                     {
                                                         return quit_ || !tasks_.empty();
                                                     });
                    --idleThreads_;
                    if (tasks_.empty())
                    {
                        if (quit_)
                        {
                            --currentThreads_;
                            return;
                        }
                        if (hasTimedout)
                        {
                            --currentThreads_;
                            joinFinishedThreads();
                            finishedThreadIDs_.emplace(std::this_thread::get_id());
                            return;
                        }
                    }
                    task = std::move(tasks_.front());
                    tasks_.pop();
                }
                task();
            }
        }

        void joinFinishedThreads()
        {
            while (!finishedThreadIDs_.empty())
            {
                auto id = std::move(finishedThreadIDs_.front());
                finishedThreadIDs_.pop();
                auto iter = threads_.find(id);

                assert(iter != threads_.end());
                assert(iter->second.joinable());

                iter->second.join();
                threads_.erase(iter);
            }
        }

        static constexpr size_t WAIT_SECONDS = 2;

        bool quit_;
        size_t currentThreads_;
        size_t idleThreads_;
        size_t maxThreads_;

        mutable std::mutex mutex_;
        std::condition_variable cv_;
        std::queue<Task> tasks_;
        std::queue<ThreadID> finishedThreadIDs_;
        std::unordered_map<ThreadID, Thread> threads_;
    };

    constexpr size_t ThreadPool::WAIT_SECONDS;

} // namespace dpool

#endif /* THREADPOOL_H */