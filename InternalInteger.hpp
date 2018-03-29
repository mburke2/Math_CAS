//
//  InternalInteger.hpp
//  Project
//
//  Created by Mike Burke on 3/26/18.
//  Copyright © 2018 Mike Burke. All rights reserved.
//


#define NODE_MAX 10000

#ifndef InternalInteger_hpp
#define InternalInteger_hpp

#include <iostream>
#include <vector>

using std::vector;

class InternalInteger   {

public:
    
    InternalInteger* add(InternalInteger* i);
    InternalInteger* subract(InternalInteger* i);
    InternalInteger* multiply(InternalInteger* i);
    
    bool greaterThan(InternalInteger* i);
    bool lessThan(InternalInteger* i);
    bool equal(InternalInteger* i);


    
private:
    vector<unsigned int> digits;
};



#endif /* InternalInteger_hpp */
