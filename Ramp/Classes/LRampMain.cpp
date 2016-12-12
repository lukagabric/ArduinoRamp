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
    _filter = new LLowPassFilter(0, 0.15, 0.05);
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
    float filteredDistance = _filter->filterValue(distance);
    Serial.print("Distance: ");Serial.print(distance);Serial.print("\tFiltered distance: ");Serial.println(filteredDistance);
    if (filteredDistance < 30) {
        _rampController->openRamp();
    } else if (filteredDistance > 33) {
        _rampController->closeRamp();
    }
}

#pragma mark -
