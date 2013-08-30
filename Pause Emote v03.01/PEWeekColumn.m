//
//  PEWeekCell.m
//  Pause Emote
//
//  Created by Sam  Roberts on 8/29/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEWeekColumn.h"
#import "PEUtil.h"

//miscellaneous
#define DAY_LABEL_TEXT_COLOR @"#d5d5d6"

//dimensions
#define DAY_LABEL_X 5.0
#define DAY_LABEL_Y 1.0
#define DAY_LABEL_WIDTH 30.0
#define DAY_LABEL_HEIGHT 20.0
#define DAY_LABEL_FONT_SIZE 12.0

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
