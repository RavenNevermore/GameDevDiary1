//
//  MyCube.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 19.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCube.h"
#import <OpenGL/gl.h>
#import "NSColor+OpenGLEnabled.h"

@implementation MyCube

@synthesize rotationAngle;
@synthesize scale;
@synthesize positionX;
@synthesize positionY;
@synthesize positionZ;
@synthesize baseColor;

- (void)setPositionX:(float)x Y:(float)y Z:(float)z{
    self.positionX = x;
    self.positionY = y;
    self.positionZ = z;
}

- (void)drawVertices{
    
    glDisable(GL_TEXTURE_2D);
    glBegin(GL_QUADS); 
    {
        [baseColor setToOpenGL];
        glVertex3f(-1,  1, -1); //F T L
        glVertex3f( 1,  1, -1); //F T R
        glVertex3f( 1, -1, -1); //F B R
        glVertex3f(-1, -1, -1); //F B L
        
        glVertex3f(-1, -1, -1); //F B L   
        glVertex3f( 1, -1, -1); //F B R
        glVertex3f( 1, -1,  1); //B B R
        glVertex3f(-1, -1,  1); //B B L
        
        glVertex3f(-1,  1,  1); //B T L
        glVertex3f( 1,  1,  1); //B T R
        glVertex3f( 1, -1,  1); //B B R
        glVertex3f(-1, -1,  1); //B B L
        
        glVertex3f(-1,  1,  1); //B T L
        glVertex3f(-1,  1, -1); //F T L
        glVertex3f(-1, -1, -1); //F B L   
        glVertex3f(-1, -1,  1); //B B L
        
        glVertex3f(-1,  1,  1); //B T L
        glVertex3f( 1,  1,  1); //B T R
        glVertex3f( 1,  1, -1); //F T R
        glVertex3f(-1,  1, -1); //F T L
        
        glVertex3f( 1,  1, -1); //F T R
        glVertex3f( 1,  1,  1); //B T R
        glVertex3f( 1, -1,  1); //B B R
        glVertex3f( 1, -1, -1); //F B R
        
    }
    glEnd();
    glEnable(GL_TEXTURE_2D);
}

-(void)draw{
    glPushMatrix();
    
    glTranslatef(positionX, positionY, positionZ);
    glRotatef([self rotationAngle], 1, 1, 1);
    float s = scale*.5;
    
    glScalef(s, s, s);
    if (!baseColor)
        [self setBaseColor:[NSColor grayColor]];
    [self drawVertices];
    glPopMatrix();
}

@end
