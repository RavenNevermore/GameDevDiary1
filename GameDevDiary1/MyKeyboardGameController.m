//
//  MyKeyboardGameController.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 07.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyKeyboardGameController.h"

@implementation MyKeyboardGameController

@synthesize centerDistance, latitude, longitude;

- (void)setupInput{}


- (void)keyDown:(NSEvent *)theEvent{
    [self handleEvent:theEvent withFlag:YES];
}

- (void)keyUp:(NSEvent *)theEvent {
    [self handleEvent:theEvent withFlag:NO];    
}

- (void) handleEvent:(NSEvent *)theEvent withFlag:(BOOL) keyDown{
    NSString* theStr = [theEvent charactersIgnoringModifiers];
    if ([theStr length] != 1){
        if (keyDown)
            [super keyDown:theEvent];
        else
            [super keyUp:theEvent];
        return;
    }
    
    unichar theChar = [theStr characterAtIndex:0];
    
    if (NSUpArrowFunctionKey == theChar || 'w' == theChar){
        [self setLongitude:keyDown?1:0];
    } else if (NSDownArrowFunctionKey == theChar || 's' == theChar){
        [self setLongitude:keyDown?-1:0];
    } else if (NSLeftArrowFunctionKey == theChar || 'a' == theChar){
        [self setLatitude:keyDown?-1:0];
    } else if (NSRightArrowFunctionKey == theChar || 'd' == theChar){
        [self setLatitude:keyDown?1:0];
    } else if ('1' == theChar || '9' == theChar){
        [self setCenterDistance:keyDown?-2:0];
    } else if ('2' == theChar || '0' == theChar){
        [self setCenterDistance:keyDown?2:0];
    } else {
        if (keyDown)
            [super keyDown:theEvent];
        else
            [super keyUp:theEvent];
        return;
    }
}

@end
