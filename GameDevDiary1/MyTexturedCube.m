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

+ (float*)defaultTextureCoords{
    float* coords = malloc(sizeof(float[48]));
    for (int i = 0;  i < 6; i++) {
        int x = 8 * i;
        coords[0+x] = 0.0f; coords[1+x] = 0.0f;
        coords[2+x] = 1.0f; coords[3+x] = 0.0f;
        coords[4+x] = 1.0f; coords[5+x] = 1.0f;
        coords[6+x] = 0.0f; coords[7+x] = 1.0f;
    }
    return coords;
}

+ (float *)threeByTwoCoords{
    float* coords = malloc(sizeof(float[48]));
    for (int i = 0;  i < 6; i++) {
        int row = i / 3; // 0, 0, 0, 1, 1, 1
        int col = i % 3; // 0, 1, 2, 0, 1, 2
        
        float ax = col/3.0;
        float ay = 1.0 / (row+1);
        float bx = (col+1)/3.0;
        float by = ay;
        float cx = bx;
        float cy = ay - .5;
        float dx = ax;
        float dy = cy;
        
        NSLog(@"%f | %f  :  %f | %f  :  %f | %f  :  %f | %f",
              ax, ay, bx, by, cx, cy, dx, dy);
        
        int x = 8 * i;
        coords[0+x] = dx; coords[1+x] = dy;
        coords[2+x] = cx; coords[3+x] = cy;
        coords[4+x] = bx; coords[5+x] = by;
        coords[6+x] = ax; coords[7+x] = ay;
    }
    return coords;
}

- (id)init{
    self = [super init];
    textureIndex = -1;
    return self;
}

- (NSImage *)texture{
    return _texture;
}

- (void)setTexture:(NSImage *)texture{
    [self   setTexture:texture 
       withCoordinates:[MyTexturedCube defaultTextureCoords]];
}

- (void)setTexture:(NSImage *)texture withCoordinates:(float*)coords{
    _texture = texture;
    textureIndex = -1;
    for (int i = 0; i < 48; i++) {
        textureCoords[i] = coords[i];
    }
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
            glTexImage2D(GL_TEXTURE_2D, 0, 
                         [bmp hasAlpha] ? GL_RGBA : GL_RGB, 
                         [_texture size].width, [_texture size].height, 0, 
                         [bmp hasAlpha] ? GL_RGBA : GL_RGB, 
                         GL_UNSIGNED_BYTE, 
                         [bmp bitmapData]);
        }
        glBindTexture(GL_TEXTURE_2D, textureIndex);
    }
    
    glBegin(GL_QUADS); 
    {
        [[self baseColor] setToOpenGL];
        
        glTexCoord2f(textureCoords[ 0], textureCoords[ 1]);
        glVertex3f(-1,  1, -1); //F T L
        glTexCoord2f(textureCoords[ 2], textureCoords[ 3]);
        glVertex3f( 1,  1, -1); //F T R
        glTexCoord2f(textureCoords[ 4], textureCoords[ 5]);
        glVertex3f( 1, -1, -1); //F B R
        glTexCoord2f(textureCoords[ 6], textureCoords[ 7]);
        glVertex3f(-1, -1, -1); //F B L
        
        glTexCoord2f(textureCoords[ 8], textureCoords[ 9]);
        glVertex3f(-1, -1, -1); //F B L   
        glTexCoord2f(textureCoords[10], textureCoords[11]);
        glVertex3f( 1, -1, -1); //F B R
        glTexCoord2f(textureCoords[12], textureCoords[13]);
        glVertex3f( 1, -1,  1); //B B R
        glTexCoord2f(textureCoords[14], textureCoords[15]);
        glVertex3f(-1, -1,  1); //B B L
        
        glTexCoord2f(textureCoords[16], textureCoords[17]);
        glVertex3f(-1,  1,  1); //B T L
        glTexCoord2f(textureCoords[18], textureCoords[19]);
        glVertex3f( 1,  1,  1); //B T R
        glTexCoord2f(textureCoords[20], textureCoords[21]);
        glVertex3f( 1, -1,  1); //B B R
        glTexCoord2f(textureCoords[22], textureCoords[23]);
        glVertex3f(-1, -1,  1); //B B L
        
        glTexCoord2f(textureCoords[24], textureCoords[25]);
        glVertex3f(-1,  1,  1); //B T L
        glTexCoord2f(textureCoords[26], textureCoords[27]);
        glVertex3f(-1,  1, -1); //F T L
        glTexCoord2f(textureCoords[28], textureCoords[29]);
        glVertex3f(-1, -1, -1); //F B L
        glTexCoord2f(textureCoords[30], textureCoords[31]);
        glVertex3f(-1, -1,  1); //B B L
        
        glTexCoord2f(textureCoords[32], textureCoords[33]);
        glVertex3f(-1,  1,  1); //B T L
        glTexCoord2f(textureCoords[34], textureCoords[35]);
        glVertex3f( 1,  1,  1); //B T R
        glTexCoord2f(textureCoords[36], textureCoords[37]);
        glVertex3f( 1,  1, -1); //F T R
        glTexCoord2f(textureCoords[38], textureCoords[39]);
        glVertex3f(-1,  1, -1); //F T L
        
        
        glTexCoord2f(textureCoords[40], textureCoords[41]);
        glVertex3f( 1,  1, -1); //F T R
        glTexCoord2f(textureCoords[42], textureCoords[43]);
        glVertex3f( 1,  1,  1); //B T R
        glTexCoord2f(textureCoords[44], textureCoords[45]);
        glVertex3f( 1, -1,  1); //B B R
        glTexCoord2f(textureCoords[46], textureCoords[47]);
        glVertex3f( 1, -1, -1); //F B R
        
        
    }
    glEnd();
}

@end
