//
//  CTYahooLocalSearchRequest.m
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTYahooLocalSearchRequest.h"
#import "CTLocationConstants.h"
@implementation CTYahooLocalSearchRequest

-(id)initWithQuery:(NSString*)queryString NumberOfResults:(int)numberOfResults Radius:(float)radius Coordinate:(CLLocationCoordinate2D)coordinate{
  NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://local.yahooapis.com/LocalSearchService/V3/localSearch?query=%@&results=%d&radius=%f&latitude=%f&longitude=%f&output=json&appid=%@",queryString,numberOfResults,radius,coordinate.latitude, coordinate.longitude,YAHOO_APP_ID]];
  if (self = [super initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10]) {
    
  }
  
  return self;
}
@end
