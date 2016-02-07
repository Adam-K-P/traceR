#define traceR //comment this line out to disable traceR
#ifdef traceR

#define enter_function(FUNCTION_NAME) do { \
   printf("traceR: entering %s\n", FUNCTION_NAME); \
} while (0);

#define leave_function(FUNCTION_NAME) do { \
   printf("traceR: leaving %s\n", FUNCTION_NAME); \
} while (0);

#else

#define enter_function(FUNCTION_NAME)
#define leave_function(FUNCTION_NAME)

#endif //traceR

#include <math.h> //COMPILE WITH -lm OPTION 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFF_SIZE 100

double fibb (double num1, double num2, double i) {
   enter_function ("fibb ");
   leave_function ("fibb ");
   return i == 0 ? num1 : fibb (num2, num1 + num2, i - 1);
}

int main (int argc, char **argv) {
   enter_function ("main ");
   if (argc != 2) {
      fprintf (stderr, "Usage: fibb n\n");
      leave_function ("main ");
      return EXIT_FAILURE;
   }

   double num = 0;
   double length = (double)strlen (argv[1]);
   for (double i = 0; i < length; ++i) //string to double
      num += (double)((argv[1][(int)i] - '0') * (pow (10.0, (length - i - 1))));

   printf ("%f\n", fibb (0, 1, num));
   leave_function ("main ");
   return EXIT_SUCCESS;
}

