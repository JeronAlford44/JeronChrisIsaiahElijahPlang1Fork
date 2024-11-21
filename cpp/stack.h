// A class for an expandable stack. There is already a stack class in the
// Standard C++ Library; this class serves as an exercise for students to
// learn the mechanics of building generic, expandable, data structures
// from scratch with smart pointers.

#include <stdexcept>
#include <string>
#include <memory>
#include <algorithm>
using namespace std;

// A stack object wraps a low-level array indexed from 0 to capacity-1 where
// the bottommost element (if it exists) will be in slot 0. The member top is
// the index of the slot above the top element, i.e. the next available slot
// that an element can go into. Therefore if top==0 the stack is empty and
// if top==capacity it needs to be expanded before pushing another element.
// However for security there is still a super maximum capacity that cannot
// be exceeded.

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
private:
    std::unique_ptr<T[]> elements; // Allocate array for stack elements
    size_t capacity;               // Capacity of the stack
    size_t top;

    Stack(const Stack&) = delete;
    Stack& operator=(const Stack&) = delete;

public:
  // Initializes empty stack with minimum capacity
  Stack()
      : elements(std::make_unique<T[]>(INITIAL_CAPACITY)),
        capacity(INITIAL_CAPACITY),
        top(0) {}

  // Returns current number of elements in stack
  size_t size() const {
      return top;
  }

  // Return true if stack is empty
  bool is_empty() const {
      return top == 0;
  }

  // Return true if stack is at full capacity
  bool is_full() const {
      return top == capacity;
  }

  void push(const T& value) {
      if (is_full()) {
          if (capacity == MAX_CAPACITY) {
              throw std::overflow_error("Stack has reached maximum capacity");
          }
          reallocate(std::min(capacity * 2, static_cast<size_t>(MAX_CAPACITY)));
      }
      elements[top++] = value;
  }

  T pop() {
      if (is_empty()) {
          throw std::underflow_error("cannot pop from empty stack");
      }
      T value = elements[--top];

      // Shrink stack if size drops below 1/4 of capacity
      if (top < capacity / 4 && capacity > INITIAL_CAPACITY) {
          reallocate(std::max(capacity / 2, static_cast<size_t>(INITIAL_CAPACITY)));
      }
      return value;
  }
private:
  // Resizes the stack while keeping existing elements
  void reallocate(size_t new_capacity) {
      if (new_capacity > MAX_CAPACITY || new_capacity < INITIAL_CAPACITY) {
          return;
      }

      // Create new array and copy existing elements
      std::unique_ptr<T[]> new_elements = std::make_unique<T[]>(new_capacity);
      std::copy(elements.get(), elements.get() + top, new_elements.get());

      elements = std::move(new_elements);
      capacity = new_capacity;
  }
};
