//
//  CTLocationDataManagerResult.m
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTLocationDataManagerResult.h"

@implementation CTLocationDataManagerResult
@synthesize coordinate = _coordinate;
@synthesize name = _name;

-(id) initWithName:(NSString*)name Coordinate:(CLLocationCoordinate2D)coordinate{
  if (self = [super init]) {
    self.name = name;
    self.coordinate = coordinate;
  }
  return self;
}

+(CTLocationDataManagerResult*)resultWithName:(NSString*)name Coordinate:(CLLocationCoordinate2D)coordinate{
  return [[CTLocationDataManagerResult alloc] initWithName:name Coordinate:coordinate];
}

-(NSString*) description{
  return [NSString stringWithFormat:@"LocationResult Name: %@ Coordinate: %f, %f", self.name, self.coordinate.latitude, self.coordinate.longitude];
}

@end
