//
//  PESplashPageViewController.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/22/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PESplashPageViewController.h"
#import "LoggedEmotionsManager.h"
#import "PENavigationController.h"
#import "PELogFeelingsViewController.h"

@interface PESplashPageViewController ()

@end

@implementation PESplashPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LoggedEmotionsManager sharedSingleton];
    
    PELogFeelingsViewController *lfvc = [[PELogFeelingsViewController alloc] init];
    
    PENavigationController *nc = [[PENavigationController alloc] initWithRootViewController:lfvc];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
