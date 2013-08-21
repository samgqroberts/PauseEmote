//
//  PELogFeelingsTableView.h
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/20/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PELogFeelingsTableView;

@protocol PELogFeelingsTableViewDelegate <NSObject>

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface PELogFeelingsTableView : UITableView

@end
