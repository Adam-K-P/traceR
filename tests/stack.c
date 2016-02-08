#include <stdio.h>
#include <stdlib.h>
#include <string.h> //memmove

typedef struct node {
   void *mem;
   struct node *next;
} node;

typedef struct stack {
   int size;
   node *top;
} stack;

stack *new_stack () {
   stack *this_stack = malloc (sizeof (stack));
   this_stack->size = 0;
   this_stack->top = NULL;
   return this_stack;
}

node *new_node (void *data, size_t size) {
   node *this_node = malloc (sizeof (node));
   this_node->next = NULL;
   this_node->mem = malloc (size);
   this_node->mem = memmove (this_node->mem, data, size);
   return this_node;
}

size_t size (stack *this_stack) {
   return this_stack->size;
}

void push (stack *this_stack, void *data, size_t size) {
   node *this_node = new_node (data, size);
   if (this_stack->top == NULL) 
      this_stack->top = this_node;
   else {
      this_stack->top->next = this_node;
      this_stack->top = this_node;
   }
   ++(this_stack->size);
}

void *pop (stack *this_stack) {
   node *this_node = this_stack->top;
   this_stack->top = this_node->next;
   --(this_stack->size);
   return this_node->mem;
}

int main (void) {
   stack *this_stack = new_stack ();
   char *test_str = "test string";
   push (this_stack, (void *)test_str, sizeof (char) * strlen (test_str));
   char *ret_str = (char *) pop (this_stack);
   printf ("pushed: %s\n", ret_str);
   return EXIT_SUCCESS;
}
