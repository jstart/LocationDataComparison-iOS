//
//  CTAppDelegate.m
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTAppDelegate.h"
#import <CityGrid/CityGrid.h>

@implementation CTAppDelegate

@synthesize window = _window, foursquare = _foursquare;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [CityGrid setPublisher:@"test"];
	[CityGrid setPlacement:@"ios-example"];
	[CityGrid setDebug:NO];

  _foursquare = [[BZFoursquare alloc] initWithClientID:@"K4XTUDHZYEWKM3I0F543YWCCOILTEQXOXH3Z4UGMSJQOVM3B" callbackURL:@"fsqdemo://foursquare"];
   _foursquare.version = @"20120227";
   _foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
  _foursquare.sessionDelegate = self;
  if (![_foursquare isSessionValid]){
    [_foursquare startAuthorization];
  }
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  NSLog(@"%@, %@, %@", url, sourceApplication, annotation);
  return [_foursquare handleOpenURL:url];
}

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare{
  NSLog(@"%@", [_foursquare accessToken]);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"FoursquareAuthSuccess" object:nil];

}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo{
  
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

@end
