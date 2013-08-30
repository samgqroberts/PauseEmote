//
//  LoggedEmotionsManager.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/22/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEEmotionsManager.h"
#import "PEUtil.h"

#define DEFAULT_EMOTION_COLOR @"#959595"

@interface PEEmotionsManager ()

@property NSArray *emotionNames;
@property NSDictionary *emotionColors;
@property NSDictionary *emotionIntensities;

@end

@implementation PEEmotionsManager

@synthesize emotionIntensities;
@synthesize emotionColors;
@synthesize emotionNames;
@synthesize ownerEmotions;

+ (PEEmotionsManager *)sharedSingleton
{
    static PEEmotionsManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[PEEmotionsManager alloc] init];
        
        return sharedSingleton;
    }
}

- (id) init {
    self = [super init];
    if (self) {
        
        self.ownerEmotions = [NSMutableDictionary dictionary];
        
        self.emotionNames = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Emotions" ofType:@"plist"]];
        
        self.emotionColors = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmotionColors" ofType:@"plist"]];
        
        self.emotionIntensities = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmotionIntensities" ofType:@"plist"]];
        
        [self populateOwnerEmotions];
        
    }
    return self;
}

- (NSString *)getEmotionNameAtIndex:(int)index {
    return [self.emotionNames objectAtIndex:index];
}

- (int)getEmotionNameCount {
    return [self.emotionNames count];
}

- (NSString *)getTextForEmotionNamed:(NSString *)emotionName atIntensity:(float)intensity {
    if ([self.emotionNames containsObject:emotionName]) {
        return [((NSArray *)[self.emotionIntensities objectForKey:emotionName]) objectAtIndex:intensity/2];
    }
    //else it's custom
    return [NSString stringWithFormat:@"%@ %@", [((NSArray *)[self.emotionIntensities objectForKey:[self.emotionNames objectAtIndex:[self.emotionNames count]-1]]) objectAtIndex:intensity/2], emotionName ];
}

- (UIColor *)getColorForEmotionNamed:(NSString *)emotionName {
    if (!emotionName) { // no intensities for any emotion logged
        return [PEUtil colorFromHexString:DEFAULT_EMOTION_COLOR];
    }
    if ([self.emotionNames containsObject:emotionName]) {
        // it's either not custom or it's called @"Pick Your Own"
        return [PEUtil colorFromHexString:[self.emotionColors objectForKey:emotionName]];
    }
    else {
        // it's dat custom color
        return [PEUtil colorFromHexString:[self.emotionColors objectForKey:@"Pick Your Own"]];
    }
}

- (NSString *) getDominantEmotionForEmotions:(NSArray *)emotionsArray {
    NSString *returnString;
    int highestIntensity = 0;
    NSMutableDictionary *intensities = [NSMutableDictionary dictionary];
    for (NSString *name in self.emotionNames) {
        [intensities setValue:[NSNumber numberWithFloat:0.0] forKey:name];
    }
    for (PEEmotion *emotion in emotionsArray) {
        for (id key in emotion.intensities) {
            if ([intensities objectForKey:key]) {
                NSNumber *one = [intensities objectForKey:key];
                NSNumber *two = [emotion.intensities objectForKey:key];
                NSNumber *sum = [NSNumber numberWithFloat:([one floatValue] + [two floatValue])];
                [intensities setObject:sum forKey:key];
            }
            // custom emotion
            else {
                NSNumber *one = [intensities objectForKey:[self.emotionNames objectAtIndex:[self.emotionNames count]-1 ]];
                NSNumber *two = [emotion.intensities objectForKey:key];
                NSNumber *sum = [NSNumber numberWithFloat:([one floatValue] + [two floatValue])];
                [intensities setObject:sum forKey:[self.emotionNames objectAtIndex:[self.emotionNames count]-1 ]];
            }
        }
    }
    for (id key in intensities) {
        if ( [(NSNumber *)[intensities objectForKey:key] floatValue] >= highestIntensity ) {
            returnString = (NSString *)key;
            highestIntensity = [(NSNumber *)[intensities objectForKey:key] floatValue];
        }
    }
    return returnString;
}

- (void) addEmotion: (PEEmotion *)emotion {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:emotion.dateCreated];
    NSString *year = [NSString stringWithFormat:@"%d", [dateComponents year]];
    NSString *month = [NSString stringWithFormat:@"%d", [dateComponents month]];
    NSString *day = [NSString stringWithFormat:@"%d", [dateComponents day]];
    if (![self.ownerEmotions objectForKey: year]) {
        [self.ownerEmotions setValue: [NSMutableDictionary dictionary] forKey: year ];
    }
    if (![(NSMutableDictionary *)[self.ownerEmotions objectForKey: year] objectForKey: month]) {
        [(NSMutableDictionary *)[self.ownerEmotions objectForKey: year] setValue:[NSMutableDictionary dictionary] forKey:month];
    }
    if (![(NSMutableDictionary *)[(NSMutableDictionary *)[self.ownerEmotions objectForKey: year] objectForKey: month] objectForKey: day]) {
        [(NSMutableDictionary *)[(NSMutableDictionary *)[self.ownerEmotions objectForKey: year] objectForKey: month] setValue:[NSMutableArray array] forKey:day];
    }
    [(NSMutableArray *)[(NSMutableDictionary *)[(NSMutableDictionary *)[self.ownerEmotions objectForKey: year] objectForKey: month] objectForKey:day] addObject:emotion];
}

- (NSArray *) getEmotionsForDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSString *year = [NSString stringWithFormat:@"%d", [dateComponents year]];
    NSString *month = [NSString stringWithFormat:@"%d", [dateComponents month]];
    NSString *day = [NSString stringWithFormat:@"%d", [dateComponents day]];
    if (![self.ownerEmotions objectForKey: year]) {
        return nil;
    }
    if (![(NSMutableDictionary *)[self.ownerEmotions objectForKey: year] objectForKey: month]) {
        return nil;
    }
    if (![(NSMutableDictionary *)[(NSMutableDictionary *)[self.ownerEmotions objectForKey: year] objectForKey: month] objectForKey: day]) {
        return nil;
    }
    return (NSArray *)[(NSMutableDictionary *)[(NSMutableDictionary *)[self.ownerEmotions objectForKey: year] objectForKey: month] objectForKey:day];
}

// ATTN FUTURE DEVELOPERS: this is a cluster F of an html-parser
// there are libraries out there that will achieve a similar thing better
// and this is so specific to the current server format it's not even funny
-(void) populateOwnerEmotions {
    
    //get info from server
    NSURL *url = [NSURL URLWithString:@"http://betwixt.myzen.co.uk/pause/query.php"];
    NSString *webData= [NSString stringWithContentsOfURL:url];
    
    // parse this mother (hold onto your butts...)
    NSArray *components = [webData componentsSeparatedByString:@"tr>"];
    NSArray *subComponents;
    BOOL pastFirst;
    BOOL skipSecond;
    BOOL atOwner;
    BOOL shouldContinue;
    BOOL expectingIntensity;
    NSRange tdRange = NSMakeRange(0, [@"<td>" length]);
    NSError *error = NULL;
    NSDataDetector *dateDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:&error];
    NSString *newSubComponent;
    PEEmotion *emotion;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableDictionary *intensities;
    NSString *emotionName;
    NSString *strangeCharacters;
    NSString *strangeCharacter;
    NSString *phoneName = [[UIDevice currentDevice] name];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    for (NSString *component in components) {
        //check if longer than <td>
        if ([component length] <= [@"<td>" length]) {
            continue;
        }
        //check if starts with <td>
        if (![[component substringWithRange:tdRange] isEqualToString: @"<td>"]) {
            continue;
        }
        
        // separate by <td> tags
        subComponents = [component componentsSeparatedByString:@"td>"];
        
        skipSecond = false;
        atOwner = false;
        pastFirst = false;
        shouldContinue = false;
        expectingIntensity = false;
        emotion = nil;
        
        // loop over each cell in table
        for (NSString *subComponent in subComponents) {
            
            if ( [subComponent length] <= [@"<" length] ) {
                continue;
            }
            
            if ( [subComponent characterAtIndex:0] == '<') {
                continue;
            }
            
            if (skipSecond) {
                skipSecond = false;
                atOwner = TRUE;
                continue;
            }
            
            newSubComponent = [subComponent stringByReplacingOccurrencesOfString:@"</" withString:@""];
            
            
            if (atOwner) {
                // when the apostrophe in Amy's iPhone's name gets sent to server it gets replaced with something then gets sent back as ‚Äô...
                strangeCharacter = [phoneName substringWithRange:NSMakeRange(13, 1)];
                strangeCharacters = [newSubComponent stringByReplacingOccurrencesOfString:@"‚Äô" withString:strangeCharacter];

                if([[[UIDevice currentDevice] name] isEqualToString: newSubComponent] || [[[UIDevice currentDevice] name] isEqualToString:strangeCharacters]) {
                    [emotion setOwner:newSubComponent];
                    atOwner = false;
                    continue;
                }
                // else, this is of no interest to us
                atOwner = false;
                shouldContinue = true;
                break;
            }
            
            // check if first subComponent is a date
            if (!pastFirst) {
                
                if ([dateDetector numberOfMatchesInString:newSubComponent options:0 range:NSMakeRange(0, [newSubComponent length])] == 0) {
                    shouldContinue = TRUE;
                    break;
                }
                
                emotion = [[PEEmotion alloc] init];
                intensities = [NSMutableDictionary dictionary];
                [emotion setDateCreated: [dateFormatter dateFromString:newSubComponent]];
                [emotion setDateCreated:[emotion.dateCreated dateByAddingTimeInterval:-3600]]; //THIS IS A HACKY WAY TO RESOLVE THE TIME BEING +1 HOUR FROM THE SERVER
                pastFirst = TRUE;
                skipSecond = TRUE;
                
                continue;
                
            }
            
            if ([self.emotionNames containsObject: newSubComponent]) {
                emotionName = newSubComponent;
                continue;
            }
            
            if (emotionName != nil) {
                if ([intensities count] == [self.emotionNames count] - 1) {
                    emotion.customEmotion = emotionName;
                }
                [intensities setValue: [NSNumber numberWithFloat:[newSubComponent floatValue]] forKey:emotionName];
                emotionName = nil;
                continue;
            }
            
            if ([intensities count] == [self.emotionNames count] - 1) {
                emotionName = newSubComponent;
                continue;
            }
            
            if ([intensities count] == [self.emotionNames count]) {
                emotion.comment = newSubComponent;
                break;
            }
            
            
        }
        
        if (shouldContinue) {
            shouldContinue = false;
            continue;
        }
        
        // make sure emotion has all necessary parts
        if ([intensities count] != [self.emotionNames count] || !emotion.dateCreated|| !emotion.customEmotion || !emotion.comment) {
            continue;
        }
        emotion.intensities = [NSDictionary dictionaryWithDictionary:intensities];
        
        [self addEmotion:emotion];
        
    }
    NSLog(@"%@", self.ownerEmotions);
}

@end
