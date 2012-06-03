//
//  MyGameController.h
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 18.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyGameController.h"
#import <IOKit/hid/IOHIDLib.h>

@interface MyGamePadGameController : NSObject<MyGameController>{
    IOHIDManagerRef hidManager;
}

@end
