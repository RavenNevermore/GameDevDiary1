//
//  MyCube.h
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 19.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCube : NSObject

@property (assign) float rotationAngle;
@property (assign) float scale;
@property (assign) float positionX;
@property (assign) float positionY;
@property (assign) float positionZ;
@property (assign) NSColor* baseColor;

- (void) setPositionX:(float) x Y:(float) y Z:(float) z;
- (void) draw;
- (void) drawVertices;

@end
