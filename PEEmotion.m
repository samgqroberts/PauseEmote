//
//  PEEmotion.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/22/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEEmotion.h"

@implementation PEEmotion

@synthesize dateCreated;
@synthesize intensities;
@synthesize customEmotion;
@synthesize owner;
@synthesize comment;

-(NSString *)description {
    return [NSString stringWithFormat:@"/nowner: %@, date created: %@, custom emotion: %@, comment: %@intensities: %@", self.owner, self.dateCreated, self.customEmotion, self.comment, self.intensities];
}

@end
