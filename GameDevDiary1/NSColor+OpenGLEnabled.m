//
//  NSColor+OpenGLEnabled.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 06.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OpenGL/gl.h>
#import "NSColor+OpenGLEnabled.h"

@implementation NSColor (OpenGLEnabled)

+ (NSColor *)limeColor{
    return [NSColor colorWithDeviceRed:0 green:1 blue:0 alpha:1];
}

+ (NSColor *)maroonColor{
    return [NSColor colorWithDeviceRed:.5 green:0 blue:0 alpha:1];
}

+ (NSColor *)navyColor{
    return [NSColor colorWithDeviceRed:0 green:0 blue:.5 alpha:1];
}

+ (NSColor *)aquaColor{
    return [NSColor colorWithDeviceRed:0 green:1 blue:1 alpha:1];
}

- (void)setToOpenGL{
    NSColor* c = [self colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
    float red = [c redComponent];
    float green = [c greenComponent];
    float blue = [c blueComponent];
    float alpha = [c alphaComponent];
    
    glColor4f(red, green, blue, alpha);
}

@end
