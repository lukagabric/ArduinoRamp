//
//  LSharpIR.h
//  Ramp
//
//  Created by Luka Gabric on 02/12/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//

#ifndef LSharpIR_h
#define LSharpIR_h

class LSharpIR {
private:
    unsigned int _sharpPin;
public:
    LSharpIR(unsigned int sharpPin);
    float measureDistance();
};

#endif /* LSharpIR_h */
