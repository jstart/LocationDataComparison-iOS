//
//  CTLocationDataManager.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CityGrid/CityGrid.h>
#import <FactualSDK/FactualAPI.h>
#import "GooglePlacesConnection.h"
#import "FacebookSupport.h"
#import "SynthesizeSingleton.h"
#import "CTLocationConstants.h"
#import "CTLocationDataManagerDelegate.h"
#import "BZFoursquare.h"
#import "CTYahooLocalSearchRequest.h"
#import "CTYelpLocalSearchRequest.h"

@interface CTLocationDataManager : NSObject <BZFoursquareRequestDelegate, FactualAPIDelegate, FBSessionDelegate,FBRequestDelegate, GooglePlacesConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) BZFoursquare * foursquare;
@property (nonatomic, strong) FactualAPI * factual;
@property (nonatomic, strong) FacebookSupport * facebook;
@property (nonatomic, strong) GooglePlacesConnection * googlePlacesConnection;
@property (readwrite) CTLocationDataType currentType;
@property (nonatomic, strong) id<CTLocationDataManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableData *yelpResponseData;
+ (CTLocationDataManager *)sharedCTLocationDataManager;
- (void)setupWithDataSource:(CTLocationDataType)dataSourceType;
- (void)requestPlacesForCoordinate:(CLLocationCoordinate2D)coordinate andRadius:(CLLocationDistance)radius andQuery:(NSString*)queryString andMaxResults:(int)maxResults;

@end
