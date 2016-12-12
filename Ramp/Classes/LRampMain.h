//
//  LRampMain.h
//  Ramp
//
//  Created by Luka Gabric on 03/12/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//

#ifndef LRampMain_h
#define LRampMain_h

#include "LSharpIR.h"
#include "LRampController.h"
#include "LLowPassFilter.h"

class LRampMain {
private:
    LSharpIR *_sharpIR;
    LRampController *_rampController;
    LLowPassFilter *_filter;

public:
    LRampMain();
    
    void setup();
    void loop();
    
};

#endif /* LRampMain_h */
