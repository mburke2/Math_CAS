//
//  PRONumber.hpp
//  Project
//
//  Created by Mike Burke on 3/26/18.
//  Copyright © 2018 Mike Burke. All rights reserved.
//

#ifndef PRONumber_hpp
#define PRONumber_hpp

#include "InternalNumber.hpp"
class PRONumber {
public:
    PRONumber(InternalNumber* n = 0);
    
private:
    InternalNumber* internalNumber;
};

#endif /* PRONumber_hpp */
