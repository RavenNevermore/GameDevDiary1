//
//  MyListGameController.m
//  GameDevDiary1
//
//  Created by Joshua Hagedorn on 01.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyListGameController.h"

@implementation MyListGameController

@dynamic centerDistance, latitude, longitude;

- (id)init {
    self = [super init];
    if (self) {
        controllers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setupInput{}

- (void) addController:(NSObject<MyGameController> *)controller {
    if (![controllers containsObject:controller]){
        [controllers addObject:controller];
    }
    NSResponder* lastResponder = self;
    for (NSObject<MyGameController>*  c in controllers) {
        if ([c isKindOfClass:[NSResponder class]]){
            NSResponder* r = (NSResponder*)c;
            [lastResponder setNextResponder:r];
            lastResponder = r;
        }
    }
}

- (float)centerDistance{
    int s = 0;
    float total = 0;
    for (NSObject<MyGameController>* c in controllers) {
        s++;
        total += [c centerDistance];
    }
    return 0 == s?0:total/s;
}

- (float)latitude{
    int s = 0;
    float total = 0;
    for (NSObject<MyGameController>* c in controllers) {
        s++;
        total += [c latitude];
    }
    return 0 == s?0:total/s;
}

- (float)longitude{
    int s = 0;
    float total = 0;
    for (NSObject<MyGameController>* c in controllers) {
        s++;
        total += [c longitude];
    }
    return 0 == s?0:total/s;
}

@end
