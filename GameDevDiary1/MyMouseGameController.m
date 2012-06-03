//
//  MyMouseGameController.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 07.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyMouseGameController.h"

@implementation MyMouseGameController

- (void)setupInput{}

- (float)latitude{
    float x = _latitude;
    _latitude = 0;
    return x;
}

- (void)setLatitude:(float)latitude{
    _latitude = latitude;
}

- (float)longitude{
    float y = _longitude;
    _longitude = 0;
    return y;
}

- (void)setLongitude:(float)longitude{
    _longitude = longitude;
}

- (float)centerDistance {
    float cd = _centerDistance;
    if (_centerDistance < .2 && _centerDistance > -.2)
        _centerDistance = 0;
    else
        _centerDistance = _centerDistance/2;
    return cd;
}

- (void)setCenterDistance:(float)centerDistance{
    _centerDistance = centerDistance;
}

- (void)mouseMoved:(NSEvent *)theEvent{
    //latitude value is divided by 2, for smother movement
    [self setLatitude: ([theEvent deltaX]/2)];
    [self setLongitude: [theEvent deltaY]];
    
}

- (void)scrollWheel:(NSEvent *)theEvent{
    float dY = [theEvent deltaY];
    if (dY < .2 && dY > -.2)
        return;
    if (dY > 5)
        dY = 5;
    else if (dY < -5)
        dY = -5;
    [self setCenterDistance:[self centerDistance]+(dY/2)];
}

@end
