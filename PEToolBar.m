//
//  PEToolBar.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEToolBar.h"

@implementation PEToolBar

/*
 * So far the only purpose for this class to override the drawRect method so as to make the background transparent
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // nothing here makes the background transparent
}


@end
