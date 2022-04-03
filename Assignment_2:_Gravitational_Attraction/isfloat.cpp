#include<stdio.h>
#include<string>
#include<cctype>
#include<math.h>

extern "C" bool isfloat(char[]);

bool isfloat(char input[]){
    bool float_status = true;
    int decimal = 0;
    int start_index = 0;

        if(input[0] == '-' || input[0] == '+'){
          //If negative or positive sign, shift start index up
            start_index = 1;
        }
        else if (!isdigit(input[0])){
            float_status = false;
          //If invalid then the status is false
        }

        //As long as we have not reached the end of the input and the status is false...
        while(input[start_index] != '\0' && float_status != false){
          //keep looping through each character in the input

          //if the character is not a digit...
            if(!isdigit(input[start_index])){
              //Check if it's a decimal and if we don't have any other decimals
                if(input[start_index] == '.' && decimal < 1){
                  //if it's a decimal and we don't have any other decimals
                  //increment decimal to indicate we already have one decimal
                  decimal++;
                }
                //otherwise the input is not a float
                //since we can't have any other nondigit characters
                else float_status = false;
            }
            //move on to the next character
            start_index++;
        }
    // return whether or not it is a float
    return float_status;
}
