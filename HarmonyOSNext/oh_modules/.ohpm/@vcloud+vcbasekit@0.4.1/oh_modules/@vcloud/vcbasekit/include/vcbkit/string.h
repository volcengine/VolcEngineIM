//
// Created on 2023/9/21.
//

#ifndef VCBASEKIT_STRING_H
#define VCBASEKIT_STRING_H

#include "vcbkit.h"
#include "attributes.h"
#include "debug.h"

#include <iterator>
#include <string>

VCB_NAMESPACE_BEGIN




/**
 *
 */
class StringView {
private:
    const char* mData;
    size_t mSize;

public:
    using value_type = char;
    using iterator = const char*;


    constexpr StringView() noexcept : mData(nullptr), mSize(0){}

    /**
     * Constructs a string reference object from a C string and a size.
     */
    constexpr StringView(const char* s, size_t count) noexcept : mData(s), mSize(count){}

    // NOLINTNEXTLINE(*-explicit-constructor)
    constexpr inline StringView(const char* s): mData(s), mSize(std::char_traits<char>::length(s)){}

    // NOLINTNEXTLINE(*-explicit-constructor)
    StringView(const std::string& str): mData(str.c_str()), mSize(str.size()) {}

    /** Returns a pointer to the string data. */
    VCB_NODISCARD constexpr auto data() const noexcept -> const char* { return mData; }

    /** Returns the string size. */
    VCB_NODISCARD constexpr auto size() const noexcept -> size_t { return mSize; }

    VCB_NODISCARD constexpr auto begin() const noexcept -> iterator { return mData; }
    VCB_NODISCARD constexpr auto end() const noexcept -> iterator { return mData + mSize; }

    constexpr auto operator[](size_t pos) const noexcept -> const char & {
        return mData[pos];
    }

    constexpr void removePrefix(size_t n) noexcept {
        mData += n;
        mSize -= n;
    }

    VCB_NODISCARD constexpr bool startsWith(char c) const noexcept {
        return mSize >= 1 && std::char_traits<char>::eq(c, *mData);
    }

    VCB_NODISCARD constexpr bool startsWith(StringView sv) const noexcept {
        return mSize >= sv.mSize &&
               std::char_traits<char>::compare(mData, sv.mData, sv.mSize) == 0;
    }

    constexpr bool startsWith(const char *s) const {
        return startsWith(StringView(s));
    }
    
    constexpr auto compare(const StringView &other) const -> int {
        size_t str_size = mSize < other.mSize ? mSize : other.mSize;
        int result = std::char_traits<char>::compare(mData, other.mData, str_size);
        if (result == 0)
            result = mSize == other.mSize ? 0 : (mSize < other.mSize ? -1 : 1);
        return result;
    }
    
    friend auto operator==(const StringView &lhs, const StringView &rhs) -> bool {
        return lhs.compare(rhs) == 0;
    }
    
    friend auto operator!=(const StringView &lhs, const StringView &rhs) -> bool {
        return lhs.compare(rhs) != 0;
    }
    friend auto operator<(const StringView &lhs, const StringView &rhs) -> bool {
        return lhs.compare(rhs) < 0;
    }
    friend auto operator<=(const StringView &lhs, const StringView &rhs) -> bool {
        return lhs.compare(rhs) <= 0;
    }
    friend auto operator>(const StringView &lhs, const StringView &rhs) -> bool {
        return lhs.compare(rhs) > 0;
    }
    friend auto operator>=(const StringView &lhs, const StringView &rhs) -> bool {
        return lhs.compare(rhs) >= 0;
    }
};

// Converts a compile-time string to basic_string_view.
template <size_t N>
constexpr auto compile_string_to_view(const char (&s)[N])
        -> StringView {
    // Remove trailing NUL character if needed. Won't be present if this is used
    // with a raw character array (i.e. not defined as a string).
    // constexpr char end = std::char_traits<char>::to_int_type(s[N - 1]);
    return {s, N - (std::char_traits<char>::to_int_type(s[N - 1]) == 0 ? 1 : 0)};
}

class VCBASEKIT_PUBLIC String {

public:
    typedef const char * const_iterator;
    typedef std::reverse_iterator<const_iterator> const_reverse_iterator;

    static constexpr size_t npos = size_t(-1);

public:

    /**
     * Construct String from char*
     * @param data, the input char*, must be '\0' terminator.
     */
    static String fromChars(const char *data);

    static String fromStd(const std::string &str) {
        return {str.c_str(), str.size()};
    }

public:
    String();
    String(const char *data, size_t size);
    String(const String& rhs);
    String(String&& goner) noexcept;
    String& operator=(const String& rhs);
    String& operator=(String&& goner) noexcept;

    ~String() noexcept;

    VCB_NODISCARD size_t size() const;
    VCB_NODISCARD size_t length() const {
        return size();
    }
    VCB_NODISCARD bool empty() const { return size() == 0; }
    VCB_NODISCARD size_t capacity() const;

    VCB_NODISCARD const char* c_str() const;
    VCB_NODISCARD const char* data() const {
        return c_str();
    }

    VCB_NODISCARD const_iterator begin() const { return c_str(); }
    VCB_NODISCARD const_iterator cbegin() const { return begin(); }
    VCB_NODISCARD const_iterator end() const { return c_str() + size(); }
    VCB_NODISCARD const_iterator cend() const { return end(); }

    VCB_NODISCARD const_reverse_iterator rbegin() const { return const_reverse_iterator(end()); }
    VCB_NODISCARD const_reverse_iterator rend() const { return const_reverse_iterator(begin()); }


    size_t find(const char* needle, size_t pos, size_t nsize) const;
    size_t find(const char* needle, size_t pos = 0) const {
        return find(needle, pos, std::char_traits<char>::length(needle));
    }
    VCB_NODISCARD size_t find(char c, size_t pos = 0) const {
        return find(&c, pos, 1);
    }

    void push_back(char c);
    void append(const String &str);
    void append(const StringView &sv);
    void append(const char* s, size_t n);

    void resize(size_t n, char c = 0);

    void clear() { resize(0); }

    std::string toStdString() {
        return {c_str(), size()};
    }

private:
    /// @cond HIDDEN_SYMBOLS
    class Layout {
        char *mData;
        size_t mSize;
        size_t mCap;
        friend class String;
        friend class StringCore;
    };
    /// @endcond


private:
    friend class StringCore;

    /// @cond HIDDEN_SYMBOLS
    union {
        uint8_t mBytes[sizeof(String::Layout)];
        char mSmall[sizeof(String::Layout)/sizeof(char)];
        String::Layout mML;
    };
    /// @endcond
    static_assert(sizeof(Layout) == 3 * sizeof(void*), "check size");

};

static_assert(sizeof(String) == 3 * sizeof(void*), "check size");



VCB_NAMESPACE_END

#endif // VCBASEKIT_STRING_H
