//
//  MyRainbowCube.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 06.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OpenGL/gl.h>
#import "NSColor+OpenGLEnabled.h"
#import "MyRainbowCube.h"

@implementation MyRainbowCube

- (void)drawVertices{
    glDisable(GL_TEXTURE_2D);
    glBegin(GL_QUADS); 
    {
        [[NSColor blueColor] setToOpenGL];
        glVertex3f(-1,  1, -1); //F T L
        [[NSColor orangeColor] setToOpenGL];
        glVertex3f( 1,  1, -1); //F T R
        [[NSColor limeColor] setToOpenGL];
        glVertex3f( 1, -1, -1); //F B R
        [[NSColor redColor] setToOpenGL];
        glVertex3f(-1, -1, -1); //F B L
        
        [[NSColor redColor] setToOpenGL];
        glVertex3f(-1, -1, -1); //F B L   
        [[NSColor limeColor] setToOpenGL];
        glVertex3f( 1, -1, -1); //F B R
        [[NSColor greenColor] setToOpenGL];
        glVertex3f( 1, -1,  1); //B B R
        [[NSColor maroonColor] setToOpenGL];
        glVertex3f(-1, -1,  1); //B B L
        
        [[NSColor navyColor] setToOpenGL];
        glVertex3f(-1,  1,  1); //B T L
        [[NSColor aquaColor] setToOpenGL];
        glVertex3f( 1,  1,  1); //B T R
        [[NSColor greenColor] setToOpenGL];
        glVertex3f( 1, -1,  1); //B B R
        [[NSColor maroonColor] setToOpenGL];
        glVertex3f(-1, -1,  1); //B B L
        
        [[NSColor navyColor] setToOpenGL];
        glVertex3f(-1,  1,  1); //B T L
        [[NSColor blueColor] setToOpenGL];
        glVertex3f(-1,  1, -1); //F T L
        [[NSColor redColor] setToOpenGL];
        glVertex3f(-1, -1, -1); //F B L   
        [[NSColor maroonColor] setToOpenGL];
        glVertex3f(-1, -1,  1); //B B L
        
        [[NSColor navyColor] setToOpenGL];
        glVertex3f(-1,  1,  1); //B T L
        [[NSColor aquaColor] setToOpenGL];
        glVertex3f( 1,  1,  1); //B T R
        [[NSColor orangeColor] setToOpenGL];
        glVertex3f( 1,  1, -1); //F T R
        [[NSColor blueColor] setToOpenGL];
        glVertex3f(-1,  1, -1); //F T L
        
        [[NSColor orangeColor] setToOpenGL];
        glVertex3f( 1,  1, -1); //F T R
        [[NSColor aquaColor] setToOpenGL];
        glVertex3f( 1,  1,  1); //B T R
        [[NSColor greenColor] setToOpenGL];
        glVertex3f( 1, -1,  1); //B B R
        [[NSColor limeColor] setToOpenGL];
        glVertex3f( 1, -1, -1); //F B R
        
    }
    glEnd();
    glEnable(GL_TEXTURE_2D);
}

@end
