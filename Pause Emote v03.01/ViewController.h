//
//  ViewController.h
//  Pause Emote v03.01
//
//  Created by Amy Goldfeder on 11/30/12.
//  Copyright (c) 2012 Amy Goldfeder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {

IBOutlet UISlider *mySlider01;
IBOutlet UILabel *myTextField01;

IBOutlet UISlider *mySlider02;
IBOutlet UILabel *myTextField02;

IBOutlet UISlider *mySlider03;
IBOutlet UILabel *myTextField03;

IBOutlet UISlider *mySlider04;
IBOutlet UILabel *myTextField04;

IBOutlet UISlider *mySlider05;
IBOutlet UILabel *myTextField05;

IBOutlet UISlider *mySlider06;
IBOutlet UILabel *myTextField06;

IBOutlet UIScrollView *myScrollView;

BOOL keyboardVisible;
CGPoint  offset;
    UITextField *activeField;
IBOutlet UITextField *myTextField07;

}



// scroll function
@property(nonatomic,retain) IBOutlet UIScrollView *myScrollView;

// 01 set of controls

@property (nonatomic, retain) IBOutlet UISlider *mySlider01;
@property (nonatomic, retain) IBOutlet UILabel *myTextField01;

- (IBAction) slider01ValueChanged:(id)sender;

// 02 set of controls

@property (nonatomic, retain) IBOutlet UISlider *mySlider02;
@property (nonatomic, retain) IBOutlet UILabel *myTextField02;

- (IBAction) slider02ValueChanged:(id)sender;

// 03 set of controls

@property (nonatomic, retain) IBOutlet UISlider *mySlider03;
@property (nonatomic, retain) IBOutlet UILabel *myTextField03;

- (IBAction) slider03ValueChanged:(id)sender;

// 04 set of controls

@property (nonatomic, retain) IBOutlet UISlider *mySlider04;
@property (nonatomic, retain) IBOutlet UILabel *myTextField04;

- (IBAction) slider04ValueChanged:(id)sender;

// 05 set of controls

@property (nonatomic, retain) IBOutlet UISlider *mySlider05;
@property (nonatomic, retain) IBOutlet UILabel *myTextField05;

- (IBAction) slider05ValueChanged:(id)sender;

// 06 set of controls

@property (nonatomic, retain) IBOutlet UISlider *mySlider06;
@property (nonatomic, retain) IBOutlet UILabel *myTextField06;

- (IBAction) slider06ValueChanged:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *myTextField07;

// This function is for button which posts to the website
- (IBAction) postButton: (id) sender;

@end
