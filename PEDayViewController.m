//
//  DayViewController.m
//  Pause Emote
//
//  Created by Sam  Roberts on 8/23/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PEDayViewController.h"
#import "LoggedEmotionsManager.h"
#import "PEToolBar.h"
#import "PEUtil.h"
#import "PENavigationController.h"

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

@interface PEDayViewController ()

@property LoggedEmotionsManager *lem;
@property UIButton *searchButton;
@property UIButton *weekButton;
@property UIButton *monthButton;
@property NSDate *date;

@end

@implementation PEDayViewController

@synthesize date;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init LEM
    lem = [LoggedEmotionsManager sharedSingleton];
    
    // initialize search button
    UIImage *searchImage = [UIImage imageNamed:@"SearchIcon.png"];
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake( 161, 5, width_factor(SUBMIT_ICON_WIDTH), height_factor(SUBMIT_ICON_HEIGHT) );
    [searchButton addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:searchImage forState:UIControlStateNormal];
    [self.tableView insertSubview:searchButton atIndex:0];
    searchButton.hidden = TRUE;
    
    // initialize week button
    UIImage *weekImage = [UIImage imageNamed:@"WeekIcon.png"];
    weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weekButton.frame = CGRectMake( 214, 5, width_factor(SUBMIT_ICON_WIDTH), height_factor(SUBMIT_ICON_HEIGHT) );
    [weekButton addTarget:self action:@selector(weekClicked) forControlEvents:UIControlEventTouchUpInside];
    [weekButton setImage:weekImage forState:UIControlStateNormal];
    [self.tableView insertSubview:weekButton atIndex:0];
    weekButton.hidden = TRUE;
    
    // initialize month button
    UIImage *monthImage = [UIImage imageNamed:@"MonthIcon.png"];
    monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    monthButton.frame = CGRectMake( 267, 5, width_factor(SUBMIT_ICON_WIDTH), height_factor(SUBMIT_ICON_HEIGHT) );
    [monthButton addTarget:self action:@selector(monthClicked) forControlEvents:UIControlEventTouchUpInside];
    [monthButton setImage:monthImage forState:UIControlStateNormal];
    [self.tableView insertSubview:monthButton atIndex:0];
    monthButton.hidden = TRUE;
    
    // initialize date
    date = [NSDate date];
    
    [self initNavigationBar];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:CALENDAR_BUTTON_TYPE forViewOfType:DAY_BUTTON_TYPE withTarget:self withSelector:@selector(calendarClicked)]];
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
    
    buttons = [[NSMutableArray alloc] initWithCapacity: 4];
    
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
    
    
    [toolbar setItems:buttons animated:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    // initialize the sub-calendar buttons
    searchButton = [PENavigationController getButtonOfType:SEARCH_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(searchClicked)];
    [self.tableView insertSubview:searchButton atIndex:0];
    searchButton.hidden = TRUE;
    
    weekButton = [PENavigationController getButtonOfType:WEEK_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(weekClicked)];
    [self.tableView insertSubview:weekButton atIndex:0];
    weekButton.hidden = TRUE;
    
    monthButton = [PENavigationController getButtonOfType:MONTH_BUTTON_TYPE forViewOfType:DAY_VIEW_TYPE withTarget:self withSelector:@selector(monthClicked)];
    [self.tableView insertSubview:monthButton atIndex:0];
    monthButton.hidden = TRUE;
}

- (void) addClicked {
    [self.navigationController popToRootViewControllerAnimated:((PENavigationController *)self.navigationController).logFeelingsViewController];
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
    NSLog(@"searchclicked");
}

- (void) weekClicked {
    NSLog(@"weekclicked");
}

- (void) monthClicked {
    NSLog(@"monthclicked");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
