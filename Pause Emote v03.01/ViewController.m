//
//  ViewController.m
//  Pause Emote v03.01
//
//  Created by Amy Goldfeder on 11/30/12.
//  Copyright (c) 2012 Amy Goldfeder. All rights reserved.
//

#define SCROLLVIEW_CONTENT_HEIGHT 460
#define SCROLLVIEW_CONTENT_WIDTH  320

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize myScrollView, mySlider01, myTextField01, mySlider02, myTextField02, mySlider03, myTextField03, mySlider04, myTextField04, mySlider05, myTextField05, mySlider06, myTextField06, myTextField07;

// 01 set of controls

- (IBAction) slider01ValueChanged:(UISlider *)sender {

    if ([sender value] == 0.0){
        myTextField01.text = @"Not Happy ";
        
    }else if ([sender value] < 25.0){
        myTextField01.text = @"Pretty good";
        
    }else if ([sender value] < 50.0){
        myTextField01.text = @"I'm alright";
        
    }else if ([sender value] < 75.0){
        myTextField01.text = @"Feeling really good";
        
    }else if ([sender value] <= 100.0){
        myTextField01.text = @"I'm really happy!";
    }

    //myTextField01.text = [NSString stringWithFormat:@" %.1f", [sender value]];
}

// 02 set of controls

- (IBAction) slider02ValueChanged:(UISlider *)sender {

    if ([sender value] == 0.0){
        myTextField02.text = @"Not Sad";
        
    }else if ([sender value] < 25.0){
        myTextField02.text = @"Not so sad";
        
    }else if ([sender value] < 50.0){
        myTextField02.text = @"I'm alright";
        
    }else if ([sender value] < 75.0){
        myTextField02.text = @"Feeling sad";
        
    }else if ([sender value] <= 100.0){
        myTextField02.text = @"I'm really sad...";
    }
}

// 03 set of controls

- (IBAction) slider03ValueChanged:(UISlider *)sender {
    
    if ([sender value] == 0.0){
        myTextField03.text = @"Not Anxious";
        
    }else if ([sender value] < 25.0){
        myTextField03.text = @"Pretty calm";
        
    }else if ([sender value] < 50.0){
        myTextField03.text = @"I'm getting stirred up";
        
    }else if ([sender value] < 75.0){
        myTextField03.text = @"Pretty anxious";
        
    }else if ([sender value] <= 100.0){
        myTextField03.text = @"Freaking out!";
    }
    
}

// 04 set of controls

- (IBAction) slider04ValueChanged:(UISlider *)sender {
    
    if ([sender value] == 0.0){
        myTextField04.text = @"Not Angry";
        
    }else if ([sender value] < 25.0){
        myTextField04.text = @"I'm a bit annoyed";
        
    }else if ([sender value] < 50.0){
        myTextField04.text = @"I'm alright but...";
        
    }else if ([sender value] < 75.0){
        myTextField04.text = @"Feeling angry";
        
    }else if ([sender value] <= 100.0){
        myTextField04.text = @"I'm really furious!";
    }
    
}

// 05 set of controls

- (IBAction) slider05ValueChanged:(UISlider *)sender {
    
    if ([sender value] == 0.0){
        myTextField05.text = @"Not Confused";
        
    }else if ([sender value] < 25.0){
        myTextField05.text = @"I'm a bit puzzled";
        
    }else if ([sender value] < 50.0){
        myTextField05.text = @"I'm not sure";
        
    }else if ([sender value] < 75.0){
        myTextField05.text = @"Feeling perplexed";
        
    }else if ([sender value] <= 100.0){
        myTextField05.text = @"I'm missing the point!";
    }
}

// 06 set of controls

- (IBAction) slider06ValueChanged:(UISlider *)sender {
    
    if ([sender value] == 0.0){
        myTextField06.text = @"Not Ashamed";
        
    }else if ([sender value] < 25.0){
        myTextField06.text = @"I'm a bit embarassed";
        
    }else if ([sender value] < 50.0){
        myTextField06.text = @"I'm feeling dumb";
        
    }else if ([sender value] < 75.0){
        myTextField06.text = @"Feeling ashamed";
        
    }else if ([sender value] <= 100.0){
        myTextField06.text = @"I'm really regretting that!";
    }
}

// This function is for the post button which sends data you to the website
- (IBAction) postButton: (id) sender {
    
    
    // kill all previous timers
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // post
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:@"http://inbetwixt.com/pause/datalog.php"]];
    
    [request setHTTPMethod:@"POST"];
    
    // non apple approved approach
    //NSString *phoneNumb = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    NSString *phoneNumb = [[UIDevice currentDevice] name];
    
    NSString *postString = [NSString stringWithFormat:@"postData=1&data01=%@&data02=%f&data03=%@&data04=%f&data05=%@&data06=%f&data07=%@&data08=%f&data09=%@&data10=%f&data12=%@&data13=%@&data14=%f&data15=%@",myTextField01.text, mySlider01.value, myTextField02.text, mySlider02.value, myTextField03.text, mySlider03.value,myTextField04.text,mySlider04.value, myTextField05.text, mySlider05.value, phoneNumb, myTextField06.text, mySlider06.value, myTextField07.text];
    
    [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response Code: %d", [urlResponse statusCode]);
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
    {
        NSLog(@"Response: %@", result);
        // do something with the result
        //myTextField06.text = @"Data Logged";
        //[self performSelector:@selector(timerAction:) withObject:nil afterDelay:minutesWait];
        myTextField01.text = @"";
        myTextField02.text = @"";
        myTextField03.text = @"";
        myTextField04.text = @"";
        myTextField05.text = @"";
        myTextField06.text = @"";
        
        [self performSelector:@selector(resetValues) withObject:nil afterDelay:2*60];
        
        
        
        //random number of minutes between 30 and 60
        int minutesWait = ((arc4random() % 30)*60)+30;
        //random number of seconds between 30 and 60
        //int minutesWait = ((arc4random() % 30)*1)+30;
        NSLog(@"The value of integer minutesWait is %i", minutesWait);
        [self performSelector:@selector(timerAction:) withObject:nil afterDelay:minutesWait];

    }
    
    // Create strings and integer to store the text info
    NSString *textField01 = [myTextField01 text];
    NSString *textField02 = [myTextField02 text];
    NSString *textField03 = [myTextField03 text];
    NSString *textField04 = [myTextField04 text];
    NSString *textField05 = [myTextField05 text];
    NSString *textField06 = [myTextField06 text];
    // save away
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:textField01 forKey:@"textField01"];
    [defaults setObject:textField02 forKey:@"textField02"];
    [defaults setObject:textField03 forKey:@"textField03"];
    [defaults setObject:textField04 forKey:@"textField04"];
    [defaults setObject:textField05 forKey:@"textField05"];
    [defaults setObject:textField06 forKey:@"textField06"];
    [defaults synchronize];
    NSLog(@"Data saved");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Fail..
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Request performed.
}


- (void)viewDidLoad
{
    // call the standardUserDefaults variables
    
    // Get the stored data before the view loads
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *textField01 = [defaults objectForKey:@"textField01"];
    //NSString *textField02 = [defaults objectForKey:@"textField02"];
    //NSString *textField03 = [defaults objectForKey:@"textField03"];
    //NSString *textField04 = [defaults objectForKey:@"textField04"];
    //NSString *textField05 = [defaults objectForKey:@"textField05"];
    //NSString *textField06 = [defaults objectForKey:@"textField06"];
    
    //int age = [defaults integerForKey:@"age"];
    //NSString *ageString = [NSString stringWithFormat:@"%i",age];
    //NSData *imageData = [defaults dataForKey:@"image"];
    //UIImage *contactImage = [UIImage imageWithData:imageData];
    
    [self resetValues];

    [super viewDidLoad];
    
    // give a clue as to what is expected
    [self performSelector:@selector(timerAction:) withObject:nil afterDelay:2.0];

}

- (void)resetValues
{
    // Reset the UI elements
    myTextField01.text = @" ";
    mySlider01.value = 0;
    myTextField02.text = @" ";
    mySlider02.value = 0;
    myTextField03.text = @" ";
    mySlider03.value = 0;
    myTextField04.text = @" ";
    mySlider04.value = 0;
    myTextField05.text = @" ";
    mySlider05.value = 0;
    myTextField06.text = @" ";
    mySlider06.value = 0;
    myTextField07.text = @"Why are you feeling that way?";
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        NSLog(@"Submit Ratings was selected.");
        
        // reminder after 2 minutes which is killed by post button
        [self performSelector:@selector(timerAction:) withObject:nil afterDelay:(2*60)];
        //[self performSelector:@selector(timerAction:) withObject:nil afterDelay:30];
        
        
    }
    else if([title isEqualToString:@"Later"])
    {
        NSLog(@"Respond Later was selected.");
        //random number of minutes between 30 and 60
        //int minutesWait = ((arc4random() % 30)*60)+30;
        //random number of seconds between 30 and 60
        int minutesWait = ((arc4random() % 30)*1)+30;
        NSLog(@"The value of integer minutesWait is %i", minutesWait);
        
        [self performSelector:@selector(timerAction:) withObject:nil afterDelay:minutesWait];
        
    }
    else if([title isEqualToString:@"Button 3"])
    {
        NSLog(@"Button 3 was selected.");
    }
}

-(void)timerAction:(NSTimer *)timer {
    
    // Issue vibrate
	//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
    // Also issue visual alert
	UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"How are you feeling?"
                          message:@"use the sliders to log"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Later"];
    //[alert addButtonWithTitle:@"Button 3"];
    [alert show];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Registering for keyboard events");
    
    // Register for the events
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector (keyboardDidShow:)
     name: UIKeyboardDidShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector (keyboardDidHide:)
     name: UIKeyboardDidHideNotification
     object:nil];
    
    // Setup content size
    myScrollView.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH,SCROLLVIEW_CONTENT_HEIGHT);
    
    //Initially the keyboard is hidden
    keyboardVisible = NO;
}

-(void) viewWillDisappear:(BOOL)animated {
    NSLog (@"Unregister for keyboard events");
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

-(void) keyboardDidShow: (NSNotification *)notif {
    NSLog(@"Keyboard is visible");
    // If keyboard is visible, return
    if (keyboardVisible) {
        NSLog(@"Keyboard is already visible. Ignore notification.");
        return;
    }
    
    // Get the size of the keyboard.
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    NSLog(@"Keyboard %f",keyboardSize.height);
    
    // Save the current location so we can restore
    // when keyboard is dismissed
    offset = myScrollView.contentOffset;
    
    // Resize the scroll view to make room for the keyboard
    CGRect viewFrame = myScrollView.frame;
    viewFrame.size.height -= keyboardSize.height;
    myScrollView.frame = viewFrame;
    NSLog(@"viewFrame %f",viewFrame.size.height);
    
    CGRect textFieldRect = [activeField frame];
    //CGRect textFieldRect = [myTextField04 frame];
    
    textFieldRect.origin.y += 10;
    [myScrollView scrollRectToVisible:textFieldRect animated:YES];
    
    NSLog(@"Keyboard is now visible");
    // Keyboard is now visible
    keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
    // Is the keyboard already shown
    if (!keyboardVisible) {
        NSLog(@"Keyboard is already hidden. Ignore notification.");
        return;
    }
    
    // Reset the frame scroll view to its original value
    myScrollView.frame = CGRectMake(0, 0, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
    
    // Reset the scrollview to previous location
    myScrollView.contentOffset = offset;
    
    // Keyboard is no longer visible
    keyboardVisible = NO;
    
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
    activeField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
