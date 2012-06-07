//
//  MyOpenGLView.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyOpenGLView.h"
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <OpenAl/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <time.h>
#import <math.h>
#import "MyGamePadGameController.h"
#import "MyKeyboardGameController.h"
#import "MyMouseGameController.h"
#import "MyListGameController.h"
#import "MyRainbowCube.h"
#import "MyTexturedCube.h"

@implementation MyOpenGLView

@synthesize mainCube;
@synthesize flyingCube;
@synthesize axisVisible;

- (void)toggleAxisVisible:(id)sender {
    axisVisible = !axisVisible;
}

- (void)awakeFromNib{
    lastTicks = clock();
    self.mainCube = [[MyTexturedCube alloc] init];
    self.flyingCube = [[MyRainbowCube alloc] init];
    [mainCube setScale:1];
    [mainCube setPositionX:0 Y:0 Z:0];
    [mainCube setBaseColor:[NSColor whiteColor]];
    
    [(MyTexturedCube*)mainCube setTexture:[NSImage imageNamed:@"cube_tex.jpg"] 
                          withCoordinates:[MyTexturedCube threeByTwoCoords]];
    [flyingCube setScale:.2];
    [flyingCube setPositionX:5 Y:0 Z:0];
    cameraLat = 10;
    cameraLon = 0;
    cameraDist = 10;
    
    controller = [[MyListGameController alloc] init];
    [self setNextResponder: (MyListGameController*)controller];
    
    MyGamePadGameController* gamepad = [[MyGamePadGameController alloc] init];
    [gamepad setupInput];
    MyKeyboardGameController* keyb = [[MyKeyboardGameController alloc] init];
    [keyb setupInput];
    MyMouseGameController* mouse = [[MyMouseGameController alloc] init];
    [mouse setupInput];
    
    [(MyListGameController*)controller addController: gamepad];
    [(MyListGameController*)controller addController: keyb];
    [(MyListGameController*)controller addController: mouse];
    NSLog(@"Gamepad Controller initialized.");
    
    [[self window] setAcceptsMouseMovedEvents:YES];
    
    
    
    [super awakeFromNib];
}

- (BOOL)acceptsFirstResponder{
    return YES;
}

- (ALuint) loadAudioIntoSourceFromFile:(NSString*) filename 
                            withFormat:(ALenum) audioFormat{
    
    //clear the error cache
    ALenum lastError = alGetError(); 
    
    AudioFileID audioFileId;
    
    //get the file path from the app bundle
    NSString* path = [[NSBundle mainBundle] pathForResource:filename 
                                                     ofType:nil];

    //let OsX open the audio file
    NSURL* audioUrl = [NSURL fileURLWithPath:path];
    OSStatus openResult = AudioFileOpenURL((__bridge CFURLRef)audioUrl, 
                                           fsRdPerm, 0,
                                           &audioFileId);
    
    //handle errors
    if (openResult != 0){
        NSLog(@"cannot open file: %@",audioUrl);
        return -1;
    } else {
        NSLog(@"Loading Audio from file: %@ ...", audioUrl);
    }
    
    //prepare the buffer for OpenAL
    UInt64 outDataSize = 0;
	UInt32 thePropSize = sizeof(UInt64);
    AudioFileGetProperty(audioFileId,
                         kAudioFilePropertyAudioDataByteCount, 
                         &thePropSize, &outDataSize);
    UInt32 outSize = (UInt32) outDataSize;
    
    //read the audio data into the buffer
    void * audioData = malloc(outSize);
    AudioFileReadBytes(audioFileId, 
                       false, 0, 
                       &outSize, 
                       audioData);
	AudioFileClose(audioFileId); //close the file
    
    NSLog(@"Audio loaded. %d bytes of data", outSize);
    
    //create an OpenAL buffer from the data
    ALuint bufferId;
    alGenBuffers(1, &bufferId);
    
    lastError = alGetError();
    if (AL_NO_ERROR != lastError){
        NSLog(@"Error creating a new buffer: %d", lastError);
        return -1;
    }
    
    alBufferData(bufferId, audioFormat, audioData, outSize, 44100);
    
    lastError = alGetError();
    if (AL_NO_ERROR != lastError){
        NSLog(@"Error buffering the audio data: %d", lastError);
        return -1;
    }
    
    //create an OpenAL source, for the loaded sound
    ALuint sourceId;
    alGenSources(1, &sourceId);
    
    lastError = alGetError();
    if (AL_NO_ERROR != lastError){
        NSLog(@"Error creating a source: %d", lastError);
        return -1;
    }
    
    
    // attach the buffer to the source
	alSourcei(sourceId, AL_BUFFER, bufferId);
    free(audioData);
    
    return sourceId;
}

- (void)prepareOpenGL {
    // Synchronize buffer swaps with vertical refresh rate
    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
    
    ALenum lastError = alGetError();
    ALCdevice *soundDev = alcOpenDevice(NULL);
    ALCcontext *soundContext = alcCreateContext(soundDev, 0);
    alcMakeContextCurrent(soundContext);
    
    lastError = alGetError();
    if (AL_NO_ERROR != lastError){
        NSLog(@"Error loading sound device!");
        return;
    } else {
        NSLog(@"Sound device loaded successfully!");
    }
    
    satelitteALSourceId = [self loadAudioIntoSourceFromFile:@"satellite.wav"
                                                 withFormat:AL_FORMAT_MONO16];
    
	// set some basic source prefs
	alSourcef(satelitteALSourceId, AL_PITCH, 1.0f);
	alSourcef(satelitteALSourceId, AL_GAIN, 1.0f);
	alSourcei(satelitteALSourceId, AL_LOOPING, AL_TRUE);
    
    lastError = alGetError();
    if (AL_NO_ERROR != lastError){
        NSLog(@"Error attaching the buffer to the source: %d", lastError);
        return;
    }
    
    //set Basic 3d sound parameters
    alListener3f(AL_POSITION, 0, 0, 0);
    alSource3f(satelitteALSourceId, AL_POSITION, 0, 0, 1);
    
    lastError = alGetError();
    if (AL_NO_ERROR != lastError){
        NSLog(@"Error setting 3d sound parameters: %d", lastError);
        return;
    }
    
    alSourcePlay(satelitteALSourceId);
    
    // start background musik
    ALuint backgroundMusikId = [self loadAudioIntoSourceFromFile:@"Farewell.wav" withFormat:AL_FORMAT_STEREO16];
    alSourcef(backgroundMusikId, AL_PITCH, 1.0f);
	alSourcef(backgroundMusikId, AL_GAIN, 0.01f);
	alSourcei(backgroundMusikId, AL_LOOPING, AL_TRUE);
    alSource3f(backgroundMusikId, AL_POSITION, 0, 0, 1);
    alSourcePlay(backgroundMusikId);
    
    
    
    NSImage* img = [NSImage imageNamed:@"raven.png"];
    NSBitmapImageRep* bmp = [[NSBitmapImageRep alloc] initWithData:
                             [img TIFFRepresentation]];

    glGenTextures(1, &aRavenTex);
    glBindTexture(GL_TEXTURE_2D, aRavenTex);
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_FALSE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 
                 [img size].width, [img size].height, 0, 
                 GL_RGBA, GL_UNSIGNED_BYTE, 
                 [bmp bitmapData]);

}

- (void)reshape {
    NSRect rect = [self bounds];

    glViewport(0, 0, rect.size.width, rect.size.height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(50, rect.size.width/rect.size.height, .1, 30);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glEnable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable( GL_BLEND );
    glEnable(GL_TEXTURE_2D);
}

- (void) drawAxis {
    glDisable(GL_TEXTURE_2D);
    glBegin(GL_LINES);
    glColor3f(1, 0, 0);
    glVertex3f(-10, 0, 0);
    glVertex3f(10, 0, 0);
    glColor3f(0, 1, 0);
    glVertex3f(0, -10, 0);
    glVertex3f(0, 10, 0);
    glColor3f(0, 0, 1);
    glVertex3f(0, 0, -10);
    glVertex3f(0, 0, 10);
    glEnd();
    glEnable(GL_TEXTURE_2D);
}

- (void)drawRect:(NSRect)dirtyRect {
    long ticks = clock();
    //delta_t in millis.
    long t = ticks/(CLOCKS_PER_SEC/1000);
    int delta_t = (int)((ticks - lastTicks)/(CLOCKS_PER_SEC/1000));
    int fps = delta_t > 0?(int) 1000/delta_t:1000;
    
    //setup camera base values
    cameraLat = cameraLat+([controller latitude] * delta_t*.05);
    while (cameraLat >= 2*pi)
        cameraLat -= 2*pi;
    while (cameraLat <= -2*pi)
        cameraLat += 2*pi;
    cameraLon = cameraLon+([controller longitude] * delta_t*.005);
    while (cameraLon >= 2*pi)
        cameraLon -= 2*pi;
    while (cameraLon <= -2*pi)
        cameraLon += 2*pi;
    cameraDist = cameraDist+([controller centerDistance] * delta_t*.05);
    
    double camX = sinf(cameraLat)*cameraDist;
    double camY = sinf(cameraLon)*cameraDist;
    double camZ = cosf(cameraLat)*cosf(cameraLon)*cameraDist;
    
    [[self window] setTitle:[NSString stringWithFormat:@"%d fps [%f/%f/%f]", 
                             fps, camX, camY, camZ]];
    lastTicks = ticks;
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0, 0, 0, 0);
    
    [mainCube setRotationAngle:[mainCube rotationAngle]+(.2*delta_t)];
    
    
    [flyingCube setPositionX:sinf(t*.025)*4 Y:0 Z:cosf(t*.025)*2];
    alSource3f(satelitteALSourceId, AL_POSITION, 
               [flyingCube positionX], 
               [flyingCube positionY], 
               [flyingCube positionZ]);
    
    glLoadIdentity();
    
    gluLookAt(camX, 
              camY,
              camZ, 
              0, 0, 0, 
              0, 1, 0);
    alListener3f(AL_POSITION, 
                 camX, 
                 camY,  
                 camZ);
    
    if (axisVisible)
        [self drawAxis];
    
    [mainCube draw];
    [flyingCube draw];
    
    glPushMatrix();
    glDisable(GL_TEXTURE_2D);
    glBegin(GL_QUADS);
    glColor3f(.5, 0, 0);
    glVertex3f(50,  -10, 50);
    glColor3f(0, .5, 0);
    glVertex3f(-50, -10, 50);
    glColor3f(0, 0, .5);
    glVertex3f(-50, -10, -50);
    glColor3f(.5, .5, 0);
    glVertex3f(50,  -10, -50);
    glEnd();
    glEnable(GL_TEXTURE_2D);
    glPopMatrix();
    
    /*
     * set orthographic projection
     */
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    long width = [self bounds].size.width;
    long height = [self bounds].size.height;
    glOrtho(0, width, 0, height, 0, 1);
        
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glLoadIdentity();
    glDisable(GL_DEPTH_TEST);
    
    
    glBindTexture(GL_TEXTURE_2D, aRavenTex);
    glBegin(GL_QUADS);
    glColor3f(1, 1, 1);
    glTexCoord2f(0, 0);
    glVertex2f(50, 150);
    glTexCoord2f(1, 0);
    glVertex2f(150, 150);
    glTexCoord2f(1, 1);
    glVertex2f(150, 50);
    glTexCoord2f(0, 1);
    glVertex2f(50, 50);
    glEnd();
    
    /*
     * reset the projection mode to whatever was before
     */
    glPopMatrix();
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glEnable(GL_DEPTH_TEST);
    
    glFlush();
    
    [self setNeedsDisplay:YES];
}

@end
