//
//  Constant.m
//  Cabxy
//
//  Created by Immanuel Infant Raj.S on 7/27/15.
//  Copyright (c) 2015 Immanuel Infant Raj.S. All rights reserved.
//


#import "Constant.h"
extern int tabid = 0;

extern int can = 0;

extern int de=0;

@implementation Constant

+ (Constant *) sharedConstants{
    // the instance of this class is stored here
    static Constant *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    // return the instance of this class
    return myInstance;
    
}//End of class method


@end
