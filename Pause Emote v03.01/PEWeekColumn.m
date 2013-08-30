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

@property UILabel *dayLabel;
@property UIView *parentView;

@end

@implementation PEWeekColumn

@synthesize parentView;
@synthesize date;
@synthesize dayLabel;
@synthesize day = _day;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setDay:(NSInteger *)day {
    _day = day;
    if (!self.dayLabel) {
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(width_factor(DAY_LABEL_X), height_factor(DAY_LABEL_Y), width_factor(DAY_LABEL_WIDTH), height_factor(DAY_LABEL_HEIGHT))];
        [self addSubview:self.dayLabel];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.font = [UIFont systemFontOfSize:height_factor(DAY_LABEL_FONT_SIZE)];
        self.dayLabel.textColor = [PEUtil colorFromHexString:DAY_LABEL_TEXT_COLOR];
    }
    self.dayLabel.text = [NSString stringWithFormat:@"%d", (int)day];
    
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
