//
//  PEWeekCell.m
//  Pause Emote
//
//  Created by Sam  Roberts on 8/29/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEWeekColumn.h"
#import "PEUtil.h"

@interface PEWeekColumn ()

@property UIView *parentView;

@end

@implementation PEWeekColumn

@synthesize parentView;
@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    parentView = [self superview];
    [parentView touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [parentView touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [parentView touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    [parentView touchesEnded:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}


@end
