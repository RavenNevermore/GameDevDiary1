//
//  MyTexturedCube.h
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 03.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCube.h"
#import <OpenGL/gl.h>

@interface MyTexturedCube : MyCube {
    GLuint textureIndex;
    NSImage* _texture;
    float textureCoords[48];
}

+ (float*)defaultTextureCoords;
+ (float*)threeByTwoCoords;

@property (assign) NSImage* texture;
- (void)setTexture:(NSImage *)texture withCoordinates:(float[48]) coords;

@end
