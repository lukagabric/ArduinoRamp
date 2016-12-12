//
//  LSharpIR.cpp
//  Ramp
//
//  Created by Luka Gabric on 02/12/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//

#include "LSharpIR.h"
#include <Arduino.h>

#pragma mark - Constructor

LSharpIR::LSharpIR(unsigned int sharpPin) {
    _sharpPin = sharpPin;
}

float LSharpIR::measureDistance() {
    float volts = analogRead(_sharpPin);
    float distance;
    
    if (volts > 500) {
        distance = 10;
    } else if (volts < 80) {
        distance = 80;
    }
    else {
        distance = 4800/(volts - 20);
    }
    
    return distance;
}

#pragma mark -
