//
//  PELogFeelingsViewController.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PELogFeelingsViewController.h"
#import "PEUtil.h"
#import "PEToolBar.h"
#import "PEFeelingsCell.h"

#define SEPARATOR_HEIGHT 10.0
#define CELL_KERNING -2.8
#define CELL_TEXT_COLOR @"#d5d5d6"
#define JOY_COLOR @"#ffcb50"
#define SAD_COLOR @"#155d6d"
#define HOPE_COLOR @"#009a52"
#define ANXIOUS_COLOR @"#f46331"
#define CALM_COLOR @"#673363"
#define ANGER_COLOR @"#f00729"
#define CONFUSED_COLOR @"#1a7a7a"
#define SHAME_COLOR @"#ce1345"
#define CUSTOM_FEELING_COLOR @"#333333"

@interface PELogFeelingsViewController ()

@property UIColor *cellTextColor;

@end

@implementation PELogFeelingsViewController

@synthesize cellHeight;
@synthesize cellTextColor;

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
    
    // disable scrolling
    self.tableView.scrollEnabled = NO;
    
    // customize separatorss
    self.tableView.separatorColor = [UIColor clearColor];
    
    // initialize content cell properties
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    // CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    cellHeight = (screenHeight - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - SEPARATOR_HEIGHT*10) / 10;
    
    cellTextColor = [PEUtil colorFromHexString:CELL_TEXT_COLOR];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogFeelingsBackground.png"]];
    self.tableView.backgroundView = imageView;
    
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
                          initWithFrame:CGRectMake(0, 0, 100, 37)];
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
    spacer.width = 50;
    [buttons addObject:spacer];
    
    UIImage *calendarImage = [UIImage imageNamed:@"CalendarIcon.png"];
    UIButton *calendar = [UIButton buttonWithType:UIButtonTypeCustom];
    calendar.bounds = CGRectMake( 0, 0, 35, 30 );
    [calendar addTarget:self action:@selector(calendarClicked) forControlEvents:UIControlEventTouchUpInside];
    [calendar setImage:calendarImage forState:UIControlStateNormal];
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithCustomView:calendar];
    [buttons addObject:calendarButton];
    
    // put the buttons in the toolbar and release them
    [toolbar setItems:buttons animated:NO];
    
    // place the toolbar into the navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:toolbar];
    
    toolbar = [[PEToolBar alloc]
               initWithFrame:CGRectMake(0, 0, 100, 37)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setBackgroundColor: [UIColor clearColor]];
    toolbar.translucent = YES;
    
    buttons = [[NSMutableArray alloc] initWithCapacity: 4];
    
    spacer = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
              target:nil
              action:nil];
    spacer.width = -9;
    [buttons addObject:spacer];
    
    UIImage *settingsImage = [UIImage imageNamed:@"SettingsIcon.png"];
    UIButton *settings = [UIButton buttonWithType:UIButtonTypeCustom];
    settings.bounds = CGRectMake( 0, 0, 30, 27 );
    [settings addTarget:self action:@selector(settingsClicked) forControlEvents:UIControlEventTouchUpInside];
    [settings setImage:settingsImage forState: UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settings];
    [buttons addObject: settingsButton];
    
    // create a spacer between the buttons
    spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    spacer.width = -3;
    [buttons addObject:spacer];
    
    UIImage *addImage = [UIImage imageNamed:@"AddIcon.png"];
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.bounds = CGRectMake( 0, 0, 30, 27 );
    [add addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
    [add setImage:addImage forState: UIControlStateNormal];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:add];
    [buttons addObject: addButton];
    
    [toolbar setItems:buttons animated:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        return SEPARATOR_HEIGHT;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LogFeelingsCell";
    PEFeelingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // separator cells
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    UIColor *intensityColor = [UIColor clearColor];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CellBackground.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    cell.textLabel.textColor = cellTextColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:37.0];
    
    NSString *cellLabel = @"";
    
    if (indexPath.row/2 == 0) {
        intensityColor = [PEUtil colorFromHexString:JOY_COLOR];
        cellLabel = @"JOY";
    }
    if (indexPath.row/2 == 1) {
        intensityColor = [PEUtil colorFromHexString:SAD_COLOR];
        cellLabel = @"SAD";
    }
    if (indexPath.row/2 == 2) {
        intensityColor = [PEUtil colorFromHexString:HOPE_COLOR];
        cellLabel = @"HOPE";
    }
    if (indexPath.row/2 == 3) {
        intensityColor = [PEUtil colorFromHexString:ANXIOUS_COLOR];
        cellLabel = @"ANXIOUS";
    }
    if (indexPath.row/2 == 4) {
        intensityColor = [PEUtil colorFromHexString:CALM_COLOR];
        cellLabel = @"CALM";
    }
    if (indexPath.row/2 == 5) {
        intensityColor = [PEUtil colorFromHexString:ANGER_COLOR];
        cellLabel = @"ANGER";
    }
    if (indexPath.row/2 == 6) {
        intensityColor = [PEUtil colorFromHexString:CONFUSED_COLOR];
        cellLabel = @"CONFUSED";
    }
    if (indexPath.row/2 == 7) {
        intensityColor = [PEUtil colorFromHexString:SHAME_COLOR];
        cellLabel = @"SHAME";
    }
    if (indexPath.row/2 == 8) {
        intensityColor = [PEUtil colorFromHexString:CUSTOM_FEELING_COLOR];
        cellLabel = @"PICK YOUR OWN";
    }
    if (indexPath.row/2 == 9) {
        cellLabel = @"inputTODO";
    }
    
    [cell initIntensity:intensityColor];
    
    // apply kerning to cell label
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:cellLabel];
    [attributedString addAttribute:NSKernAttributeName
                             value:[NSNumber numberWithFloat:CELL_KERNING]
                             range:NSMakeRange(0, [cellLabel length])];
    
    cell.textLabel.attributedText = attributedString;
    
    // Configure the cell...
    
    return cell;
}

-(void)calendarClicked {
    NSLog(@"calendar clicked");
}

-(void)settingsClicked {
    NSLog(@"settings clicked");
}

-(void)addClicked {
    NSLog(@"add clicked");
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
