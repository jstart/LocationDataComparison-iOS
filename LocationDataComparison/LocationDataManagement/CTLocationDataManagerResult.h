//
//  CTLocationDataManagerResult.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CTLocationDataManagerResult : NSObject
@property (readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString * name;
-(id) initWithName:(NSString*)name Coordinate:(CLLocationCoordinate2D)coordinate;
+(CTLocationDataManagerResult*)resultWithName:(NSString*)name Coordinate:(CLLocationCoordinate2D)coordinate;
@end
