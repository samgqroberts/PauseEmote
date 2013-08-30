//
//  PEFeelingsCell.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEFeelingsCell.h"
#define INITIAL_INTENSITY_WIDTH 17
#define INTENSITY_VIEW_TAG 99
#define TEXT_SPACING 1


@interface PEFeelingsCell ()

@property float intensityWidth;

@end

@implementation PEFeelingsCell

@synthesize customEmotionField;
@synthesize customEmotion;
@synthesize emotion;
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

- (void)initForEmotion:(NSString *)emotionName withColor:(UIColor *)feelingColor {
    [self setIntensityFrame: 0];
    self.emotion = emotionName;
    [intensityView setBackgroundColor: feelingColor];
}

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        NSLog(@"%@", subview);
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

-(void) initCustomEmotionTextField {
    if (!self.customEmotionField) {
        CGRect frame;
        if ([self.emotion isEqualToString:@"Pick Your Own"]) {
            frame = CGRectMake(20,0,self.frame.size.width-40,self.frame.size.height);
        }
        else { // Comment cell
            frame = CGRectMake(0,0,self.frame.size.width-80,self.frame.size.height);
        }
        self.textLabel.text = @"";
        self.customEmotionField = [[UITextView alloc] initWithFrame:frame];
        [self.contentView addSubview: self.customEmotionField];
    }
}

- (void) initCustomEmotion:(NSString *)newCustomEmotion {
    if (!self.customEmotion) {
        self.customEmotion = [[NSString alloc] initWithString: newCustomEmotion];
    }
    [self.customEmotionField removeFromSuperview];
}

- (void) setIntensityFrame: (float)newIntensity {
    intensity = newIntensity;
    intensityWidth = (self.frame.size.width - INITIAL_INTENSITY_WIDTH)*intensity/10 + INITIAL_INTENSITY_WIDTH;
    
    [self removeIntensityView];
    [self addIntensityView];
}

- (float) newIntensityWidth: (float)newIntensityWidth {
    if (newIntensityWidth <= INITIAL_INTENSITY_WIDTH) {
        [self setIntensityFrame:0];
        return 0;
    }
    intensityWidth = newIntensityWidth;
    intensity = 10 * (intensityWidth - INITIAL_INTENSITY_WIDTH) / (self.frame.size.width - INITIAL_INTENSITY_WIDTH);
    
    [self removeIntensityView];
    [self addIntensityView];
    [self.contentView setNeedsDisplay];
    
    return intensity;
}

- (void) removeIntensityView {
    for (UIView *subview in [self.contentView subviews]) {
        if (subview.tag == INTENSITY_VIEW_TAG) {
            [subview removeFromSuperview];
        }
    }
}

- (void) addIntensityView {
    if (!intensityView) {
        intensityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, intensityWidth, self.frame.size.height)];
        intensityView.tag = INTENSITY_VIEW_TAG;
        [intensityView setUserInteractionEnabled:NO];
    }
    else {
        intensityView.frame = CGRectMake(0, 0, intensityWidth, self.frame.size.height);
    }
    [self.contentView insertSubview:intensityView atIndex: 0];
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
