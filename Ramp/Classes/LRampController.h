//
//  LRampController.h
//  Ramp
//
//  Created by Luka Gabric on 02/12/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//

#ifndef LRampController_h
#define LRampController_h

#include "LSharpIR.h"
#include <Arduino.h>
#include <Servo.h>

enum LRampState { undefined, open, closed };

class LRampController {
private:
    Servo *_servo;
    uint8_t _servoPin;
    uint8_t _greenLightsPin;
    uint8_t _redLightsPin;
    LRampState _rampState;
    void turnLightsToGreen();
    void turnLightsToRed();
    void turnLightsOff();
    void turnLightsOnWithPin(uint8_t pin);
public:
    LRampController(uint8_t servoPin, uint8_t greenLightsPin, uint8_t redLightsPin);
    LRampState rampState();
    void openRamp();
    void closeRamp();
};

#endif /* LRampController_h */
