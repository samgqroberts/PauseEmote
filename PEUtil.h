//
//  PEUtil.h
//  Pause Emote v03.01
//
//  Created by Sam  Roberts on 8/19/13.
//  Copyright (c) 2013 Pause Emote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEUtil : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;

/*
 * the following is to standardize layout for all screen sizes
 * the layout was developed with screen size of 320x568
 * simply pass the desired pixel value on a 320x568 screen and get the scaled pixel value
 */
#define width_factor(w) ([[UIScreen mainScreen] bounds].size.width*w/320.0)
#define height_factor(h) ([[UIScreen mainScreen] bounds].size.height*h/568.0)

@end
