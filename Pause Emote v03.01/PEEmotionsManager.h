//
//  LoggedEmotionsManager.h
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/22/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEEmotion.h"

@interface PEEmotionsManager : NSObject

+ (PEEmotionsManager *) sharedSingleton;
- (void) addEmotion: (PEEmotion *)emotion;
- (NSArray *) getEmotionsForDate:(NSDate *)date;
- (NSString *) getDominantEmotionForEmotions:(NSArray *)emotionsArray;
- (UIColor *)getColorForEmotionNamed:(NSString *)emotionName;


@property NSMutableDictionary *ownerEmotions;

@end
