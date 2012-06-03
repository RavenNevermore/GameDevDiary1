//
//  MyOpenGLView.h
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenAl/al.h>
#import "MyCube.h"
#import "MyGameController.h"

@interface MyOpenGLView : NSOpenGLView {
    long lastTicks;
    ALuint satelitteALSourceId;
    NSObject<MyGameController>* controller;
    float cameraLat, cameraLon, cameraDist;
    GLuint aRavenTex;
}

@property (retain) MyCube* mainCube;
@property (retain) MyCube* flyingCube;
@property IBOutlet Boolean axisVisible;

- (IBAction) toggleAxisVisible:(id)sender;

@end
