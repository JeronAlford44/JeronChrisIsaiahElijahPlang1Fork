#include "string_stack.h"
#include <stdlib.h>
#include <string.h>
#define INITIAL_CAPACITY 16

struct _Stack
{
    char **elements;
    int top;
    int capacity;
};

// Create a new stack with an initial capacity
stack_response create()
{
    // Allocate memory for the stack structure
    stack s = malloc(sizeof(struct _Stack));
    if (s == NULL)
    {
        return (stack_response){.code = out_of_memory, .stack = NULL}; // Return an error if memory allocation fails
    }

    // Initialize the stack fields
    s->top = 0;
    s->capacity = INITIAL_CAPACITY;
    s->elements = malloc(INITIAL_CAPACITY * sizeof(char *));

    if (s->elements == NULL)
    {
        // Free the stack if memory allocation for elements fails
        free(s);
        return (stack_response){.code = out_of_memory, .stack = NULL};
    }
    // Return a successful stack creation response
    return (stack_response){.code = success, .stack = s};
}

// Return the current size of the stack (number of elements)
int size(const stack s)
{
    return s->top;
}

// Check if the stack is empty
bool is_empty(const stack s)
{
    return size(s) == 0;
}

// Check if the stack is full (reached MAX_CAPACITY)
bool is_full(const stack s)
{
    return size(s) == MAX_CAPACITY;
}

// Push a new string onto the stack
response_code push(stack s, char *item)
{
    // Ensure the item is not too large
    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE)
    {
        return stack_element_too_large;
    }

    // Check if the stack is already at its maximum capacity
    if (is_full(s))
    {
        return stack_full;
    }

    // Resize the stack if it's full
    if (s->top == s->capacity)
    {
        int new_capacity = s->capacity * 2;
        // Ensure the new capacity does not exceed the maximum allowed
        if (new_capacity > MAX_CAPACITY)
        {
            new_capacity = MAX_CAPACITY;
        }

        // Reallocate memory for the stack's elements array
        char **new_elements = realloc(s->elements, new_capacity * sizeof(char *));

        if (new_elements == NULL)
        {
            return out_of_memory; // Return an error if reallocation fails
        }

        // Update the stack's elements and capacity
        s->elements = new_elements;
        s->capacity = new_capacity;
    }

    // Copy and store the item
    char *copy = strdup(item);
    if (copy == NULL)
    {
        return out_of_memory; // Return an error if strdup fails
    }

    // Add the copied string to the stack and increment the top index
    s->elements[s->top++] = copy;
    return success;
}

// Pop the top string from the stack
string_response pop(stack s)
{
    // Check if the stack is empty
    if (is_empty(s))
    {
        return (string_response){.code = stack_empty, .string = NULL};
    }

    // Pop the top element
    char *popped = s->elements[--s->top];
    s->elements[s->top] = NULL; // Clear reference to the popped element

    // Shrink the stack if it is underutilized
    if (s->top < s->capacity / 4 && s->capacity > INITIAL_CAPACITY)
    {
        int new_capacity = s->capacity / 2;
        // Ensure the new capacity does not go below the initial capacity
        if (new_capacity < INITIAL_CAPACITY)
        {
            new_capacity = INITIAL_CAPACITY;
        }

        // Reallocate memory for the stack's elements array
        char **new_elements = realloc(s->elements, new_capacity * sizeof(char *));
        if (new_elements != NULL)
        { // Only resize if successful
            s->elements = new_elements;
            s->capacity = new_capacity;
        }
    }
    return (string_response){.code = success, .string = popped};
}

// Destroy the stack and free all associated memory
void destroy(stack *s)
{
    // Check if the stack is valid
    if (s == NULL || *s == NULL)
    {
        return;
    }

    // Free all elements
    for (int i = 0; i < (*s)->top; i++)
    {
        free((*s)->elements[i]);
    }

    // Free the array and the stack itself
    free((*s)->elements);
    free(*s);

    *s = NULL;
}