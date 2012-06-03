//
//  MyGameController.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 18.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyGamePadGameController.h"

@implementation MyGamePadGameController

@synthesize centerDistance, latitude, longitude;

void gamepadWasAdded(void* inContext, IOReturn inResult,
                     void* inSender, IOHIDDeviceRef device);
void gamepadWasRemoved(void* inContext, IOReturn inResult, 
                       void* inSender, IOHIDDeviceRef device);
void gamepadAction(void* inContext, IOReturn inResult, 
                   void* inSender, IOHIDValueRef value);

void gamepadWasAdded(void* inContext, IOReturn inResult,
                     void* inSender, IOHIDDeviceRef device) {
    NSLog(@"Gamepad was plugged in: %@", device);
    
}

void gamepadWasRemoved(void* inContext, IOReturn inResult, 
                       void* inSender, IOHIDDeviceRef device) {
    MyGamePadGameController* obj = (__bridge MyGamePadGameController*) inContext;
    [obj setLongitude:0];
    [obj setLatitude:0];
    [obj setCenterDistance:0];
    NSLog(@"Gamepad was unplugged");
}

void gamepadAction(void* inContext, IOReturn inResult, 
                   void* inSender, IOHIDValueRef value) {
    
    IOHIDElementRef element = IOHIDValueGetElement(value);
    
    int usagePage = IOHIDElementGetUsagePage(element);
    int usage = IOHIDElementGetUsage(element);
    if (1 != usagePage)
        return;
    
    long elementValue = IOHIDValueGetIntegerValue(value);
    
    if (48 == usage || 49 == usage || 53 == usage){
        MyGamePadGameController* obj = (__bridge MyGamePadGameController*) inContext;
        float axisScale = 128;
        
        float axisvalue = ((float)(elementValue-axisScale)/axisScale);
        if (elementValue <= axisScale +1 &&
            elementValue >= axisScale -1)
            axisvalue = 0.0;
        if (48 == usage)
            [obj setLatitude:axisvalue];
        else if (53 == usage)
            [obj setCenterDistance:axisvalue];
        else if (49 == usage)
            [obj setLongitude:axisvalue];
    }
    
}

-(void) setupInput {
    //get a HID manager reference
    hidManager = IOHIDManagerCreate(kCFAllocatorDefault, 
                                    kIOHIDOptionsTypeNone);
    
    //define the device to search for, via usage page and usage key
    NSMutableDictionary* criterion = [[NSMutableDictionary alloc] init];
    [criterion setObject: [NSNumber numberWithInt: kHIDPage_GenericDesktop] 
                  forKey: (NSString*)CFSTR(kIOHIDDeviceUsagePageKey)];
    [criterion setObject: [NSNumber numberWithInt: kHIDUsage_GD_Joystick] 
                  forKey: (NSString*)CFSTR(kIOHIDDeviceUsageKey)];
    
    //search for the device
    IOHIDManagerSetDeviceMatching(hidManager, 
                                  (__bridge CFDictionaryRef)criterion);
    
    //register our callback functions
    IOHIDManagerRegisterDeviceMatchingCallback(hidManager, gamepadWasAdded, 
                                               (__bridge void*)self);
    IOHIDManagerRegisterDeviceRemovalCallback(hidManager, gamepadWasRemoved, 
                                              (__bridge void*)self);
    IOHIDManagerRegisterInputValueCallback(hidManager, gamepadAction, 
                                           (__bridge void*)self);
    
    //scedule our HIDManager with the current run loop, so that we
    //are able to recieve events from the hardware.
    IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), 
                                    kCFRunLoopDefaultMode);
    
    //open the HID manager, so that it can start routing events
    //to our callbacks.
    IOHIDManagerOpen(hidManager, kIOHIDOptionsTypeNone);
    
}

- (void)dealloc {
    IOHIDManagerClose(hidManager, kIOHIDOptionsTypeNone);
}

@end
