//
//  MyTexturedCube.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 03.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTexturedCube.h"
#import "NSColor+OpenGLEnabled.h"

@implementation MyTexturedCube

- (id)init{
    self = [super init];
    textureIndex = -1;
    return self;
}

- (NSImage *)texture{
    return _texture;
}

- (void)setTexture:(NSImage *)texture{
    _texture = texture;
    textureIndex = -1;
}

- (void)drawVertices{
    if (_texture){
        if (-1 == textureIndex){
            NSBitmapImageRep* bmp = [[NSBitmapImageRep alloc] initWithData:
                                     [_texture TIFFRepresentation]];
            
            glGenTextures(1, &textureIndex);
            glBindTexture(GL_TEXTURE_2D, textureIndex);
            glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_FALSE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 
                         [_texture size].width, [_texture size].height, 0, 
                         GL_RGBA, GL_UNSIGNED_BYTE, 
                         [bmp bitmapData]);
        }
        glBindTexture(GL_TEXTURE_2D, textureIndex);
    }
    
    glBegin(GL_QUADS); 
    {
        [[self baseColor] setToOpenGL];
        glVertex3f(-1,  1, -1); //F T L
        glTexCoord2f(0, 0);
        glVertex3f( 1,  1, -1); //F T R
        glTexCoord2f(1, 0);
        glVertex3f( 1, -1, -1); //F B R
        glTexCoord2f(1, 1);
        glVertex3f(-1, -1, -1); //F B L
        glTexCoord2f(0, 1);
        
        glVertex3f(-1, -1, -1); //F B L   
        glTexCoord2f(0, 0);
        glVertex3f( 1, -1, -1); //F B R
        glTexCoord2f(1, 0);
        glVertex3f( 1, -1,  1); //B B R
        glTexCoord2f(1, 1);
        glVertex3f(-1, -1,  1); //B B L
        glTexCoord2f(0, 1);
        
        glVertex3f(-1,  1,  1); //B T L
        glTexCoord2f(0, 0);
        glVertex3f( 1,  1,  1); //B T R
        glTexCoord2f(1, 0);
        glVertex3f( 1, -1,  1); //B B R
        glTexCoord2f(1, 1);
        glVertex3f(-1, -1,  1); //B B L
        glTexCoord2f(0, 1);
        
        glVertex3f(-1,  1,  1); //B T L
        glTexCoord2f(0, 0);
        glVertex3f(-1,  1, -1); //F T L
        glTexCoord2f(1, 0);
        glVertex3f(-1, -1, -1); //F B L
        glTexCoord2f(1, 1);
        glVertex3f(-1, -1,  1); //B B L
        glTexCoord2f(0, 1);
        
        glVertex3f(-1,  1,  1); //B T L
        glTexCoord2f(0, 0);
        glVertex3f( 1,  1,  1); //B T R
        glTexCoord2f(1, 0);
        glVertex3f( 1,  1, -1); //F T R
        glTexCoord2f(1, 1);
        glVertex3f(-1,  1, -1); //F T L
        glTexCoord2f(0, 1);
        
        glVertex3f( 1,  1, -1); //F T R
        glTexCoord2f(0, 0);
        glVertex3f( 1,  1,  1); //B T R
        glTexCoord2f(1, 0);
        glVertex3f( 1, -1,  1); //B B R
        glTexCoord2f(1, 1);
        glVertex3f( 1, -1, -1); //F B R
        glTexCoord2f(0, 1);
        
    }
    glEnd();
}

@end
