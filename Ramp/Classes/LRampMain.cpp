//
//  LRampMain.cpp
//  Ramp
//
//  Created by Luka Gabric on 03/12/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//

#include "LRampMain.h"

#pragma mark - Constructor

LRampMain::LRampMain() {
}

#pragma mark - Lifecycle

void LRampMain::setup() {
    Serial.begin(9600);
    Serial.println("Ready!!");

    _sharpIR = new LSharpIR(A0);
    _rampController = new LRampController(9, 7, 8);
}

void LRampMain::loop() {
    float distance = _sharpIR->measureDistance();
    Serial.println(distance);
    if (distance < 20) {
        _rampController->openRamp();
    } else {
        _rampController->closeRamp();
    }
}

#pragma mark -
