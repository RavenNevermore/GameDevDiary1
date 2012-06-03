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
}

@property (assign) NSImage* texture;

@end
