//
//  CTYelpLocalSearchRequest.m
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTYelpLocalSearchRequest.h"
#import "CTLocationConstants.h"
@implementation CTYelpLocalSearchRequest

-(id)initWithQuery:(NSString*)queryString NumberOfResults:(int)numberOfResults Radius:(float)radius Coordinate:(CLLocationCoordinate2D)coordinate{
  if (numberOfResults>20) {
    numberOfResults = 20;
    NSLog(@"Limit maximum is 20 for Yelp Search API");
  }
  NSString * urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=%@&limit=%d&radius_filter=%f&ll=%f,%f", queryString, numberOfResults, radius, coordinate.latitude, coordinate.longitude];
  NSURL *URL = [NSURL URLWithString:urlString];
  OAConsumer *consumer = [[OAConsumer alloc] initWithKey:YELP_CONSUMER_KEY secret:YELP_CONSUMER_SECRET];
  OAToken *token = [[OAToken alloc] initWithKey:YELP_TOKEN secret:YELP_TOKEN_SECRET];  
  
  id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
  NSString *realm = nil;  
    
  if (self = [super initWithURL:URL
                       consumer:consumer
                          token:token
                          realm:realm
              signatureProvider:provider]) {
    [self prepare];
    
  }
  
  return self;
}
@end
