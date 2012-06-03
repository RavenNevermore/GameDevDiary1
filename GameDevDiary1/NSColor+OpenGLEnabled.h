//
//  NSColor+OpenGLEnabled.h
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 06.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSColor (OpenGLEnabled)

+ (NSColor*) limeColor;
+ (NSColor*) maroonColor;
+ (NSColor*) navyColor;
+ (NSColor*) aquaColor;

- (void) setToOpenGL;

@end
