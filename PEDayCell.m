//
//  PEDayCell.m
//  Pause Emote
//
//  Created by Sam  Roberts on 8/26/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEDayCell.h"
#import "PEUtil.h"

@implementation PEDayCell

// miscellaneous
#define TIME_LABEL_TAG 99
#define COMMENT_LABEL_TAG 98

//dimensions
#define COMMENT_LABEL_X 60.0
#define COMMENT_LABEL_WIDTH 250.0
#define TIME_LABEL_X 8.0
#define TIME_LABEL_Y 10.0
#define TIME_LABEL_WIDTH 50.0
#define TIME_LABEL_HEIGHT 20.0

@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)updateLabelsWithTime:(NSString *)time withComment:(NSString *)comment {
    
    [self removeLabels];
    [self addLabelsWithTime:time withComment:comment];
    [self.contentView setNeedsDisplay];
    
}

- (void) addLabelsWithTime:(NSString *)time withComment:(NSString *)comment{
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] init];
    }
    if (!self.commentLabel) {
        self.commentLabel = [[UITextView alloc] init];
    }
    self.timeLabel.frame = CGRectMake(width_factor(TIME_LABEL_X), height_factor(TIME_LABEL_Y), width_factor(TIME_LABEL_WIDTH), height_factor(TIME_LABEL_HEIGHT));
    self.timeLabel.text = time;
    self.timeLabel.tag = TIME_LABEL_TAG;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView insertSubview:self.timeLabel atIndex:0];
    self.commentLabel.tag = COMMENT_LABEL_TAG;
    self.commentLabel.frame = CGRectMake(width_factor(COMMENT_LABEL_X), 0, width_factor(COMMENT_LABEL_WIDTH), self.frame.size.height);
    self.commentLabel.text = comment;
    self.commentLabel.backgroundColor = [UIColor clearColor];
    self.commentLabel.editable = NO;
    self.commentLabel.userInteractionEnabled = NO;
    [self.contentView insertSubview:self.commentLabel atIndex:0];
    
    
    [self.contentView insertSubview:self.timeLabel atIndex: 0];
}

- (void) removeLabels {
    [self.timeLabel removeFromSuperview];
    [self.commentLabel removeFromSuperview];
    //    for (UIView *subview in [self.contentView subviews]) {
    //        if (subview.tag == TIME_LABEL_TAG || subview.tag == COMMENT_LABEL_TAG) {
    //            [subview removeFromSuperview];
    //        }
    //    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0,0,0,0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
