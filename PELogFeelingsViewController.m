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
#import "PELogFeelingsTableView.h"

#define SEPARATOR_HEIGHT 10.0
#define CELL_KERNING -2.8
#define CELL_TEXT_COLOR @"#d5d5d6"

@interface PELogFeelingsViewController ()

@property NSDictionary *emotionColors;
@property UIColor *cellTextColor;
@property NSDictionary *emotionIntensities;

@end

@implementation PELogFeelingsViewController

@synthesize emotionIntensities;
@synthesize emotionColors;
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
    
    emotionColors = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"EmotionColors" ofType: @"plist"]];
    
    emotionIntensities = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"EmotionIntensities" ofType: @"plist"]];
    
    // disable scrolling
    self.tableView.scrollEnabled = NO;
    
    // customize separators
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
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CellBackground.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    cell.textLabel.textColor = cellTextColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:37.0];
    
    UIColor *emotionColor = [UIColor clearColor];
    NSString *cellLabel = @"";
    NSString *emotion = @"";
    
    if (indexPath.row/2 == 0) {
        emotionColor = [PEUtil colorFromHexString: [emotionColors valueForKey:@"Joy"]];
        emotion = @"Joy";
        cellLabel = @"JOY";
    }
    if (indexPath.row/2 == 1) {
        emotionColor = [PEUtil colorFromHexString:[emotionColors valueForKey:@"Sad"]];
        emotion = @"Sad";
        cellLabel = @"SAD";
    }
    if (indexPath.row/2 == 2) {
        emotionColor = [PEUtil colorFromHexString:[emotionColors valueForKey:@"Hope"]];
        emotion = @"Hope";
        cellLabel = @"HOPE";
    }
    if (indexPath.row/2 == 3) {
        emotionColor = [PEUtil colorFromHexString:[emotionColors valueForKey:@"Anxious"]];
        emotion = @"Anxious";
        cellLabel = @"ANXIOUS";
    }
    if (indexPath.row/2 == 4) {
        emotionColor = [PEUtil colorFromHexString:[emotionColors valueForKey:@"Calm"]];
        emotion = @"Calm";
        cellLabel = @"CALM";
    }
    if (indexPath.row/2 == 5) {
        emotionColor = [PEUtil colorFromHexString:[emotionColors valueForKey:@"Anger"]];
        emotion = @"Anger";
        cellLabel = @"ANGER";
    }
    if (indexPath.row/2 == 6) {
        emotionColor = [PEUtil colorFromHexString:[emotionColors valueForKey:@"Confused"]];
        emotion = @"Confused";
        cellLabel = @"CONFUSED";
    }
    if (indexPath.row/2 == 7) {
        emotionColor = [PEUtil colorFromHexString:[emotionColors valueForKey:@"Shame"]];
        emotion = @"Shame";
        cellLabel = @"SHAME";
    }
    if (indexPath.row/2 == 8) {
        emotionColor = [PEUtil colorFromHexString:[emotionColors valueForKey:@"Pick Your Own"]];
        emotion = @"Pick Your Own";
        cellLabel = @"PICK YOUR OWN";
    }
    if (indexPath.row/2 == 9) {
        cellLabel = @"inputTODO";
    }
    
    [cell initForEmotion:emotion withColor:emotionColor];
    
    // apply kerning to cell label
    cell.textLabel.attributedText = [self attributedStringWithText:cellLabel withKerning:CELL_KERNING];
    
    // Configure the cell...
    
    return cell;
}

-(NSAttributedString *) attributedStringWithText:(NSString *)text withKerning:(float)kerning {
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSKernAttributeName
                             value:[NSNumber numberWithFloat:kerning]
                             range:NSMakeRange(0, [text length])];
    return attributedString;
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

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchEvent:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchEvent:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

-(void) touchEvent:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.tableView];\
        if ((int)touchPoint.y % (int)(cellHeight + SEPARATOR_HEIGHT) < SEPARATOR_HEIGHT) {
            return;
        }
        int row = 2 * touchPoint.y / (cellHeight + SEPARATOR_HEIGHT);
        row += row%2==0?1:0;\
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
        
        PEFeelingsCell *cell = (PEFeelingsCell *)[self.tableView cellForRowAtIndexPath:path];
        
        float intensity = [cell newIntensityWidth:touchPoint.x];
        if (intensity == 0) {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:37.0];
            cell.textLabel.attributedText = [self attributedStringWithText:[cell.emotion uppercaseString] withKerning:CELL_KERNING];
        }
        else {
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 18.0];
            cell.textLabel.attributedText = [self attributedStringWithText:[[emotionIntensities valueForKey:cell.emotion][((int)intensity)/2] uppercaseString] withKerning:CELL_KERNING];
        }
        
    }
}

@end
