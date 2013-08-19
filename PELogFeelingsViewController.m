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

@interface PELogFeelingsViewController ()

@property float separatorHeight;
@property float cellKerning;
@property float cellHeight;
@property UIColor *cellTextColor;

@end

@implementation PELogFeelingsViewController

@synthesize separatorHeight;
@synthesize cellKerning;
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
    
    // initialize separator cell properties
    separatorHeight = 10.0;
    
    // initialize content cell properties
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    // CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    cellHeight = (screenHeight - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - separatorHeight*10) / 10;
    
    cellTextColor = [PEUtil colorFromHexString:@"#d5d5d6"];
    
    cellKerning = -2.3;
    
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
    
    buttons = [[NSMutableArray alloc] initWithCapacity: 3];
    
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
        return separatorHeight;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LogFeelingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // separator cells
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CellBackground.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    //cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_pressed.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    cell.frame=CGRectMake(23,0,tableView.bounds.size.width,23);
    
    cell.textLabel.textColor = cellTextColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:37.0];
    
    NSString *cellLabel = @"";
    
    if (indexPath.row/2 == 0) {
        cellLabel = @"JOY";
    }
    if (indexPath.row/2 == 1) {
        cellLabel = @"SAD";
    }
    if (indexPath.row/2 == 2) {
        cellLabel = @"HOPE";
    }
    if (indexPath.row/2 == 3) {
        cellLabel = @"ANXIOUS";
    }
    if (indexPath.row/2 == 4) {
        cellLabel = @"CALM";
    }
    if (indexPath.row/2 == 5) {
        cellLabel = @"ANGER";
    }
    if (indexPath.row/2 == 6) {
        cellLabel = @"CONFUSED";
    }
    if (indexPath.row/2 == 7) {
        cellLabel = @"SHAME";
    }
    if (indexPath.row/2 == 8) {
        cellLabel = @"PICK YOUR OWN";
    }
    if (indexPath.row/2 == 9) {
        cellLabel = @"inputTODO";
    }
    
    // apply kerning to cell label
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:cellLabel];
    [attributedString addAttribute:NSKernAttributeName
                             value:[NSNumber numberWithFloat:cellKerning]
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
