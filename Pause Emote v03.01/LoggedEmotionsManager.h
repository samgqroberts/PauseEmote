//
//  LoggedEmotionsManager.h
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/22/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEEmotion.h"

@interface LoggedEmotionsManager : NSObject

+ (LoggedEmotionsManager *) sharedSingleton;
- (void) addEmotion: (PEEmotion *)emotion;
@property NSMutableDictionary *ownerEmotions;

@end
