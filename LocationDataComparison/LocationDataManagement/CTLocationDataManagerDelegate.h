//
//  CTLocationDataManagerDelegate.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTLocationDataManagerDelegate <NSObject>

@optional
- (void)didReceiveResults:(NSArray*)results;
- (void)didFailWithError:(NSError*)error;

@end
