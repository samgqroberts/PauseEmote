//
//  PEMonthViewController.m
//  Pause Emote
//
//  Created by Sam  Roberts on 8/27/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEMonthViewController.h"
#import "PEToolBar.h"
#import "PEUtil.h"
#import "PENavigationController.h"
#import "PEMonthView.h"

//miscellaneous
#define TITLE_TEXT_COLOR @"#959595"

//dimensions
#define RIGHT_TOOLBAR_WIDTH 100.0
#define RIGHT_TOOLBAR_HEIGHT 32.0
#define RIGHT_TOOLBAR_SPACER_WIDTH 41.0
#define LEFT_TOOLBAR_WIDTH 100.0
#define LEFT_TOOLBAR_HEIGHT 45.0
#define LEFT_TOOLBAR_LEFT_SPACER_WIDTH -9.0
#define LEFT_TOOLBAR_RIGHT_SPACER_WIDTH 5.0
#define TITLE_LABEL_FONT_SIZE 17.0
#define HEADER_BAR_HEIGHT 30.0

@interface PEMonthViewController ()

@property UIView *headerBar;
@property UIButton *searchButton;
@property UIButton *dayButton;
@property UIButton *weekButton;

@end

@implementation PEMonthViewController

@synthesize searchButton;
@synthesize dayButton;
@synthesize weekButton;
@synthesize headerBar;
@synthesize currentDate;

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
    
    // init view
    self.view = [[PEMonthView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.navigationController.navigationBar.frame.size.height)];
    
    //init date info
    [self initDateInfo];
    
    //init nav bar
    [self initNavigationBar];
    
    //load view contents
    [self loadViewContents];
    
}

- (void)initDateInfo {
    // if we haven't been passed the date, take today's date
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
}

- (void)initNavigationBar {
    // add buttons to navbar
    // create a toolbar where we can place some buttons
    PEToolBar* toolbar = [[PEToolBar alloc]
                          initWithFrame:CGRectMake(0, 0, width_factor(RIGHT_TOOLBAR_WIDTH), height_factor(RIGHT_TOOLBAR_HEIGHT))];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setBackgroundColor: [UIColor clearColor]];
    toolbar.translucent = YES;
    
    // create an array for the buttons
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    // create a spacer between the buttons
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    spacer.width = width_factor(RIGHT_TOOLBAR_SPACER_WIDTH) ;
    [buttons addObject:spacer];
    
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:CALENDAR_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(calendarClicked)]];
    [buttons addObject:calendarButton];
    
    // put the buttons in the toolbar and release them
    [toolbar setItems:buttons animated:NO];
    
    // place the toolbar into the navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:toolbar];
    
    toolbar = [[PEToolBar alloc]
               initWithFrame:CGRectMake(0, 0, width_factor(LEFT_TOOLBAR_WIDTH), height_factor(LEFT_TOOLBAR_HEIGHT))];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setBackgroundColor: [UIColor clearColor]];
    toolbar.translucent = YES;
    
    buttons = [[NSMutableArray alloc] initWithCapacity: 6];
    
    spacer = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
              target:nil
              action:nil];
    spacer.width = width_factor(LEFT_TOOLBAR_LEFT_SPACER_WIDTH);
    [buttons addObject:spacer];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:SETTINGS_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(settingsClicked)]];
    [buttons addObject: settingsButton];
    
    // create a spacer between the buttons
    spacer = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
              target:nil
              action:nil];
    spacer.width = width_factor(LEFT_TOOLBAR_RIGHT_SPACER_WIDTH);
    [buttons addObject:spacer];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:ADD_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(addClicked)]];
    [buttons addObject: addButton];
    
    // spacer between add button and title
    spacer = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
              target:nil
              action:nil];
    spacer.width = width_factor(LEFT_TOOLBAR_RIGHT_SPACER_WIDTH);
    [buttons addObject:spacer];
    
    // title label
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 45)];
    title.text = [PENavigationController getTitleForDate:self.currentDate forViewType:MONTH_VIEW_TYPE];
    title.font = [UIFont boldSystemFontOfSize: height_factor(TITLE_LABEL_FONT_SIZE)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:title];
    [buttons addObject:titleButton];
    
    [toolbar setItems:buttons animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    if (searchButton) {
        searchButton.hidden = TRUE;
    }
    else {
        // initialize the sub-calendar buttons
        searchButton = [PENavigationController getButtonOfType:SEARCH_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(searchClicked)];
        [self.view insertSubview:searchButton atIndex:0];
        searchButton.hidden = TRUE;
    }
    
    if (dayButton) {
        dayButton.hidden = TRUE;
    }
    else {
        dayButton = [PENavigationController getButtonOfType:DAY_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(dayClicked)];
        [self.view insertSubview:dayButton atIndex:0];
        dayButton.hidden = TRUE;
    }
    
    if (weekButton) {
        weekButton.hidden = TRUE;
    }
    else {
        weekButton = [PENavigationController getButtonOfType:WEEK_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(weekClicked)];
        [self.view insertSubview:weekButton atIndex:0];
        weekButton.hidden = TRUE;
    }

}

- (void)loadViewContents {
    [self loadHeaderBar];
}

- (void)loadHeaderBar {
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, height_factor(HEADER_BAR_HEIGHT));
    if (!headerBar) {
        headerBar = [[UIView alloc] init];
    }
    else {
        [headerBar removeFromSuperview];
    }
    headerBar.frame = frame;
    headerBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:headerBar];
}

- (void)settingsClicked {
    
}

- (void) addClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:LOG_VIEW_TYPE];
}

- (void) calendarClicked {
    self.searchButton.hidden = !self.searchButton.hidden;
    self.dayButton.hidden = !self.weekButton.hidden;
    self.weekButton.hidden = !self.weekButton.hidden;
}

- (void)searchClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:SEARCH_VIEW_TYPE];
}

- (void)dayClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:DAY_VIEW_TYPE];
}

- (void)weekClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:WEEK_VIEW_TYPE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
