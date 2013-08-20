//
//  PEFeelingsCell.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEFeelingsCell.h"
#define INITIAL_INTENSITY_WIDTH 17
#define TEXT_SPACING 1


@interface PEFeelingsCell ()

@property float intensityWidth;

@end

@implementation PEFeelingsCell

@synthesize intensityWidth;
@synthesize intensity;
@synthesize intensityView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initIntensity:(UIColor *)feelingColor {
    [self setIntensityFrame: 0];
    [intensityView setBackgroundColor: feelingColor];
    [self.contentView addSubview: intensityView];
}

- (void) setIntensityFrame: (float)newIntensity {
    intensity = newIntensity;
    intensityWidth = (self.frame.size.width - INITIAL_INTENSITY_WIDTH)*intensity/10 + INITIAL_INTENSITY_WIDTH;
    CGRect intensityViewFrame = CGRectMake(0, 0, intensityWidth, self.frame.size.height);
    intensityView = [[UIView alloc] initWithFrame: intensityViewFrame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(INITIAL_INTENSITY_WIDTH + TEXT_SPACING, 0, self.frame.size.width - INITIAL_INTENSITY_WIDTH - TEXT_SPACING, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
