//
//  PEFeelingsCell.h
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEFeelingsCell : UITableViewCell

@property float intensity;
@property UIView *intensityView;
@property NSString *emotion;

- (void)initForEmotion:(NSString *)emotionName withColor:(UIColor *)feelingColor;
-(float)newIntensityWidth:(float)newIntensityWidth;

@end
