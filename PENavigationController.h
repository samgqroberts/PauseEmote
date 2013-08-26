//
//  PENavigationController.h
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PELogFeelingsViewController.h"

@interface PENavigationController : UINavigationController

@property PELogFeelingsViewController *logFeelingsViewController;

+ (UIButton *) getButtonOfType:(int)buttonType forViewOfType:(int)viewType withTarget:(id)target withSelector:(SEL)selector;

typedef enum {
    SETTINGS_BUTTON_TYPE,
    CALENDAR_BUTTON_TYPE,
    REFRESH_BUTTON_TYPE,
    ADD_BUTTON_TYPE,
    SEARCH_BUTTON_TYPE,
    DAY_BUTTON_TYPE,
    WEEK_BUTTON_TYPE,
    MONTH_BUTTON_TYPE,
} ButtonTypes;

typedef enum {
    LOG_VIEW_TYPE,
    DAY_VIEW_TYPE,
    WEEK_VIEW_TYPE,
    MONTH_VIEW_TYPE,
} ViewTypes;

@end
