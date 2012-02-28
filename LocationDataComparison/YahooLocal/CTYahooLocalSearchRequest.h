//
//  CTYahooLocalSearchRequest.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CTYahooLocalSearchRequest : NSURLRequest
-(id)initWithQuery:(NSString*)queryString NumberOfResults:(int)numberOfResults Radius:(float)radius Coordinate:(CLLocationCoordinate2D)coordinate;
@end
