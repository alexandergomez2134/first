//===== Begin code area ===================================================================================================================================================

#include <stdio.h>
#include <stdint.h>                                         //To students: the second, third, and fourth header files are probably not needed.
#include <ctime>
#include <cstring>
#include <iostream>
#include <iomanip>
#include <math.h>

extern "C" double array_tools(double *,long);               //The "C" is a directive to the C++ compiler to use standard "CCC" rules for parameter passing.

using namespace std;

int main(int argc, char* argv[]){
  const int max = 12;
  double pi = 4.0*atan(1.0);  //3.1416;
  //A teaching moment:  The next statement declares a static array.  A static arrays store all of its data in the activation
  //record belonging to the module which declared the array.  To be clear: the array called myarray exists only in stack space.
  double myarray[max] = {1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0};
  double return_code = 188.9;                              //188.9 is an arbitrary number; that initial value could have been anything.


  printf("\n%s%d\n","Welcome to Array Tools.\nThis is your array beginning at index -1 and ending at index: ",max);
  for (int i = -1; i<max+1; i++) cout << setw(9) << right << setprecision(4) << showpoint << fixed << myarray[i];
  cout << endl << endl;
  return_code = array_tools(myarray,max);
  printf("%s\n","The main C++ program will now show the contents of its array.");
  //Another teaching point: Notice that the loop begins at one quadword before the first cell of the array, and it continues to
  //two cells beyond the end of the array.
  for (int i = -1; i<max+1; i++) cout << setw(9) << right << setprecision(5) << showpoint << fixed << myarray[i]; 
  cout << endl;
  printf("%s%1.18lf%s\n","The driver received return code ",return_code,".  The driver will now return 0 to the OS.");
  printf("%s%1.18lf%s\n","The value of pi is still ",pi," Bye");
  return 0;                                                 //'0' is the traditional code for 'no errors'.

}//End of main
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6**
