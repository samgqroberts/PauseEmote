//
//  PELogFeelingsViewController.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PELogEmotionsViewController.h"
#import "PEUtil.h"
#import "PEToolBar.h"
#import "PELogEmotionsCell.h"
#import "PELogEmotionsTableView.h"
#import "PEEmotionsManager.h"
#import "PEDayViewController.h"
#import "PENavigationController.h"

// miscellaneous macro values
#define SEPARATOR_HEIGHT 10.0
#define EMOTION_TITLE_KERNING -2.8
#define EMOTION_INTENSITY_KERNING -1
#define CELL_TEXT_COLOR @"#d5d5d6"
#define CUSTOM_EMOTION_TAG 98
#define COMMENT_TAG 99
#define COMMENT_CELL_TEXT_COLOR @"#999999"

// dimensions
#define SUBMIT_ICON_X 250.0
#define SUBMIT_ICON_Y 447.0
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
#define REFRESH_ICON_WIDTH 36.0
#define REFRESH_ICON_HEIGHT 32.0
#define EMOTION_TITLE_FONT_SIZE 37.0
#define COMMENT_PROMPT_FONT_SIZE 20.0
#define EMOTION_INTENSITY_FONT_SIZE 18.0

@interface PELogEmotionsViewController ()

@property CGSize screenSize;
@property UIButton *submitButton;
@property NSDictionary *emotionColors;
@property UIColor *cellTextColor;
@property NSDictionary *emotionIntensities;
@property PELogEmotionsCell *customEmotionCell;
@property PELogEmotionsCell *commentCell;
@property NSArray *emotions;
@property NSMutableDictionary *intensities;
@property int numberOfCells;
@property PEEmotionsManager *lem;
@property UIButton *searchButton;
@property UIButton *dayButton;
@property UIButton *weekButton;
@property UIButton *monthButton;

@end

@implementation PELogEmotionsViewController

BOOL editingCustomCell;

@synthesize dayButton;
@synthesize weekButton;
@synthesize monthButton;
@synthesize searchButton;
@synthesize lem;
@synthesize screenSize;
@synthesize numberOfCells;
@synthesize intensities;
@synthesize emotions;
@synthesize submitButton;
@synthesize commentCell;
@synthesize customEmotionCell;
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

- (void)viewWillAppear:(BOOL)animated {
    self.searchButton.hidden = YES;
    self.dayButton.hidden = YES;
    self.weekButton.hidden = YES;
    self.monthButton.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    editingCustomCell = NO;
    
    //get logged emotions singleton
    lem = [PEEmotionsManager sharedSingleton];
    
    //get info from plists
    emotions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Emotions" ofType:@"plist"]];
    
    emotionColors = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"EmotionColors" ofType: @"plist"]];
    
    emotionIntensities = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"EmotionIntensities" ofType: @"plist"]];
    
    //init cells info
    numberOfCells = [emotions count] + 1; // +1 for comment cell
    intensities = [NSMutableDictionary dictionary];
    
    // disable scrolling
    self.tableView.scrollEnabled = NO;
    
    // customize separators
    self.tableView.separatorColor = [UIColor clearColor];
    
    // save screen size to global variable
    self.screenSize = [[UIScreen mainScreen] bounds].size;
    
    // initialize cell qualities
    cellHeight = (self.screenSize.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - SEPARATOR_HEIGHT*numberOfCells) / numberOfCells;
    cellTextColor = [PEUtil colorFromHexString:CELL_TEXT_COLOR];
    
    // initialize background
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogFeelingsBackground.png"]];
    self.tableView.backgroundView = imageView;
    
    // initialize submit button
    UIImage *submitImage = [UIImage imageNamed:@"SubmitIcon.png"];
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake( width_factor(SUBMIT_ICON_X), height_factor(SUBMIT_ICON_Y), width_factor(SUBMIT_ICON_WIDTH), height_factor(SUBMIT_ICON_HEIGHT) );
    [submitButton addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setImage:submitImage forState:UIControlStateNormal];
    [self.tableView insertSubview:submitButton atIndex:0];
    
    [self initNavigationBar];
    
    //save self to navigation controller
    [(PENavigationController *)self.navigationController setLogFeelingsViewController:self];
    
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
    
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:CALENDAR_BUTTON_TYPE forViewOfType:LOG_VIEW_TYPE withTarget:self withSelector:@selector(calendarClicked)]];
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
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:SETTINGS_BUTTON_TYPE forViewOfType:LOG_VIEW_TYPE withTarget:self withSelector:@selector(settingsClicked)]];
    [buttons addObject: settingsButton];
    
    // create a spacer between the buttons
    spacer = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
              target:nil
              action:nil];
    spacer.width = width_factor(LEFT_TOOLBAR_RIGHT_SPACER_WIDTH);
    [buttons addObject:spacer];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithCustomView:[PENavigationController getButtonOfType:REFRESH_BUTTON_TYPE forViewOfType:LOG_VIEW_TYPE withTarget:self withSelector:@selector(refreshClicked)]];
    [buttons addObject: refreshButton];
    
    
    [toolbar setItems:buttons animated:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    // initialize the sub-calendar buttons
    searchButton = [PENavigationController getButtonOfType:SEARCH_BUTTON_TYPE forViewOfType:LOG_VIEW_TYPE withTarget:self withSelector:@selector(searchClicked)];
    [self.tableView insertSubview:searchButton atIndex:0];
    searchButton.hidden = TRUE;
    
    dayButton = [PENavigationController getButtonOfType:DAY_BUTTON_TYPE forViewOfType:LOG_VIEW_TYPE withTarget:self withSelector:@selector(dayClicked)];
    [self.tableView insertSubview:dayButton atIndex:0];
    dayButton.hidden = TRUE;
    
    weekButton = [PENavigationController getButtonOfType:WEEK_BUTTON_TYPE forViewOfType:LOG_VIEW_TYPE withTarget:self withSelector:@selector(weekClicked)];
    [self.tableView insertSubview:weekButton atIndex:0];
    weekButton.hidden = TRUE;
    
    monthButton = [PENavigationController getButtonOfType:MONTH_BUTTON_TYPE forViewOfType:LOG_VIEW_TYPE withTarget:self withSelector:@selector(monthClicked)];
    [self.tableView insertSubview:monthButton atIndex:0];
    monthButton.hidden = TRUE;
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
    return numberOfCells*2;
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
    PELogEmotionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // separator cells
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CellBackground.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    cell.textLabel.textColor = cellTextColor;
    
    UIColor *emotionColor = [UIColor clearColor];
    NSString *cellLabel = @"";
    NSString *emotion = @"";
    UIFont *font = [UIFont boldSystemFontOfSize:height_factor(EMOTION_TITLE_FONT_SIZE)];
    
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
        cell.textLabel.textColor = [PEUtil colorFromHexString:COMMENT_CELL_TEXT_COLOR];
        emotion = @"Comment";
        cellLabel = @"Why are you feeling this way?";
        font = [UIFont systemFontOfSize:height_factor(COMMENT_PROMPT_FONT_SIZE)];
        
    }
    
    [cell initForEmotion:emotion withColor:emotionColor];
    
    cell.textLabel.font = font;
    
    // apply kerning to cell label
    cell.textLabel.attributedText = [self attributedStringWithText:cellLabel withKerning:EMOTION_TITLE_KERNING];
    
    if (indexPath.row/2 < [self.emotions count] && [self.intensities objectForKey: [self.emotions objectAtIndex:indexPath.row/2]] != nil) {
        [cell setIntensityFrame: [(NSNumber *)[self.intensities objectForKey: [self.emotions objectAtIndex:indexPath.row/2]] floatValue]];
        [self updateTextForCell:cell];
    }
    
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

- (void)searchClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:SEARCH_VIEW_TYPE];
}

- (void)dayClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:DAY_VIEW_TYPE];
}

- (void)weekClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:WEEK_VIEW_TYPE];
}

- (void)monthClicked {
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:MONTH_VIEW_TYPE];
}

// This function is for the post button which sends data you to the website
- (void)submitClicked {
    
    
    // kill all previous timers
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // post
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:@"http://inbetwixt.com/pause/datalog.php"]];
    
    [request setHTTPMethod:@"POST"];
    
    // non apple approved approach
    //NSString *phoneNumb = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    NSString *phoneName = [[UIDevice currentDevice] name];
    
    NSString *postString = @"postData=1";
    NSString *bit = @"";
    NSString *emotion;
    
    // add phone name
    bit = [NSString stringWithFormat:@"&data01=%@", phoneName];
    postString = [postString stringByAppendingString:bit];
    
    int data = 2;
    
    // all but custom emotion
    for (int i = 0 ; i < [self.emotions count] - 1 ; i++) {
        if (data == 10 || data == 11) {
            data+=2;
        }
        emotion = [self.emotions objectAtIndex:i];
        bit = [NSString stringWithFormat: @"&data%@%d=%@&data%@%d=%f", data<10?@"0":@"", data++, emotion, data<10?@"0":@"", data++, [(NSNumber *)[self.intensities valueForKey:emotion] floatValue]];
        postString = [postString stringByAppendingString:bit];
    }
    // now for custom emotion
    PELogEmotionsCell *customCell = (PELogEmotionsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.emotions count]*2-1 inSection:0]];
    emotion = customCell.customEmotion ? customCell.customEmotion : @"No custom emotion";
    bit = [NSString stringWithFormat: @"&data%d=%@&data%d=%f", data++, emotion, data++, customCell.intensity];
    postString = [postString stringByAppendingString:bit];
    // now for comment
    commentCell = (PELogEmotionsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.emotions count]*2+1 inSection:0]];
    bit = [NSString stringWithFormat: @"&data%d=%@", data++, (commentCell.customEmotionField ? commentCell.customEmotionField.text : @"No comment")];
    postString = [postString stringByAppendingString: bit];
    
    [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
    {
        NSLog(@"Response: %@", result);
        
        // save the emotion on our local singleton as well (dateCreated will not be synchronized with server until next reboot)
        
        PEEmotion *emo = [[PEEmotion alloc] init];
        [emo setOwner: [[UIDevice currentDevice] name]];
        [emo setCustomEmotion: customCell.customEmotion ? customCell.customEmotion : @"No custom emotion"];
        [emo setComment: commentCell.customEmotionField ? commentCell.customEmotionField.text : @"No comment"];
        emo.dateCreated = [NSDate date];
        emo.intensities = [NSMutableDictionary dictionary];
        
        int i = 0;
        for ( ; i < [self.emotions count] - 1 ; i++) {
            emotion = [self.emotions objectAtIndex:i];
            [emo.intensities setValue: ([self.intensities objectForKey:emotion]?[self.intensities objectForKey:emotion]:[NSNumber numberWithFloat:0.0]) forKey:emotion];
        }
        
        [emo.intensities setValue: [NSNumber numberWithFloat: customCell.intensity] forKey:emo.customEmotion];
        
        [self.lem addEmotion: emo];
        
        [self refreshClicked];
        
        [((PENavigationController *)self.navigationController) pushViewControllerOfType:DAY_VIEW_TYPE withArgument:[NSDate date]];
    }
    
}


-(void)calendarClicked {
    
    searchButton.hidden = !searchButton.hidden;
    dayButton.hidden = !dayButton.hidden;
    weekButton.hidden = !weekButton.hidden;
    monthButton.hidden = !monthButton.hidden;
    
}

-(void)settingsClicked {
    NSLog(@"settings clicked");
    [((PENavigationController *)self.navigationController) pushViewControllerOfType:TRENDS_VIEW_TYPE];
}

-(void)refreshClicked {
    [self.tableView reloadData];
    self.customEmotionCell.customEmotion = nil;
    self.customEmotionCell.customEmotionField = nil;
    self.customEmotionCell = nil;
    self.commentCell.customEmotion = nil;
    self.commentCell.customEmotionField = nil;
    self.commentCell = nil;
    self.intensities = [NSMutableDictionary dictionary];
}

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
    [self touchEvent:touches withEvent:event atBeginning:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchEvent:touches withEvent:event atBeginning:NO];
    [super touchesMoved:touches withEvent:event];
}

-(void) touchEvent:(NSSet *)touches withEvent:(UIEvent *)event atBeginning:(BOOL)atBeginning {
    
    // don't know if touches can be multiple here, but don't wanna deal with it if it can
    if (touches.count == 1) {
        
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.tableView];\
        
        //check if clicking a separator cell
        if ((int)touchPoint.y % (int)(cellHeight + SEPARATOR_HEIGHT) < SEPARATOR_HEIGHT) {
            return;
        }
        
        // get chosen cell
        int row = 2 * touchPoint.y / (cellHeight + SEPARATOR_HEIGHT);
        row += row%2==0?1:0;
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
        PELogEmotionsCell *cell = (PELogEmotionsCell *)[self.tableView cellForRowAtIndexPath:path];
        
        //check if clicking 'comment' cell
        if ([cell.emotion isEqualToString:@"Comment"]) {
            //shouldn't bring up keyboard if just swiping over comment cell
            if (atBeginning) {
                [cell initCustomEmotionTextField];
                if (!self.commentCell) {
                    self.commentCell = cell;
                }
                cell.customEmotionField.delegate = self;
                cell.customEmotionField.tag = COMMENT_TAG;
                [cell.customEmotionField becomeFirstResponder];
            }
            return;
        }
        
        //check if clicking 'pick your own' cell
        if ([cell.emotion isEqualToString:@"Pick Your Own"]) {
            //check if hasn't been 'picked' yet
            if(!cell.customEmotion) {
                // only let user pick if touch began here
                if (atBeginning) {
                    editingCustomCell = YES;
                    [cell initCustomEmotionTextField];
                    if (!self.customEmotionCell) {
                        self.customEmotionCell = cell;
                    }
                    cell.customEmotionField.delegate = self;
                    cell.customEmotionField.tag = CUSTOM_EMOTION_TAG;
                    
                    [cell.customEmotionField becomeFirstResponder];
                    return;
                }
                else  {
                    return;
                }
            }

        }
        
        
        if (editingCustomCell) {
            return;
        }
        
        
        if ([cell.customEmotionField isFirstResponder]) {
            return;
        }
        
        //make sure the textviews give up first responder when not most recently touched. TODO: this isn't working
        if (self.customEmotionCell) {
            [self.customEmotionCell resignFirstResponder];
        }
        if (self.commentCell) {
            [self.commentCell resignFirstResponder];
        }
        
        // update intensity based on touch
        float intensity = [cell newIntensityWidth:touchPoint.x];
        
        if (![cell.emotion isEqualToString: [self.emotions objectAtIndex:[emotions count]-1]]) {
            [self.intensities setValue:[NSNumber numberWithFloat:intensity] forKey: cell.emotion];
        }
        
        // update text based on intensity
        [self updateTextForCell:cell];
    }
}

- (void) updateTextForCell:(PELogEmotionsCell *)cell {
    float fontSize;
    float kerning;
    NSString *text;
    if ([cell.emotion isEqualToString:@"Pick Your Own"]) {
        kerning = EMOTION_INTENSITY_KERNING;
        fontSize = height_factor(EMOTION_INTENSITY_FONT_SIZE);
        text = [[[(NSString *)[emotionIntensities valueForKey:cell.emotion][((int)cell.intensity/2)] uppercaseString] stringByAppendingString: @" "] stringByAppendingString:[cell.customEmotion uppercaseString]] ;
    }
    else if (cell.intensity == 0) {
        kerning = EMOTION_TITLE_KERNING;
        fontSize = height_factor(EMOTION_TITLE_FONT_SIZE);
        text = [cell.emotion uppercaseString];
    }
    else {
        kerning = EMOTION_INTENSITY_KERNING;
        fontSize = height_factor(EMOTION_INTENSITY_FONT_SIZE);
        text = [[emotionIntensities valueForKey:cell.emotion][((int)cell.intensity)/2] uppercaseString];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    cell.textLabel.attributedText = [self attributedStringWithText:text withKerning:kerning];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        editingCustomCell = NO;
        [textView resignFirstResponder];
        
        if (textView.tag == CUSTOM_EMOTION_TAG) {
            
            // if nothing was typed, assume they'd still wanna be able to pick their own again without refreshing
            if ([textView.text isEqualToString:@""]) {
                textView.frame = CGRectMake(0, 0, 0, 0); // hacky
                self.customEmotionCell.customEmotion = nil;
                self.customEmotionCell.customEmotionField = nil;
                self.customEmotionCell.textLabel.font = [UIFont boldSystemFontOfSize:height_factor(EMOTION_TITLE_FONT_SIZE)];
                self.customEmotionCell.textLabel.attributedText = [self attributedStringWithText:[customEmotionCell.emotion uppercaseString] withKerning:EMOTION_TITLE_KERNING];
            }
            else {
                textView.frame = CGRectMake(0, 0, 0, 0); // hacky
                [customEmotionCell initCustomEmotion:textView.text];
                customEmotionCell.textLabel.font = [UIFont boldSystemFontOfSize:height_factor(EMOTION_INTENSITY_FONT_SIZE)];
                customEmotionCell.textLabel.attributedText = [self attributedStringWithText:[customEmotionCell.customEmotion uppercaseString] withKerning:EMOTION_INTENSITY_KERNING];
            }
        }
        
        if(textView.tag == COMMENT_TAG) {
            // if nothing was typed, make the default comment message reappear
            if ([textView.text isEqualToString:@""]) {
                textView.frame = CGRectMake(0, 0, 0, 0); // hacky
                self.commentCell.customEmotion = nil;
                self.commentCell.customEmotionField = nil;
                self.commentCell.textLabel.font = [UIFont systemFontOfSize:height_factor(COMMENT_PROMPT_FONT_SIZE)];
                self.commentCell.textLabel.attributedText = [self attributedStringWithText:@"Why are you feeling this way?" withKerning:EMOTION_TITLE_KERNING];
            }
        }
        
        return FALSE;
    }
    return TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView:textView up:YES];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:textView up:NO];
}


- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    int animatedDistance;
    animatedDistance = 210; //static for now, make it based on the textView
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.tableView.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



@end
