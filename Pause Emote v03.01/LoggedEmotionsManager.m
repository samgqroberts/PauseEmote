//
//  LoggedEmotionsManager.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/22/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "LoggedEmotionsManager.h"

@implementation LoggedEmotionsManager

+ (LoggedEmotionsManager *)sharedSingleton
{
    static LoggedEmotionsManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[LoggedEmotionsManager alloc] init];
        
        return sharedSingleton;
    }
}

- (id) init {
    self = [super init];
    if (self) {
        //get info from server
        NSURL *url = [NSURL URLWithString:@"http://betwixt.myzen.co.uk/pause/query.php"];
        NSString *webData= [NSString stringWithContentsOfURL:url];
        NSLog(@"%@",webData);
    }
    return self;
}

@end
