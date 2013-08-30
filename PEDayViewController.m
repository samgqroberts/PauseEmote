//
//  DayViewController.m
//  Pause Emote
//
//  Created by Sam  Roberts on 8/23/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEDayViewController.h"
#import "PEEmotionsManager.h"
#import "PEToolBar.h"
#import "PEUtil.h"
#import "PENavigationController.h"
#import "PEEmotion.h"
#import <QuartzCore/QuartzCore.h>
#import "PEDayCell.h"
#import "PEDayTableView.h"

// miscellaneous
#define TITLE_TEXT_COLOR @"#959595"
#define CELL_TEXT_COLOR @"#d5d5d6"
#define HORIZ_SWIPE_DRAG_MIN 50

// dimensions
#define SUBMIT_ICON_WIDTH 45.0
#define SUBMIT_ICON_HEIGHT 45.0
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
#define ADD_ICON_WIDTH 36.0
#define ADD_ICON_HEIGHT 32.0
#define TITLE_LABEL_FONT_SIZE 20.0
#define CELL_FONT_SIZE_NOEMOTIONS 16.0
#define CELL_HEIGHT 58.0
#define CELL_SELECTED_HEIGHT 120.0

@interface PEDayViewController ()


@property int calendarSubIconY;
@property NSMutableArray *rowHeights;
@property PEEmotionsManager *lem;
@property UIButton *searchButton;
@property UIButton *weekButton;
@property UIButton *monthButton;
@property NSArray *currentEmotions;
@property NSArray *emotions;
@property NSDictionary *emotionColors;

@end

@implementation PEDayViewController


CGPoint mystartTouchPosition;
BOOL isProcessingListMove;
BOOL viewJustLoaded;

@synthesize calendarSubIconY;
@synthesize rowHeights;
@synthesize emotionColors;
@synthesize emotions;
@synthesize currentEmotions;
@synthesize currentDate;
@synthesize searchButton;
@synthesize weekButton;
@synthesize monthButton;
@synthesize lem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    // register custom tableview and cell
    self.tableView = [[PEDayTableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.navigationController.navigationBar.frame.size.height)];
    [self.tableView registerClass: [PEDayCell class] forCellReuseIdentifier:@"DayViewCell"];
    
    // init LEM
    lem = [PEEmotionsManager sharedSingleton];
    
    //get info from plists
    emotions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Emotions" ofType:@"plist"]];
    
    emotionColors = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"EmotionColors" ofType: @"plist"]];
    
    // background
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogFeelingsBackground.png"]];
    self.tableView.backgroundView = imageView;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // initialize date
    [self initDateInfo];
    
    // initialize nav bar
    [self initNavigationBar];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initDateInfo {
    // if we haven't been passed the date, take today's date
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
    
    self.currentEmotions = [lem getEmotionsForDate:self.currentDate];
    if (!self.currentEmotions) {
    }
    else {
        self.rowHeights = [NSMutableArray array];
        for (int i = 0 ; i < [currentEmotions count] ; i++) {
            [self.rowHeights addObject:[NSNumber numberWithFloat:height_factor(CELL_HEIGHT)]];
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
    
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:CALENDAR_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(calendarClicked)]];
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
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:SETTINGS_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(settingsClicked)]];
    [buttons addObject: settingsButton];
    
    // create a spacer between the buttons
    spacer = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
              target:nil
              action:nil];
    spacer.width = width_factor(LEFT_TOOLBAR_RIGHT_SPACER_WIDTH);
    [buttons addObject:spacer];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:ADD_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(addClicked)]];
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
    title.text = [PENavigationController getTitleForDate:self.currentDate forViewType:DAY_VIEW_TYPE];
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
    searchButton = [PENavigationController getButtonOfType:SEARCH_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(searchClicked)];
    [self.tableView insertSubview:searchButton atIndex:0];
    searchButton.hidden = TRUE;
    self.calendarSubIconY = searchButton.frame.origin.y;
    }
    if (weekButton) {
        weekButton.hidden = TRUE;
    }
    else {
    weekButton = [PENavigationController getButtonOfType:WEEK_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(weekClicked)];
    [self.tableView insertSubview:weekButton atIndex:0];
    weekButton.hidden = TRUE;
    }
    if (monthButton) {
        monthButton.hidden = TRUE;
    }
    else {
    monthButton = [PENavigationController getButtonOfType:MONTH_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(monthClicked)];
    [self.tableView insertSubview:monthButton atIndex:0];
    monthButton.hidden = TRUE;
    }
    
}

- (void) addClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:LOG_VIEW_TYPE];
}

- (void) calendarClicked {
    self.searchButton.hidden = !self.searchButton.hidden;
    self.weekButton.hidden = !self.weekButton.hidden;
    self.monthButton.hidden = !self.monthButton.hidden;
}

- (void) settingsClicked {
    NSLog(@"settingsClicked");
}

- (void) searchClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:SEARCH_VIEW_TYPE];
}

- (void) weekClicked {
        [((PENavigationController *)self.navigationController) pushViewControllerOfType:WEEK_VIEW_TYPE];
}

- (void) monthClicked {
        [((PENavigationController *)self.navigationController) pushViewControllerOfType:MONTH_VIEW_TYPE];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    self.searchButton.frame = CGRectMake(self.searchButton.frame.origin.x, self.calendarSubIconY + scrollView.contentOffset.y, self.searchButton.frame.size.width, self.searchButton.frame.size.height);
    self.weekButton.frame = CGRectMake(self.weekButton.frame.origin.x, self.calendarSubIconY + scrollView.contentOffset.y, self.weekButton.frame.size.width, self.weekButton.frame.size.height);
    self.monthButton.frame = CGRectMake(self.monthButton.frame.origin.x, self.calendarSubIconY + scrollView.contentOffset.y, self.monthButton.frame.size.width, self.monthButton.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.currentEmotions) {
        return 1;
    }
    return [self.currentEmotions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [(NSNumber *)[self.rowHeights objectAtIndex:indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DayViewCell";
    PEDayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell removeLabels];
    
    UIColor *cellColor;
    
    if (!self.currentEmotions) {
        cellColor = [UIColor clearColor];
        [cell.contentView setBackgroundColor:cellColor];
        [cell updateLabelsWithTime:@"" withComment:@"No emotions today!"];
        cell.commentLabel.textColor = [UIColor blackColor];
        return cell;
    }
    
    PEEmotion *emotion = (PEEmotion *)[self.currentEmotions objectAtIndex:indexPath.row];
    
    cellColor = [lem getColorForEmotionNamed:[emotion dominantEmotion]];
    
    cell.textLabel.text = @"";
    cell.contentView.backgroundColor = cellColor;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [PEUtil colorFromHexString:CELL_TEXT_COLOR];
    
    if ([(NSNumber *)[rowHeights objectAtIndex:indexPath.row] floatValue] == height_factor(CELL_SELECTED_HEIGHT)) {
        [self updateLabelsForCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (void) updateLabelsForCell: (PEDayCell *)cell atIndexPath: (NSIndexPath *)indexPath {
    PEEmotion *emotion = (PEEmotion *)[self.currentEmotions objectAtIndex:indexPath.row];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:emotion.dateCreated];
    NSString *hour = [NSString stringWithFormat:@"%d", [components hour]];
    NSString *minute = [NSString stringWithFormat:@"%d", [components minute]];
    //the 0 will get cut off if the int was <10
    if ([hour length] == 1) {
        hour = [@"0" stringByAppendingString:hour];
    }
    if ([minute length] == 1) {
        minute = [@"0" stringByAppendingString:minute];
    }
    NSString *time = [NSString stringWithFormat:@"%@:%@",hour,minute];
    [cell updateLabelsWithTime:time withComment:emotion.comment];
    cell.timeLabel.textColor = [PEUtil colorFromHexString:CELL_TEXT_COLOR];
    cell.commentLabel.textColor = [PEUtil colorFromHexString:CELL_TEXT_COLOR];
    if ([emotion.dominantEmotion isEqualToString:@"Joy"]) {
        cell.timeLabel.textColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
        cell.commentLabel.textColor = [PEUtil colorFromHexString:TITLE_TEXT_COLOR];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.currentEmotions) {
        return;
    }
    PEDayCell *cell = (PEDayCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([(NSNumber *)[self.rowHeights objectAtIndex:indexPath.row] floatValue] == CELL_HEIGHT) {
        // change to selected
        [self updateLabelsForCell:cell atIndexPath:indexPath];
        [self.rowHeights replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:CELL_SELECTED_HEIGHT]];
    }
    else {
        // back to unselected
        [cell removeLabels];
        [self.rowHeights replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:CELL_HEIGHT]];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint newTouchPosition = [touch locationInView:self.tableView];
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
    [components setDay:[components day] + (nextDay?1:-1)];
    self.currentDate = [cal dateByAddingComponents:components toDate: self.currentDate options:0];
    self.currentDate = [cal dateFromComponents:components];
    [self refreshView];
}

-(void)refreshView {
    [self initDateInfo];
    [self initNavigationBar];
    
    [self.tableView reloadData];
}

@end
