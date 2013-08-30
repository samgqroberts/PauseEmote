//
//  PEWeekViewController.m
//  Pause Emote
//
//  Created by Sam  Roberts on 8/27/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEWeekViewController.h"
#import "PEToolBar.h"
#import "PEUtil.h"
#import "PENavigationController.h"
#import "PEWeekView.h"
#import "PEEmotionsManager.h"
#import "PEEmotion.h"
#import <QuartzCore/QuartzCore.h>
#import "PEWeekColumn.h"

//miscellaneous
#define TITLE_TEXT_COLOR @"#959595"
#define NUM_WEEKDAYS 7 //one might think it's silly to save the number of days in the week to a macro but gosh dangit i'm not having any hardcoded values in MY code if i can help it!
#define NUM_DAYHOURS 24 //again
#define NUM_SECTIONSINHOUR 4 
#define HORIZ_SWIPE_DRAG_MIN 50
#define STARTING_HOUR 6 // start (and end) the view at 6am

//dimensions
#define RIGHT_TOOLBAR_WIDTH 100.0
#define RIGHT_TOOLBAR_HEIGHT 32.0
#define RIGHT_TOOLBAR_SPACER_WIDTH 41.0
#define LEFT_TOOLBAR_WIDTH 100.0
#define LEFT_TOOLBAR_HEIGHT 45.0
#define LEFT_TOOLBAR_LEFT_SPACER_WIDTH -9.0
#define LEFT_TOOLBAR_RIGHT_SPACER_WIDTH 5.0
#define TITLE_LABEL_FONT_SIZE 12.0
#define HEADER_BAR_HEIGHT 30.0
#define HEADER_LABEL_Y 9.0
#define HEADER_LABEL_FONT_SIZE 11.0
#define LEFT_SIDEBAR_WIDTH 19.0
#define LEFT_SIDEBAR_LABEL_X 2.0
#define LEFT_SIDEBAR_LABEL_WIDTH 16.0
#define LEFT_SIDEBAR_LABEL_HEIGHT 13.0
#define LEFT_SIDEBAR_FONT_SIZE 9.0
#define SECTION_HEIGHT 8.0

@interface PEWeekViewController ()

@property NSDate *firstWeekday;
@property NSDate *lastWeekday;
@property NSDateComponents *firstWeekdayComps;
@property UIView *headerBar;
@property UIView *leftSidebar;
@property UIView *rightBorder;
@property UIButton *searchButton;
@property UIButton *dayButton;
@property UIButton *monthButton;
@property NSDateComponents *currentDateComponents;
@property int numberOfRows;
@property int sectionHeight;
@property int cellWidth;
@property NSMutableArray *emotionColorArray;
@property PEEmotionsManager *lem;
@property int lastDayWeekday;
@property int firstDayWeekday;
@property PEWeekView *scrollView;

@end

@implementation PEWeekViewController

CGPoint mystartTouchPosition;
BOOL isProcessingListMove;

@synthesize lastWeekday;
@synthesize firstWeekday;
@synthesize firstWeekdayComps;
@synthesize scrollView;
@synthesize leftSidebar;
@synthesize rightBorder;
@synthesize firstDayWeekday;
@synthesize lastDayWeekday;
@synthesize lem;
@synthesize emotionColorArray;
@synthesize numberOfRows;
@synthesize currentDateComponents;
@synthesize sectionHeight;
@synthesize cellWidth;
@synthesize searchButton;
@synthesize dayButton;
@synthesize monthButton;
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

- (void) initView {
//    self.view = [[PEWeekView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.navigationController.navigationBar.frame.size.height)];
    self.scrollView = [[PEWeekView alloc] initWithFrame:CGRectMake(0, height_factor(HEADER_BAR_HEIGHT), [[UIScreen mainScreen] bounds].size.width, self.view.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake( [[UIScreen mainScreen] bounds].size.width, (height_factor(NUM_DAYHOURS)+1)*height_factor(NUM_SECTIONSINHOUR)*height_factor(SECTION_HEIGHT));
    [self.scrollView setContentOffset:CGPointMake(0, height_factor(NUM_SECTIONSINHOUR)*height_factor(SECTION_HEIGHT)*STARTING_HOUR) animated:YES];
    self.scrollView.parentController = self;
    [self.view addSubview:self.scrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    // get first weekday of week
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:self.currentDate];
    [comps setDay: [comps day] - ([comps weekday]-1)];
    self.firstWeekday = [calendar dateFromComponents:comps];
    
    // get last weekday of week
    [comps setDay: [comps day] + 6];
    self.lastWeekday = [calendar dateFromComponents:comps];
    
    self.firstWeekdayComps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:self.firstWeekday];
    
    // Now figure out dimensions
    self.cellWidth = (self.scrollView.frame.size.width-width_factor(LEFT_SIDEBAR_WIDTH))/NUM_WEEKDAYS;
    
    [self loadLeftSidebar];
    
    [self loadHeaderBar];
    
    NSDate *currentTime = [self.firstWeekday dateByAddingTimeInterval:0];
    NSDate *nextTime = [currentTime dateByAddingTimeInterval:900]; //900s = 15m
    for (int day = 0; day < NUM_WEEKDAYS; day++) {
        
        PEWeekColumn *currentColumn = [[PEWeekColumn alloc] initWithFrame:CGRectMake(self.leftSidebar.frame.size.width + day*((self.scrollView.frame.size.width - self.leftSidebar.frame.size.width)/NUM_WEEKDAYS), 0, ((self.scrollView.frame.size.width - self.leftSidebar.frame.size.width)/NUM_WEEKDAYS), self.scrollView.contentSize.height)];
        
        currentColumn.layer.borderColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR].CGColor;
        currentColumn.layer.borderWidth = 0.6f;
        
        currentColumn.date = [currentTime dateByAddingTimeInterval:0];
        [currentColumn addTarget:self action:@selector(columnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *dayEmotions = [lem getEmotionsForDate:currentTime];
        
        for (int section = 0; section < NUM_SECTIONSINHOUR*NUM_DAYHOURS; section++) {
            // find emotions in given section
            NSMutableArray *sectionEmotions = [NSMutableArray array];
            
            //find all emotions within this section
            for (PEEmotion *emotion in dayEmotions) {
                if ([PEWeekViewController date:emotion.dateCreated isBetweenDate:currentTime andDate:nextTime]) {
                    [sectionEmotions addObject:emotion];
                    NSLog(@"adding emotion with date: %@ between date: %@ and date: %@", emotion.dateCreated, currentTime, nextTime);
                }
            }
            
            //create a view befitting the type and quantity of emotions in this section
            for (int i = 0 ; i < [sectionEmotions count] ; i++) {
                PEEmotion *emotion = [sectionEmotions objectAtIndex:i];
                float width = currentColumn.frame.size.width/[sectionEmotions count];
                UIView *emotionView = [[UIView alloc] initWithFrame:CGRectMake(i*width, SECTION_HEIGHT*section, width, SECTION_HEIGHT)];
                emotionView.backgroundColor = [lem getColorForEmotionNamed: emotion.dominantEmotion];
                [emotionView setUserInteractionEnabled:NO];
                [currentColumn addSubview:emotionView];
            }
            
            currentTime = [nextTime dateByAddingTimeInterval:0];
            nextTime = [currentTime dateByAddingTimeInterval:900];
        }
        [self.scrollView addSubview:currentColumn];
    }
}

+ (BOOL) date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    return (([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));
}

- (void)loadLeftSidebar {
    CGRect frame = CGRectMake(0, 0, width_factor(LEFT_SIDEBAR_WIDTH),self.scrollView.frame.size.height);
    if (!self.leftSidebar) {
        self.leftSidebar = [[UIView alloc] init];
    }
    else {
        [self.leftSidebar removeFromSuperview];
    }
    self.leftSidebar.frame = frame;
    self.leftSidebar.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.leftSidebar];
    int hourHeight = height_factor(NUM_SECTIONSINHOUR)*height_factor(SECTION_HEIGHT);
    
    // add time marks
    for (int i = 0 ; i < NUM_DAYHOURS ; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width_factor(LEFT_SIDEBAR_LABEL_X),i*hourHeight, width_factor(LEFT_SIDEBAR_LABEL_WIDTH), height_factor(LEFT_SIDEBAR_LABEL_HEIGHT))];
        label.font = [UIFont systemFontOfSize:height_factor(LEFT_SIDEBAR_FONT_SIZE)];
        label.textColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
        label.text = [NSString stringWithFormat:@"%d", (1+(i-1)%12)==0?12:(1+(i-1)%12)];
        label.backgroundColor = [UIColor clearColor];
        [self.leftSidebar addSubview:label];
    }
}

- (void)loadHeaderBar {
    CGRect frame = CGRectMake(width_factor(LEFT_SIDEBAR_WIDTH), 0, [[UIScreen mainScreen] bounds].size.width - width_factor(LEFT_SIDEBAR_WIDTH), height_factor(HEADER_BAR_HEIGHT));
    self.headerBar = [[UIView alloc] init];
    self.headerBar.frame = frame;
    self.headerBar.backgroundColor = [UIColor whiteColor];
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, frame.size.height, self.headerBar.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR].CGColor;
    
    [self.headerBar.layer addSublayer:bottomBorder];
    
    [self.view addSubview:self.headerBar];
    NSArray *weekdays = [NSArray arrayWithObjects:@"sun",@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",nil];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.firstWeekday];
    NSDate *currentDay = [calendar dateFromComponents:currentComps];
    for (int i = 0 ; i < NUM_WEEKDAYS ; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.headerBar.frame.size.width/NUM_WEEKDAYS)*i, height_factor(HEADER_LABEL_Y), (self.headerBar.frame.size.width/NUM_WEEKDAYS), height_factor(HEADER_BAR_HEIGHT))];
        label.font = [UIFont systemFontOfSize:height_factor(HEADER_LABEL_FONT_SIZE)];
        label.textColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
        label.text = [NSString stringWithFormat:@"%@ %d", (NSString *)[weekdays objectAtIndex:i], [currentComps day]];
        [currentComps setDay: [currentComps day]+1];
        currentDay = [calendar dateFromComponents:currentComps];
        currentComps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDay];
        label.backgroundColor = [UIColor clearColor];
        [self.headerBar addSubview:label];
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
    title.text = [PENavigationController getTitleForDate:self.currentDate forViewType:WEEK_VIEW_TYPE];
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
        searchButton = [PENavigationController getButtonOfType:SEARCH_BUTTON_TYPE forViewOfType:WEEK_VIEW_TYPE withTarget:self withSelector:@selector(searchClicked)];
        [self.view addSubview:searchButton];
        searchButton.hidden = TRUE;
    }
    
    if (dayButton) {
        [dayButton removeFromSuperview];
        [self.view addSubview:dayButton];
        dayButton.hidden = TRUE;
    }
    else {
        dayButton = [PENavigationController getButtonOfType:DAY_BUTTON_TYPE forViewOfType:WEEK_VIEW_TYPE withTarget:self withSelector:@selector(dayClicked)];
        [self.view addSubview:dayButton];
        dayButton.hidden = TRUE;
    }
    
    if (monthButton) {
        [monthButton removeFromSuperview];
        [self.view addSubview:monthButton];
        monthButton.hidden = TRUE;
    }
    else {
        monthButton = [PENavigationController getButtonOfType:MONTH_BUTTON_TYPE forViewOfType:WEEK_VIEW_TYPE withTarget:self withSelector:@selector(monthClicked)];
        [self.view addSubview:monthButton];
        monthButton.hidden = TRUE;
    }
    
}

- (void)columnClicked:(id)sender {
    if ([sender class] != [PEWeekColumn class]) {
        NSLog(@"WARNING: non-PEWeekColumn sent to columnClicked action");
        return;
    }
    PEWeekColumn *column = (PEWeekColumn *)sender;
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:DAY_VIEW_TYPE withArgument:column.date];
}

- (void)settingsClicked {
    
}

- (void) addClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:LOG_VIEW_TYPE];
}

- (void) calendarClicked {
    self.searchButton.hidden = !self.searchButton.hidden;
    self.dayButton.hidden = !self.dayButton.hidden;
    self.monthButton.hidden = !self.monthButton.hidden;
}

- (void)searchClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:SEARCH_VIEW_TYPE];
}

- (void)dayClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:DAY_VIEW_TYPE];
}

- (void)monthClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:MONTH_VIEW_TYPE];
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
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit|NSDayCalendarUnit ) fromDate:self.currentDate];
    [components setDay:[components day] + (nextDay?7:-7)];
    self.currentDate = [cal dateByAddingComponents:components toDate: self.currentDate options:0];
    self.currentDate = [cal dateFromComponents:components];
    [self refreshView];
}

-(void) refreshView {
    [self.scrollView removeFromSuperview];
    [self.headerBar removeFromSuperview];
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
