//
//  LRampController.cpp
//  Ramp
//
//  Created by Luka Gabric on 02/12/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//

#include "LRampController.h"

#define kRampDelay 30
#define kBlinkDelay 100

#pragma mark - Constructor

LRampController::LRampController(uint8_t servoPin, uint8_t greenLightsPin, uint8_t redLightsPin) {
    _servoPin = servoPin;
    _servo = new Servo();
    _servo->attach(_servoPin);
    _rampState = undefined;
    _greenLightsPin = greenLightsPin;
    _redLightsPin = redLightsPin;
    pinMode(_greenLightsPin, OUTPUT);
    pinMode(_redLightsPin, OUTPUT);
}

#pragma mark - Operation

void LRampController::openRamp() {
    if (_rampState == open) return;
    
    turnLightsToGreen();
    
    for (int pos = 110; pos >= 20; pos--) {
        _servo->write(pos);
        delay(kRampDelay);
    }
    
    _rampState = open;
}

void LRampController::closeRamp() {
    if (_rampState == closed) return;

    turnLightsToRed();

    for (int pos = 20; pos < 110; pos++) {
        _servo->write(pos);
        delay(kRampDelay);
    }
    
    _rampState = closed;
}

#pragma mark - Lights

void LRampController::turnLightsToGreen() {
    turnLightsOff();
    turnLightsOnWithPin(_greenLightsPin);
}

void LRampController::turnLightsToRed() {
    turnLightsOff();
    turnLightsOnWithPin(_redLightsPin);
}

void LRampController::turnLightsOff() {
    digitalWrite(_greenLightsPin, LOW);
    digitalWrite(_redLightsPin, LOW);
    delay(20);
}

void LRampController::turnLightsOnWithPin(uint8_t pin) {
    for (int i = 0; i < 29; i++) {
        uint8_t val = i % 2 == 0 ? HIGH : LOW;
        digitalWrite(pin, val);
        delay(kBlinkDelay);
    }
}

#pragma mark - State

LRampState LRampController::rampState() {
    return _rampState;
}

#pragma mark -
