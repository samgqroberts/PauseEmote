//
//  PENavigationController.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PENavigationController.h"
#import "PELogEmotionsViewController.h"
#import "PEDayViewController.h"
#import "PEMonthViewController.h"
#import "PEToolBar.h"
#import "PEUtil.h"

#define NAV_BAR_HEIGHT 52.0
#define RIGHT_TOOLBAR_WIDTH 100.0
#define RIGHT_TOOLBAR_HEIGHT 32.0
#define RIGHT_TOOLBAR_SPACER_WIDTH 41.0
#define LEFT_TOOLBAR_WIDTH 100.0
#define LEFT_TOOLBAR_HEIGHT 45.0
#define LEFT_TOOLBAR_LEFT_SPACER_WIDTH -9.0
#define LEFT_TOOLBAR_RIGHT_SPACER_WIDTH 5.0
#define CALENDAR_ICON_WIDTH 40.0
#define CALENDAR_ICON_HEIGHT 35.0
#define SETTINGS_ICON_WIDTH 37.0
#define SETTINGS_ICON_HEIGHT 33.0
#define REFRESH_ICON_WIDTH 36.0
#define REFRESH_ICON_HEIGHT 32.0
#define ADD_ICON_WIDTH 36.0
#define ADD_ICON_HEIGHT 32.0
#define CALENDAR_SUBICON_WIDTH 45.0
#define CALENDAR_SUBICON_HEIGHT 45.0
#define CALENDAR_SUBICON_SPACE 8.0
#define CALENDAR_SUBICON_STARTX 108.0
#define CALENDAR_SUBICON_Y 5.0

@interface UINavigationBar (myNave)
- (CGSize)changeHeight:(CGSize)size;
@end

@implementation UINavigationBar (customNav)
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width,height_factor(NAV_BAR_HEIGHT));
    return newSize;
}
@end

@interface PENavigationController ()

@end

@implementation PENavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // resize navbar background image to fit scale
    UIImage *originalImage = [UIImage imageNamed:@"NavBarBackground.png"];
    CGSize destinationSize = CGSizeMake(self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // set navbar background image to scaled image
    [self.navigationBar setBackgroundImage: newImage forBarMetrics: UIBarMetricsDefault];
    
}

+ (UIButton *) getButtonOfType:(int)buttonType forViewOfType:(int)viewType withTarget:(id)target withSelector:(SEL)selector {
    
    NSString *imageName;
    float width, height, x, y;
    x = y = 0;
    
    switch(buttonType) {
        case SETTINGS_BUTTON_TYPE:
            imageName = @"SettingsIcon.png";
            width = SETTINGS_ICON_WIDTH;
            height = SETTINGS_ICON_HEIGHT;
            break;
        case CALENDAR_BUTTON_TYPE:
            imageName = @"CalendarIcon.png";
            width = CALENDAR_ICON_WIDTH;
            height = CALENDAR_ICON_HEIGHT;
            break;
        case REFRESH_BUTTON_TYPE:
            imageName = @"RefreshIcon.png";
            width = REFRESH_ICON_WIDTH;
            height = REFRESH_ICON_HEIGHT;
            break;
        case ADD_BUTTON_TYPE:
            imageName = @"AddIcon.png";
            width = ADD_ICON_WIDTH;
            height = ADD_ICON_HEIGHT;
            break;
        case SEARCH_BUTTON_TYPE:
            imageName = @"SearchIcon.png";
            x = CALENDAR_SUBICON_STARTX + (CALENDAR_SUBICON_WIDTH+CALENDAR_SUBICON_SPACE)*((viewType==LOG_VIEW_TYPE)?0:1);
            y = CALENDAR_SUBICON_Y;
            width = CALENDAR_SUBICON_WIDTH;
            height = CALENDAR_SUBICON_HEIGHT;
            break;
        case DAY_BUTTON_TYPE:
            imageName = @"DayIcon.png";
            x = CALENDAR_SUBICON_STARTX + (CALENDAR_SUBICON_WIDTH+CALENDAR_SUBICON_SPACE)*((viewType==LOG_VIEW_TYPE)?1:2);
            y = CALENDAR_SUBICON_Y;
            width = CALENDAR_SUBICON_WIDTH;
            height = CALENDAR_SUBICON_HEIGHT;
            break;
        case WEEK_BUTTON_TYPE:
            imageName = @"WeekIcon.png";
            x = CALENDAR_SUBICON_STARTX + (CALENDAR_SUBICON_WIDTH+CALENDAR_SUBICON_SPACE)*((viewType==LOG_VIEW_TYPE)?2: ((viewType==DAY_VIEW_TYPE)?2:3) );
            y = CALENDAR_SUBICON_Y;
            width = CALENDAR_SUBICON_WIDTH;
            height = CALENDAR_SUBICON_HEIGHT;
            break;
        case MONTH_BUTTON_TYPE:
            imageName = @"MonthIcon.png";
            x = CALENDAR_SUBICON_STARTX + (CALENDAR_SUBICON_WIDTH+CALENDAR_SUBICON_SPACE)*3;
            y = CALENDAR_SUBICON_Y;
            width = CALENDAR_SUBICON_WIDTH;
            height = CALENDAR_SUBICON_HEIGHT;
            break;
        default:
            return nil;
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( x, y, width_factor(width), height_factor(height) );
    [button setImage:image forState: UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (NSString *)getTitleForDate:(NSDate *)date forViewType:(int)viewType {
    NSString *returnString;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *year = [NSString stringWithFormat:@"%d", [dateComponents year]];
    NSString *month = [NSString stringWithFormat:@"%d", [dateComponents month]];
    NSString *day = [NSString stringWithFormat:@"%d", [dateComponents day]];
    
    switch(viewType) {
        case DAY_VIEW_TYPE:
            returnString = [NSString stringWithFormat:@"< %@/%@/%@ >", month, day, year];
            break;
        case MONTH_VIEW_TYPE:
            returnString = [NSString stringWithFormat:@"< %@ %@ >", [df.monthSymbols objectAtIndex:[dateComponents month]-1], year];
            break;
        default:
            return nil;
    }
    
    return returnString;
}

- (void)pushViewControllerOfType:(int)viewType {
    [self pushViewControllerOfType:viewType withArgument:nil];
}

- (void)pushViewControllerOfType:(int)viewType withArgument:(id)arg{
    /*
     * Okay so the way this works is if the desired view type is on the stack
     * of view controllers, then pop to that instance of it.  If it's not on
     * the stack, make a new one and push it.
     */
    switch (viewType) {
        case LOG_VIEW_TYPE:
            for (UIViewController *vc in self.viewControllers) {
                if ([vc class] == [PELogEmotionsViewController class]) {
                    [self popToViewController:vc animated:YES];
                    return;
                }
            }
        {   // also, we need to switch-statement variable declarations in braces for some flippin reason
            PELogEmotionsViewController *levc = [[PELogEmotionsViewController alloc] initWithNibName:nil bundle:nil];
            [self pushViewController:levc animated:YES];
        }
            break;
        case SEARCH_VIEW_TYPE:
            NSLog(@"pushing search view");
            break;
        case DAY_VIEW_TYPE:  
            for (UIViewController *vc in self.viewControllers) {
                if ([vc class] == [PEDayViewController class]) {
                    if (arg) {
                        ((PEDayViewController *)vc).currentDate = (NSDate *)arg;
                    }
                    [self popToViewController:vc animated:YES];
                    return;
                }
            }
        {PEDayViewController *dvc = [[PEDayViewController alloc] initWithNibName:nil bundle:nil];
            if (arg) {
                dvc.currentDate = arg;
            }
            [self pushViewController:dvc animated:YES];
        } break;
        case WEEK_VIEW_TYPE:
            NSLog(@"pushing week view");
            break;
        case MONTH_VIEW_TYPE:
            for (UIViewController *vc in self.viewControllers) {
                if ([vc class] == [PEMonthViewController class]) {
                    [self popToViewController:vc animated:YES];
                    return;
                }
            }
        {
            PEMonthViewController *mvc = [[PEMonthViewController alloc] initWithNibName:nil bundle:nil];
            [self pushViewController:mvc animated:YES];
        }
            break;
        default:
            NSLog(@"WARNING: unknown view type sent to PENavigationController->pushViewControllerOfType");
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
