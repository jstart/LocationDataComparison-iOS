//
//  CTLocationDataManager.m
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTLocationDataManager.h"
#import "CTLocationDataManagerResult.h"

@implementation CTLocationDataManager

@synthesize foursquare = _foursquare, factual = _factual, currentType = _currentType, delegate = _delegate;
SYNTHESIZE_SINGLETON_FOR_CLASS(CTLocationDataManager)

- (BOOL)setupWithDataSource:(CTLocationDataType)dataSourceType {
  self.currentType = dataSourceType;
  switch (dataSourceType) {
  case CTLocationDataTypeFoursquare:
  {
    _foursquare = [[BZFoursquare alloc] initWithClientID:FOURSQUARE_CLIENT_ID callbackURL:FOURSQUARE_AUTHORIZATION_CALLBACK_URL];
    _foursquare.version = FOURSQUARE_VERIFICATION_DATE;
    _foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
  }
  break;
  case CTLocationDataTypeFactual:
  {
    _factual = [[FactualAPI alloc] initWithAPIKey:FACTUAL_SERVER_KEY];
  }
  break;
  case CTLocationDataTypeCityGrid:
  {
    [CityGrid setPublisher:CITY_GRID_PUBLISHER];
    [CityGrid setPlacement:CITY_GRID_PLACEMENT];
    [CityGrid setDebug:CITY_GRID_DEBUG];
  }
  break;

  default:
    NSLog(@"Unsupported dataSourceType.");
    break;
  }
}

- (void)requestPlacesForCoordinate:(CLLocationCoordinate2D)coordinate andRadius:(CLLocationDistance)radius {
  switch (self.currentType) {
  case CTLocationDataTypeFoursquare:
  {
    NSString * radiusString = [NSString stringWithFormat:@"%f", radius];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f, %f",coordinate.latitude, coordinate.longitude], @"ll",  FOURSQUARE_CLIENT_SECRET, @"client_secret",FOURSQUARE_CLIENT_ID, @"client_id", radius, @"radius", nil];
    BZFoursquareRequest * request = [self.foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request start];
  }
  break;
  case CTLocationDataTypeFactual:
  {
    // alloc query object
    FactualQuery* queryObject = [FactualQuery query];
    // set geo filter
    [queryObject setGeoFilter:coordinate radiusInMeters:radius];
    // run query against the US-POI table
    FactualAPIRequest* activeRequest = [self.factual queryTable:@"bi0eJZ" optionalQueryParams:queryObject withDelegate:self];
  }

  break;
  case CTLocationDataTypeCityGrid: {
    CGPlacesSearch* search = [CityGrid placesSearch];
    search.type = CGPlacesSearchTypeRestaurant;
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    search.latlon = location;
    search.radius = radius;
    search.resultsPerPage = 20;

    NSArray* errors = nil;
    NSArray* tmpPlaces = [search search:&errors].locations;
    if ([errors count] > 0) {
      NSLog (@"%@", errors);
    } else {
      NSMutableArray * array = [NSMutableArray arrayWithCapacity:tmpPlaces.count];
      for (CGPlacesSearchLocation * location in tmpPlaces) {
	CTLocationDataManagerResult * result = [[CTLocationDataManagerResult alloc] initWithName:location.name Coordinate:location.latlon.coordinate];
	[array addObject:result];
      }
      [self.delegate didReceiveResults:array];
    }
  }

  break;

  default:
    NSLog(@"Unsupported dataSourceType.");
    break;
  }
}

#pragma mark
#pragma Foursquare
- (void)requestDidStartLoading:(BZFoursquareRequest *)request {
  NSLog(@"Foursquare request did start loading %@, %@", request, [request response]);
}

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {

  NSDictionary* tmpPlaces = [[request response] objectForKey:@"venues"];
  //NSLog (@"%@", self.places);
  NSMutableArray * array = [NSMutableArray arrayWithCapacity:tmpPlaces.count];
  for (NSDictionary * venue in tmpPlaces) {
    NSDictionary * locationDict = [venue objectForKey:@"location"];

    CTLocationDataManagerResult * result = [CTLocationDataManagerResult resultWithName:[venue objectForKey:@"name"] Coordinate:CLLocationCoordinate2DMake([[locationDict objectForKey:@"lat"] floatValue], [[locationDict objectForKey:@"lng"] floatValue])];

    [array addObject:result];
  }
  [self.delegate didReceiveResults:array];
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
  NSLog(@"%@", error);
}

#pragma Factual
/*! @discussion This method gets called when a queryTable request successfully
   completes on the server. The results of the request are passed to the caller
   in the FactualQueryResult object. Please see related FactualQueryResult
   docs for more details.

   @param request The request context object

   @param queryResult The FactualQueryResult result object
 */

- (void)requestComplete:(FactualAPIRequest*)request receivedQueryResult:(FactualQueryResult*)queryResult {

  NSArray* tmpPlaces = [queryResult rows];
  NSMutableArray * array = [NSMutableArray arrayWithCapacity:queryResult.rows.count];
  for (FactualRow * venue in tmpPlaces) {
    NSDictionary * factualDictionary = [venue namesAndValues];
    CTLocationDataManagerResult * result = [CTLocationDataManagerResult resultWithName:[factualDictionary objectForKey:@"name"] Coordinate:CLLocationCoordinate2DMake([[factualDictionary objectForKey:@"latitude"] floatValue], [[factualDictionary objectForKey:@"longitude"] floatValue])];
    [array addObject:result];
  }
  [self.delegate didReceiveResults:array];
}

@end