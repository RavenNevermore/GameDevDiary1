//
//  MyListGameController.h
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 01.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyGameController.h"

@interface MyListGameController : NSResponder<MyGameController>{
    NSMutableArray* controllers;
}

- (void) addController:(NSObject<MyGameController>*) controller;

@end
