//
//  PENavigationController.m
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import "PENavigationController.h"

@interface UINavigationBar (myNave)
- (CGSize)changeHeight:(CGSize)size;
@end

@implementation UINavigationBar (customNav)
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = CGSizeMake(320,52);
    return newSize;
}
@end

@interface PENavigationController ()

@end

@implementation PENavigationController

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
    
    // resize navbar background image to fit scale
    UIImage *originalImage = [UIImage imageNamed:@"NavBarBackground.png"];
    CGSize destinationSize = CGSizeMake(self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // set navbar background image to scaled image
    [self.navigationBar setBackgroundImage: newImage forBarMetrics: UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
