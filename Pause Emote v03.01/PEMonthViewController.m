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
#import "PEEmotionsManager.h"
#import "PEEmotion.h"
#import <QuartzCore/QuartzCore.h>
#import "PEMonthCell.h"

//miscellaneous
#define TITLE_TEXT_COLOR @"#959595"
#define NUM_WEEKDAYS 7 //one might think it's silly to save the number of days in the week to a macro but gosh dangit i'm not having any hardcoded values in MY code if i can help it!
#define HORIZ_SWIPE_DRAG_MIN 50

//dimensions
#define RIGHT_TOOLBAR_WIDTH 100.0
#define RIGHT_TOOLBAR_HEIGHT 32.0
#define RIGHT_TOOLBAR_SPACER_WIDTH 41.0
#define LEFT_TOOLBAR_WIDTH 100.0
#define LEFT_TOOLBAR_HEIGHT 45.0
#define LEFT_TOOLBAR_LEFT_SPACER_WIDTH -9.0
#define LEFT_TOOLBAR_RIGHT_SPACER_WIDTH 5.0
#define TITLE_LABEL_FONT_SIZE 15.0
#define HEADER_BAR_HEIGHT 30.0
#define HEADER_LABEL_Y 9.0
#define HEADER_LABEL_FONT_SIZE 13.0

@interface PEMonthViewController ()

@property UIView *headerBar;
@property UIView *leftBorder;
@property UIView *rightBorder;
@property UIButton *searchButton;
@property UIButton *dayButton;
@property UIButton *weekButton;
@property NSDateComponents *currentDateComponents;
@property int numberOfRows;
@property int cellHeight;
@property int cellWidth;
@property NSMutableArray *emotionColorArray;
@property PEEmotionsManager *lem;
@property int lastDayWeekday;
@property int firstDayWeekday;

@end

@implementation PEMonthViewController

CGPoint mystartTouchPosition;
BOOL isProcessingListMove;

@synthesize leftBorder;
@synthesize rightBorder;
@synthesize firstDayWeekday;
@synthesize lastDayWeekday;
@synthesize lem;
@synthesize emotionColorArray;
@synthesize numberOfRows;
@synthesize currentDateComponents;
@synthesize cellHeight;
@synthesize cellWidth;
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

- (void)viewWillAppear:(BOOL)animated {
    [self refreshView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init singleton
    lem = [PEEmotionsManager sharedSingleton];
    
    // init view
    [self initView];
    
    //init date info
    [self initDateInfo];
    
    //init nav bar
    [self initNavigationBar];
    
}

- (void)initDateInfo {
    // if we haven't been passed the date, take today's date
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
    NSCalendar *cal = [NSCalendar currentCalendar];
    currentDateComponents = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:self.currentDate];
    
    /*
     * calculate the number of rows needed to represent the current month
     */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // get number of days in the current month
    NSRange daysRange =
    [calendar
     rangeOfUnit:NSDayCalendarUnit
     inUnit:NSMonthCalendarUnit
     forDate:self.currentDate];
    int numDaysInCurrentMonth = daysRange.length;
    
    //get last day in current month
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit fromDate:self.currentDate];
    [comps setDay:numDaysInCurrentMonth];
    NSDate *lastDayOfMonth = [calendar dateFromComponents:comps];
    
    //get weekday of last day in current month (1=sunday, 7=saturday)
    comps = [calendar components:NSWeekdayCalendarUnit fromDate:lastDayOfMonth];
    self.lastDayWeekday = [comps weekday];
    
    //all months are at least 28 days, at most 31, so...
    if (numDaysInCurrentMonth%NUM_WEEKDAYS > self.lastDayWeekday) {
        self.numberOfRows = 6;
    }
    else {
        self.numberOfRows = 5;
    }
    
    // Now figure out dimensions based on that
    self.cellWidth = [[UIScreen mainScreen] bounds].size.width/NUM_WEEKDAYS;
    self.cellHeight = ([[UIScreen mainScreen] bounds].size.height-[UIApplication sharedApplication].statusBarFrame.size.height-self.navigationController.navigationBar.frame.size.height-height_factor(HEADER_BAR_HEIGHT))/self.numberOfRows;
    
    // determine border widths by remaining (rounded) pixels
    int remainingPixels = self.view.frame.size.width - (self.cellWidth*NUM_WEEKDAYS);
    remainingPixels = remainingPixels/2 + 1;
    self.leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0,0,remainingPixels, self.view.frame.size.height)];
    self.rightBorder = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - remainingPixels, 0, remainingPixels, self.view.frame.size.height)];
    self.leftBorder.backgroundColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
    self.rightBorder.backgroundColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
    [self.view addSubview:self.leftBorder];
    [self.view addSubview:self.rightBorder];
    
    [self loadHeaderBar];
    
    /*
     * Populate Emotion Array with relevant emotions for the month
     */
    
    //get weekday of first day in month
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:self.currentDate]; // cut off the day
    NSDate *firstDayOfMonth = [calendar dateFromComponents:comps];
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
    self.firstDayWeekday = [comps weekday];
    
    //get first day of calendar (dat sunday)
    [comps setDay: [comps day]-(self.firstDayWeekday-1)];
    NSDate *currentDay = [calendar dateFromComponents:comps];
    
    //iterate over every day in calendar and get the dominant emotion color
    if (!self.emotionColorArray) {
        self.emotionColorArray = [NSMutableArray array];
    }
    NSMutableArray *currentRow;
    UIColor *currentColor;
    NSArray *emotionsForCurrentDay;
    PEMonthCell *currentCell;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDay];
    NSDateComponents *secondComps;
    
    for (int row = 0; row < self.numberOfRows; row++) {
        currentRow = [NSMutableArray arrayWithCapacity:NUM_WEEKDAYS];
        [self.emotionColorArray insertObject:currentRow atIndex:row];
        
        for (int column = 0; column < NUM_WEEKDAYS; column++) {
            emotionsForCurrentDay = [lem getEmotionsForDate:currentDay];
            currentCell = [[PEMonthCell alloc] initWithFrame:CGRectMake(self.leftBorder.frame.size.width + self.cellWidth*column, self.cellHeight*row + self.headerBar.frame.size.height, cellWidth, cellHeight)];
            currentCell.layer.borderColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR].CGColor;
            currentCell.layer.borderWidth = 0.6f;
            [currentCell addTarget:self action:@selector(cellClicked:) forControlEvents:UIControlEventTouchUpInside];
            currentCell.date = [[NSDate alloc] initWithTimeInterval:0 sinceDate:currentDay];
            secondComps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDay];
            currentCell.day = [secondComps day];
            if (emotionsForCurrentDay) {
                currentColor = [lem getColorForEmotionNamed:[lem getDominantEmotionForEmotions:emotionsForCurrentDay]];
                [currentRow insertObject:[lem getColorForEmotionNamed:[lem getDominantEmotionForEmotions:emotionsForCurrentDay]] atIndex:column];
            }
            else {
                currentColor = [UIColor whiteColor];
                [currentRow insertObject:[NSNull null] atIndex:column];
            }
            currentCell.backgroundColor = currentColor;
            [self.view addSubview:currentCell];
            [comps setDay: [comps day]+1];
            currentDay = [calendar dateFromComponents:comps];
        }
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
        [searchButton removeFromSuperview];
        [self.view addSubview:searchButton];
        searchButton.hidden = TRUE;
    }
    else {
        // initialize the sub-calendar buttons
        searchButton = [PENavigationController getButtonOfType:SEARCH_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(searchClicked)];
        [self.view addSubview:searchButton];
        searchButton.hidden = TRUE;
    }
    
    if (dayButton) {
        [dayButton removeFromSuperview];
        [self.view addSubview:dayButton];
        dayButton.hidden = TRUE;
    }
    else {
        dayButton = [PENavigationController getButtonOfType:DAY_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(dayClicked)];
        [self.view addSubview:dayButton];
        dayButton.hidden = TRUE;
    }
    
    if (weekButton) {
        [weekButton removeFromSuperview];
        [self.view addSubview:weekButton];
        weekButton.hidden = TRUE;
    }
    else {
        weekButton = [PENavigationController getButtonOfType:WEEK_BUTTON_TYPE forViewOfType:MONTH_VIEW_TYPE withTarget:self withSelector:@selector(weekClicked)];
        [self.view addSubview:weekButton];
        weekButton.hidden = TRUE;
    }

}

- (void)loadHeaderBar {
    CGRect frame = CGRectMake(self.leftBorder.frame.size.width, 0, [[UIScreen mainScreen] bounds].size.width - 2*self.leftBorder.frame.size.width, height_factor(HEADER_BAR_HEIGHT));
    if (!headerBar) {
        headerBar = [[UIView alloc] init];
    }
    else {
        [headerBar removeFromSuperview];
    }
    headerBar.frame = frame;
    headerBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerBar];
    NSArray *weekdays = [NSArray arrayWithObjects:@"sun",@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",nil];
    for (int i = 0 ; i < NUM_WEEKDAYS ; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.leftBorder.frame.size.width + self.cellWidth*i, height_factor(HEADER_LABEL_Y), self.cellWidth, height_factor(HEADER_BAR_HEIGHT))];
        label.font = [UIFont systemFontOfSize:height_factor(HEADER_LABEL_FONT_SIZE)];
        label.textColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
        label.text = (NSString *)[weekdays objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    
}

- (void)cellClicked:(id)sender {
    if ([sender class] != [PEMonthCell class]) {
        NSLog(@"WARNING: non-PEMonthCell sent to cellClicked action");
        return;
    }
    PEMonthCell *cell = (PEMonthCell *)sender;
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:DAY_VIEW_TYPE withArgument:cell.date];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint newTouchPosition = [touch locationInView:self.view];
	if(mystartTouchPosition.x != newTouchPosition.x || mystartTouchPosition.y != newTouchPosition.y) {
		isProcessingListMove = NO;
	}
	mystartTouchPosition = [touch locationInView:self.view];
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = touches.anyObject;
	CGPoint currentTouchPosition = [touch locationInView:self.view];
	
	// If the swipe tracks correctly.
	double diffx = mystartTouchPosition.x - currentTouchPosition.x + 0.1; // adding 0.1 to avoid division by zero
	double diffy = mystartTouchPosition.y - currentTouchPosition.y + 0.1; // adding 0.1 to avoid division by zero
	
	if(abs(diffx / diffy) > 1 && abs(diffx) > HORIZ_SWIPE_DRAG_MIN)
	{
		// It appears to be a swipe.
		if(isProcessingListMove) {
			// ignore move, we're currently processing the swipe
			return;
		}
		
		if (mystartTouchPosition.x < currentTouchPosition.x) {
			isProcessingListMove = YES;
			[self moveToDay:FALSE];
			return;
		}
		else {
			isProcessingListMove = YES;
			[self moveToDay:TRUE];
			return;
		}
	}
	else if(abs(diffy / diffx) > 1)
	{
		isProcessingListMove = YES;
		[super touchesMoved:touches	withEvent:event];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	isProcessingListMove = NO;
	[super touchesEnded:touches withEvent:event];
}

-(void)moveToDay:(BOOL)nextDay {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:self.currentDate];
    [components setMonth:[components month] + (nextDay?1:-1)];
    self.currentDate = [cal dateByAddingComponents:components toDate: self.currentDate options:0];
    self.currentDate = [cal dateFromComponents:components];
    [self refreshView];
}

- (void) initView {
    self.view = [[PEMonthView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.navigationController.navigationBar.frame.size.height)];
    
    self.view.backgroundColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
}

-(void) refreshView {
    [self initView];
    [self initDateInfo];
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
