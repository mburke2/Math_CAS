//
//  Driver.m
//  Project
//
//  Created by Mike Burke on 3/26/18.
//  Copyright © 2018 Mike Burke. All rights reserved.
//



#import "Driver.h"
#include "PRONumber.hpp"
#include <iostream>
#include <string>
using std::cout;
using std::endl;

//2^62 =          4611686018427387904
//sqrt(2^62) =    2147483648

//#define MAX_DIGIT 1000000000
//#define DIGIT_LENGTH 9

#define MAX_DIGIT 10000
#define DIGIT_LENGTH 4

#include <vector>
using std::vector;



vector<unsigned long> vectorAdd(vector<unsigned long>&, vector<unsigned long>&);
vector<unsigned long> vectorMultiply(vector<unsigned long>&, vector<unsigned long>&);
vector<unsigned long> vectorSubtract(vector<unsigned long>&, vector<unsigned long>&);
bool vectorEqual(vector<unsigned long>&, vector<unsigned long>&);
vector<unsigned long>* vectorReturnGreater(vector<unsigned long>&, vector<unsigned long>&);

vector<unsigned long> vectorMultiplyBySingleDigit(vector<unsigned long> &v, unsigned long dig);
void vectorTrim(vector<unsigned long>&);

void printVector(vector<unsigned long>&);
vector<unsigned long> vectorWithInt(unsigned long);

void vectorTrim(vector<unsigned long> &toTrim)  {
    if (toTrim.size() == 0) {
        toTrim.push_back(0);
        return;
    }
    
    while (toTrim.back() == 0)  {
        toTrim.pop_back();
    }
    if (toTrim.size() == 0)
        toTrim.push_back(0);
}

vector<unsigned long> vectorSubtract(vector<unsigned long> &v1, vector<unsigned long> &v2)  {
    //assumes v1 > v2
    vector <unsigned long> result;
    
    vector<unsigned long>::iterator it1 = v1.begin();
    vector<unsigned long>::iterator it2 = v2.begin();
    
    
    unsigned long val;
    bool borrow = false;
    bool nextBorrow = false;
    unsigned long d1;
    unsigned long d2;
    while (it2 != v2.end()) {

        d1 = *it1;
        d2 = *it2;
        
        if (borrow) {
            if (d1 >= d2 + 1)    {
                val = d1 - (d2 + 1);
                nextBorrow = false;
            }   else    {
                nextBorrow = true;
                val = MAX_DIGIT + d1 - (d2 + 1);
            }
        }
        else    {
            if (d1 >= d2)    {
                val = d1 - d2;
                nextBorrow = false;
            }   else{
                nextBorrow = true;
                val = MAX_DIGIT + d1 - d2;
            }
        }
        
        borrow = nextBorrow;
        result.push_back(val);
        ++it2;
        ++it1;
    }
    
    while (it1 != v1.end()) {
        d1 = *it1;
        if (borrow) {
            if (d1 >= 1) {
                nextBorrow = false;
                val = d1 - 1;
            }   else{
                nextBorrow = true;
                val = MAX_DIGIT - 1;
            }
        }
        else    {
            nextBorrow = false;
            val = d1;
        }
            
        result.push_back(val);
        
        borrow = nextBorrow;
        ++it1;
    }
    
    
    vectorTrim(result);
    return result;
    
}


vector<unsigned long> vectorAdd(vector<unsigned long> &v1, vector<unsigned long> &v2)   {
    vector <unsigned long> result;
    
    vector<unsigned long>* big = &v1;
    vector<unsigned long>* small = &v2;
    
    if (v1.size() < v2.size())  {
        big = &v2;
        small = &v1;
    }
    
    unsigned long carry = 0;
    unsigned long val;
    
    vector<unsigned long>::iterator bigIt = big->begin();
    vector<unsigned long>::iterator smallIt = small->begin();
    for (; bigIt != big->end() && smallIt != small->end(); ++bigIt, ++smallIt) {
        val = carry + *bigIt + *smallIt;
        carry = val / MAX_DIGIT;
        val = val % MAX_DIGIT;
        
        result.push_back(val);
    }

    while (bigIt != big->end()) {
        
        val = carry + *bigIt;
        carry = val / MAX_DIGIT;
        val = val % MAX_DIGIT;

        result.push_back(val);
        ++bigIt;
    }

    if (carry > 0)
        result.push_back(carry);
    
    vectorTrim(result);
    return result;
}


bool vectorEqual(vector<unsigned long> &v1, vector<unsigned long> &v2)    {
    if (vectorReturnGreater(v1, v2) == 0)
        return true;
    return false;
}



void printVector(vector<unsigned long> &v1)   {
    
    std::string result = "";
    if (v1.size() == 0) {
        cout << "empty vector" << endl;
        return;
    }
    
    vector<unsigned long>::reverse_iterator it = v1.rbegin();
    std::string digit = std::to_string(*it);
    ++it;
    for (; it != v1.rend(); ++it)   {
        result += digit;
        digit = std::to_string(*it);
        while (digit.length() < DIGIT_LENGTH)   {
            digit.insert(0, "0");
        }
    }
    
    result += digit;
    
    cout << result << endl;
    
    
    
}


vector <unsigned long> vectorMultiply(vector<unsigned long> &v1, vector<unsigned long> &v2) {
    vector<unsigned long> result;
    result.push_back(0);

    vector<unsigned long>* big = &v1;
    vector<unsigned long>* small = &v2;
    
    if (big->size() < small->size())    {
        big = &v2;
        small = &v1;
    }
    unsigned long d1;
    unsigned long d2;
    unsigned long val;
    unsigned long carry = 0;
    int smallCounter = 0;
    
    vector<vector<unsigned long>> subResults;
    for (vector<unsigned long>::iterator smallIt = small->begin(); smallIt != small->end(); ++smallIt)  {
        vector<unsigned long> subResult;
        carry = 0;
        for (int i = 0; i < smallCounter; i++)  {
            subResult.push_back(0);
        }
        
        d1 = *smallIt;
        
        for (vector<unsigned long>::iterator bigIt = big->begin(); bigIt != big->end(); ++bigIt)    {
            d2 = *bigIt;
            val = d1 * d2 + carry;
            
            carry = val / MAX_DIGIT;
            val = val % MAX_DIGIT;
            
            subResult.push_back(val);
        }
        
        
        if (carry > 0)
            subResult.push_back(carry);
    

        
        result = vectorAdd(result, subResult);
        smallCounter = smallCounter + 1;
    }
    

    vectorTrim(result);
    return result;
    
}

vector<unsigned long> vectorMultiplyBySingleDigit(vector<unsigned long> &v, unsigned long dig) {
    //cout << "Single digit vector multiply " << dig << " ";
    //printVector(v);
    //cout << endl;
    
    vector<unsigned long> result;
    
    unsigned long val;
    unsigned long carry = 0;
    for (vector<unsigned long>::iterator it = v.begin(); it != v.end(); ++it)   {
        val = carry + dig * (*it);
        carry = val / MAX_DIGIT;
        val = val % MAX_DIGIT;
        
        result.push_back(val);
    }
    
    if (carry > 0)
        result.push_back(carry);
    
    vectorTrim(result);
    return result;
}




vector<unsigned long>* vectorReturnGreater(vector<unsigned long> &v1, vector<unsigned long> &v2)    {
    if (v1.size() > v2.size())
        return &v1;
    
    else if (v2.size() > v1.size())
        return &v2;
    
    vector<unsigned long>::reverse_iterator it1 = v1.rbegin();
    vector<unsigned long>::reverse_iterator it2 = v2.rbegin();
    
    
    for (; it1 != v1.rend() && it2 != v2.rend(); ++it1, ++it2)  {
        if (*it1 > *it2)
            return &v1;
        else if (*it2 > *it1)
            return &v2;

    }
    
    return 0;
    
}


bool vectorDivide(vector<unsigned long> &dividend, vector<unsigned long> &divisor, vector<unsigned long> &q, vector<unsigned long> &r)   {
 
    unsigned long d = (MAX_DIGIT - 1) / divisor.back();
    /*
    cout << "num = ";
    printVector(dividend);
    cout << "den = ";
    printVector(divisor);
    cout << "d = " << d << endl;
    */
    vector<unsigned long> u = vectorMultiplyBySingleDigit(dividend, d);
    vector<unsigned long> v = vectorMultiplyBySingleDigit(divisor, d);
    
    /*
    cout << "u = ";
    printVector(u);
    cout << "v = ";
    printVector(v);
    */
    
    long n = v.size();
    if (n == 1)
        return false;
    long j = u.size() - v.size() - 1;
    if (u.size() == v.size())
        j = 0;
    
    
    for (int junkCounter = 0; junkCounter <= j; junkCounter++)  {
        q.push_back(0);
    }
//    cout << "j = " << j << endl;
    while (j >= 0)  {
        
        /*
        cout << "START OF LOOP!\n\tu = ";
        printVector(u);
        cout << "\tv = ";
        printVector(v);
        cout << "\tq = ";
        printVector(q);
         */
        unsigned long num = u[j + n] * MAX_DIGIT + (u[j + n - 1]);
        unsigned long qHat = num / v[n - 1];
        unsigned long rHat = num % v[n - 1];
  
        //cout << "num = " << num << ", qHat = " << qHat << ", rHat = " << rHat << endl;

        //cout << "qHat = " << qHat << ", v[n - 2] = " << v[n-2] << ", rHat = " << rHat << ", u[j + n - 2] = " << u[j + n  - 2] << endl;
        if (qHat == MAX_DIGIT || qHat * v[n - 2] > MAX_DIGIT * rHat + u[j + n - 2])    {
            qHat = qHat - 1;
            rHat = rHat + v[n - 1];
            if (rHat >= MAX_DIGIT)   {
               // return false;
                if (qHat == MAX_DIGIT || qHat * v[n - 2] > MAX_DIGIT * rHat + u[j + n - 2])    {
                    qHat = qHat - 1;
                    rHat = rHat + v[n - 1];
                }
            }
        }
        
        
        vector <unsigned long> ujs;
        
        for (long counter = j; counter < j + n + 1; counter++)  {
            ujs.push_back(u[counter]);
        }
        vectorTrim(ujs);
    
        vector<unsigned long> nextThing = vectorMultiplyBySingleDigit(v, qHat);
//        cout << "midLoop: qHat = " << qHat << ", nextThing = ";
//        printVector(nextThing);
//        cout << "ujs = ";
//        printVector(ujs);
//        cout << endl;
        
        //q.push_back(qHat);
        q[j] = qHat;
        
        
        if (vectorReturnGreater(ujs, nextThing) == &nextThing) {   //D6
            return false;
            ujs = vectorAdd(ujs, v);
            q[j] = q[j] - 1;
            ujs = vectorSubtract(ujs, nextThing);
            ujs.pop_back();
        }   else    {
            ujs = vectorSubtract(ujs, nextThing);
        }
        u[j] = 0;
        for (long counter = j; counter <= j + n; counter++)  {
            u[counter] = ujs[counter - (j)];
            
            
//            cout << "end of loop qHat = " << qHat << ", next u = ";
//            printVector(u);

        }
        vectorTrim(u);

        j = j - 1;
    }
    
    
    
    vectorTrim(q);
    vectorTrim(r);
    
    return true;
}


void spewProblem()  {
    vector<unsigned long> v1;
    vector<unsigned long> v2;
    
    int smallDigs = rand() % 12;
    int excess = 1 + rand() % 7;
//cout << "small digs = " << smallDigs << ", excess = " << excess << endl;

    for (int i = 0; i < smallDigs; i++) {
        v1.push_back(rand() % MAX_DIGIT);
        v2.push_back(rand() % MAX_DIGIT);
        
    }
    
    for (int i = 0; i < excess; i++) {
        v2.push_back(rand() % MAX_DIGIT);
    }
    
    
    v1.push_back(1 + rand() % (MAX_DIGIT - 1));
    v2.push_back(1 + rand() % (MAX_DIGIT - 1));
    
    
    
    vector<unsigned long> quotient;
    vector<unsigned long> mod;
    //if (rand() % 2 == 0)
    bool result = vectorDivide(v2, v1, quotient, mod);
    if (result == true) {
        printVector(v2);
        printVector(v1);

    //else
      //  sum = vectorAdd(v1, v2);
    
        printVector(quotient);
    }
}

vector <unsigned long> vectorWithInt(unsigned long n)   {
    vector<unsigned long> result;
    while (n > 0)   {
        result.push_back(n % MAX_DIGIT);
        n = n / MAX_DIGIT;
    }
    
    return result;
}



void singleProblem()    {
/*
 => [[56, 7, 7], [2129120, 260232, 0]]

 */
    vector<unsigned long> v1 = vectorWithInt(2129120);
    vector<unsigned long> v2 = vectorWithInt(260232);
    
    vector<unsigned long> q;
    vector<unsigned long> r;
    
    bool flag = vectorDivide(v1, v2, q, r);
    
    cout << "flag = " << flag << endl;
    
    cout << "q = ";
    printVector(q);
    
}


@implementation Driver

+(void) drive   {
 
    

    //singleProblem();
    //return;
    
    for (int i = 0; i < 1000; i++)   {
        spewProblem();
    }
    
    
}







@end
