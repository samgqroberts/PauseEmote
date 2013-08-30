//
//  PEEmotion.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/22/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEEmotion.h"

@implementation PEEmotion

@synthesize dominantEmotion = _dominantEmotion;
@synthesize dominantIntensity = _dominantIntensity;
@synthesize dateCreated;
@synthesize intensities;
@synthesize customEmotion;
@synthesize comment;

-(NSString *)description {
    return [NSString stringWithFormat:@"/nowner: %@, date created: %@, custom emotion: %@, comment: %@intensities: %@", self.owner, self.dateCreated, self.customEmotion, self.comment, self.intensities];
}

-(NSString *)dominantEmotion {
    if (!_dominantEmotion) {
        [self calculateDominantEmotionAndIntensity];
    }
    return _dominantEmotion;
}

-(float)dominantIntensity {
    if (!_dominantEmotion) {
        [self calculateDominantEmotionAndIntensity];
    }
    return _dominantIntensity;
}

-(void)calculateDominantEmotionAndIntensity {
    NSString *domEmotion;
    float domIntensity = 0;
    for (id key in self.intensities) {
        if ([(NSNumber *)[self.intensities objectForKey:key] floatValue] >= domIntensity) {
            domIntensity = [(NSNumber *)[self.intensities objectForKey:key] floatValue];
            domEmotion = (NSString *)key;
        }
    }
    if (domIntensity==0) {
        domEmotion = nil;
    }
    _dominantEmotion = domEmotion;
    _dominantIntensity = domIntensity;
}

@end
