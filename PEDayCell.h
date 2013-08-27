//
//  PEDayCell.h
//  Pause Emote
//
//  Created by Sam  Roberts on 8/26/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDayCell : UITableViewCell

@property UILabel *timeLabel;
@property UITextView *commentLabel;

- (void)updateLabelsWithTime:(NSString *)time withComment:(NSString *)comment;
- (void)removeLabels;


@end
