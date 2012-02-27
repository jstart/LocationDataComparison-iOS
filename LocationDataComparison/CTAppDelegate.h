//
//  CTAppDelegate.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZFoursquare.h"

#define appDelegate ((CTAppDelegate*)[[UIApplication sharedApplication] delegate])

@interface CTAppDelegate : UIResponder <UIApplicationDelegate, BZFoursquareSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BZFoursquare * foursquare;

@end
