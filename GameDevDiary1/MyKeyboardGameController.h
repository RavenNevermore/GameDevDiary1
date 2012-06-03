//
//  MyKeyboardGameController.h
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 07.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyGameController.h"

@interface MyKeyboardGameController : NSResponder<MyGameController>

- (void) handleEvent:(NSEvent *)theEvent withFlag:(BOOL) keyDown;

@end
