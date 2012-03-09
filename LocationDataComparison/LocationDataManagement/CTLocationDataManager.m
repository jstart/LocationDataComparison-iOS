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

@synthesize foursquare = _foursquare, factual = _factual, facebook = _facebook, googlePlacesConnection = _googlePlacesConnection, currentType = _currentType, delegate = _delegate;
SYNTHESIZE_SINGLETON_FOR_CLASS(CTLocationDataManager)

- (void)setupWithDataSource:(CTLocationDataType)dataSourceType {
  self.currentType = dataSourceType;
  switch (dataSourceType) {

  case CTLocationDataTypeFacebook:
  {
    if (!self.facebook)
      self.facebook = [FacebookSupport sharedFacebookSupport];
    if (![self.facebook connected]) {
      [self.facebook connect];
    }
  }
  case CTLocationDataTypeFoursquare:
  {
    if (!self.foursquare) {
      _foursquare = [[BZFoursquare alloc] initWithClientID:FOURSQUARE_CLIENT_ID callbackURL:FOURSQUARE_AUTHORIZATION_CALLBACK_URL];
      _foursquare.version = FOURSQUARE_VERIFICATION_DATE;
      _foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    }
  }
  break;
  case CTLocationDataTypeFactual:
  {
    if (!self.factual) {
      _factual = [[FactualAPI alloc] initWithAPIKey:FACTUAL_SERVER_KEY];
    }
  }
  break;
  case CTLocationDataTypeCityGrid:
  {
    [CityGrid setPublisher:CITY_GRID_PUBLISHER];
    [CityGrid setPlacement:CITY_GRID_PLACEMENT];
    [CityGrid setDebug:CITY_GRID_DEBUG];
  }
  break;
  case CTLocationDataTypeGoogle:
  {
    self.googlePlacesConnection = [[GooglePlacesConnection alloc] initWithDelegate:self];
  }
  break;
  case CTLocationDataTypeYahoo:
  {
  }
  break;
  default:
    NSLog(@"Unsupported dataSourceType.");
    break;
  }
}

- (void)requestPlacesForCoordinate:(CLLocationCoordinate2D)coordinate andRadius:(CLLocationDistance)radius andQuery:(NSString*)queryString {
  switch (self.currentType) {
  case CTLocationDataTypeFacebook:
  {
    NSMutableDictionary * graphDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:queryString, @"q",@"place",@"type", [NSString stringWithFormat:@"%.3f,%.3f", coordinate.latitude, coordinate.longitude], @"center", [NSString stringWithFormat:@"%.0f", radius], @"distance", nil];
    FBRequest * request = [self.facebook.facebook requestWithGraphPath:@"search" andParams:graphDict andDelegate:self];
  }
  break;
  case CTLocationDataTypeFoursquare:
  {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f, %f",coordinate.latitude, coordinate.longitude], @"ll",  FOURSQUARE_CLIENT_SECRET, @"client_secret",FOURSQUARE_CLIENT_ID, @"client_id", [NSNumber numberWithInt:radius], @"distance", queryString, @"query", nil];
    BZFoursquareRequest * request = [self.foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request start];
  }
  break;
  case CTLocationDataTypeFactual:
  {
    // alloc query object
    FactualQuery* queryObject = [FactualQuery query];
    [queryObject addFullTextQueryTerm:queryString];
    // set geo filter
    [queryObject setGeoFilter:coordinate radiusInMeters:radius];
    // run query against the US-POI table
    FactualAPIRequest* activeRequest = [self.factual queryTable:@"bi0eJZ" optionalQueryParams:queryObject withDelegate:self];
  }

  break;
  case CTLocationDataTypeCityGrid: {
    CGPlacesSearch* search = [CityGrid placesSearch];
    search.type = CGPlacesSearchTypeRestaurant;
    search.what = queryString;
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    search.latlon = location;
    if (radius > 50.0f) {
      NSLog(@"City Grid maxes out search at 50m, defaulting to 50m. See here: http://docs.citygridmedia.com/display/citygridv2/Places+API#PlacesAPI-SearchUsingLatitudeandLongitude");
      radius = ((CLLocationDistance)50.0f);
    }
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

  case CTLocationDataTypeGoogle:
  {
    [self.googlePlacesConnection getGoogleObjectsWithQuery:queryString andRadius:radius andCoordinates:coordinate andTypes:kAllTypes];
  }
  break;
  case CTLocationDataTypeYahoo:
  {
    CTYahooLocalSearchRequest * request = [[CTYahooLocalSearchRequest alloc] initWithQuery:queryString NumberOfResults:20 Radius:radius Coordinate:coordinate];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *err) {
       NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       NSDictionary * dict = [string objectFromJSONString];
       NSLog (@"JSON Dictionary %@", dict);
       NSArray * resultsArray = [[dict objectForKey:@"ResultSet"] objectForKey:@"Result"];
       NSMutableArray * array = [NSMutableArray arrayWithCapacity:resultsArray.count];
       for (NSDictionary * venue in resultsArray) {

         CTLocationDataManagerResult * result = [CTLocationDataManagerResult resultWithName:[venue objectForKey:@"Title"] Coordinate:CLLocationCoordinate2DMake ([[venue objectForKey:@"Latitude"] floatValue], [[venue objectForKey:@"Longitude"] floatValue])];

         [array addObject:result];
       }
       [self.delegate didReceiveResults:array];
     }];
  }
  break;
  default:
    NSLog (@"Unsupported dataSourceType.");
    break;
  }
}

#pragma mark
#pragma Facebook
- (void)request:(FBRequest *)request didLoad:(id)result {
  NSLog(@"FB %@", result);
  NSDictionary* tmpPlaces = [result objectForKey:@"data"];
  //NSLog (@"%@", self.places);
  NSMutableArray * array = [NSMutableArray arrayWithCapacity:tmpPlaces.count];
  for (NSDictionary * venue in tmpPlaces) {
    NSDictionary * locationDict = [venue objectForKey:@"location"];

    CTLocationDataManagerResult * result = [CTLocationDataManagerResult resultWithName:[venue objectForKey:@"name"] Coordinate:CLLocationCoordinate2DMake([[locationDict objectForKey:@"latitude"] floatValue], [[locationDict objectForKey:@"longitude"] floatValue])];

    [array addObject:result];
  }
  [self.delegate didReceiveResults:array];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
  NSLog(@"%@", response);
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

#pragma mark
#pragma Google
- (void) googlePlacesConnection:(GooglePlacesConnection *)conn didFinishLoadingWithGooglePlacesObjects:(NSMutableArray *)objects {
  NSMutableArray * array = [NSMutableArray arrayWithCapacity:objects.count];
  for (GooglePlacesObject * venue in objects) {
    CTLocationDataManagerResult * result = [CTLocationDataManagerResult resultWithName:venue.name Coordinate:venue.coordinate];
    [array addObject:result];
  }
  [self.delegate didReceiveResults:array];
}

- (void) googlePlacesConnection:(GooglePlacesConnection *)conn didFailWithError:(NSError *)error {
  NSLog(@"%@", error);
}

#pragma mark
#pragma NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

@end
