//
// Created on 2023/6/5.
//

#ifndef VCBASEKIT_TIME_UTIL_H
#define VCBASEKIT_TIME_UTIL_H

#include "vcbkit.h"
#include "attributes.h"
#include <cstdint>
#include <type_traits>


VCB_NAMESPACE_BEGIN

class VCBASEKIT_PUBLIC TimeDelta {

public:
    constexpr TimeDelta() = default;
    static constexpr TimeDelta zero() { return {};}
    static constexpr TimeDelta fromNanoseconds(int64_t nanos) {
        return TimeDelta(nanos);
    }
    static constexpr TimeDelta fromMicroseconds(int64_t micros) {
        return fromNanoseconds(micros * 1000);
    }
    static constexpr TimeDelta fromMilliseconds(int64_t millis) {
        return fromMicroseconds(millis * 1000);
    }
    static constexpr TimeDelta fromSeconds(int64_t seconds) {
        return fromMilliseconds(seconds * 1000);
    }

    VCB_NODISCARD constexpr int64_t toNanoseconds() const { return mDelta; }
    VCB_NODISCARD constexpr double toMillisecondsF() const {
        return static_cast<double>(mDelta) / (1000.0 * 1000.0);
    }
    VCB_NODISCARD constexpr double toSecondsF() const {
        return static_cast<double>(mDelta) / (1000.0 * 1000.0 * 1000.0);
    }

    bool operator>=(const TimeDelta& o) const {
        return mDelta >= o.mDelta;
    }

    bool operator>(const TimeDelta& o) const {
        return mDelta > o.mDelta;
    }

    constexpr TimeDelta operator-(const TimeDelta &o) const {
        return TimeDelta(mDelta - o.mDelta);
    }

    constexpr bool operator==(const TimeDelta &o) const {
        return mDelta == o.mDelta;
    }
private:
    explicit constexpr TimeDelta(int64_t delta):mDelta(delta){}
    int64_t mDelta = 0;
};


namespace Clock {
    class System;
    class Steady;
    class Fast1; // Is MONOTONIC
    // class Fast2; // Is MONOTONIC
    // class Fast3; // Is MONOTONIC
}

template <typename C = Clock::Fast1,
        typename = std::enable_if_t<
                std::is_same_v<Clock::System, C> ||
                std::is_same_v<Clock::Steady, C> ||
                std::is_same_v<Clock::Fast1, C>>>
class VCBASEKIT_PUBLIC TimePoint {

public:
    
    bool operator!=(TimePoint o) const {
        return mTicks != o.mTicks;
    }

    bool operator==(TimePoint o) const {
        return mTicks == o.mTicks;
    }

    bool operator<=(TimePoint o) const {
        return mTicks <= o.mTicks;
    }

    bool operator<(TimePoint o) const {
        return mTicks < o.mTicks;
    }

    bool operator>=(TimePoint o) const {
        return mTicks >= o.mTicks;
    }

    bool operator>(TimePoint o) const {
        return mTicks > o.mTicks;
    }


    TimeDelta operator-(TimePoint other) const {
        return TimeDelta::fromNanoseconds(mTicks - other.mTicks);
    }

    TimePoint operator+(TimeDelta delta) const {
        return TimePoint(mTicks + delta.toNanoseconds());
    }
    TimePoint operator-(TimeDelta delta) const {
        return TimePoint(mTicks - delta.toNanoseconds());
    }

    VCB_NODISCARD TimeDelta toEpochDelta() const { return TimeDelta::fromNanoseconds(mTicks); }

    static TimePoint now();

    static constexpr TimePoint min() {
        return TimePoint(INT64_MIN);
    }
    static constexpr TimePoint max() {
        return TimePoint(INT64_MAX);
    }

    constexpr TimePoint() = default;
private:
    explicit constexpr TimePoint(int64_t ticks):mTicks(ticks){}
    int64_t mTicks = 0;
};

template <>
VCBASEKIT_PUBLIC TimePoint<Clock::System> TimePoint<Clock::System>::now();

template <>
VCBASEKIT_PUBLIC TimePoint<Clock::Steady> TimePoint<Clock::Steady>::now();

template <>
VCBASEKIT_PUBLIC TimePoint<Clock::Fast1> TimePoint<Clock::Fast1>::now();

inline TimePoint<Clock::Steady> TimeNowSteady() {
    return TimePoint<Clock::Steady>::now();
}

inline TimePoint<Clock::System> TimeNowSystem() {
    return TimePoint<Clock::System>::now();
}

inline TimePoint<Clock::Fast1> TimeNowFast1() {
    return TimePoint<Clock::Fast1>::now();
}


VCB_NAMESPACE_END

#endif // VCBASEKIT_TIME_UTIL_H
