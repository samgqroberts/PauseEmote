//
//  PEEmotion.h
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/22/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEEmotion : NSObject

@property NSDate *dateCreated;
@property NSDictionary *intensities;
@property NSString *customEmotion;
@property NSString *owner;
@property NSString *comment;

-(NSString *)getDominantEmotion;

-(NSString *)description;

@end
