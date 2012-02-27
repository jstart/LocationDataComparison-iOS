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
#import "SynthesizeSingleton.h"
#import "CTLocationConstants.h"
#import "CTLocationDataManagerDelegate.h"
#import "BZFoursquare.h"

@interface CTLocationDataManager : NSObject <BZFoursquareRequestDelegate, FactualAPIDelegate>

@property (nonatomic, strong) BZFoursquare * foursquare;
@property (nonatomic, strong) FactualAPI * factual;
@property (readwrite) CTLocationDataType currentType;
@property (nonatomic, strong) id<CTLocationDataManagerDelegate> delegate;

+(CTLocationDataManager *)sharedCTLocationDataManager;
-(BOOL)setupWithDataSource:(CTLocationDataType)dataSourceType;
-(void)requestPlacesForCoordinate:(CLLocationCoordinate2D)coordinate andRadius:(CLLocationDistance)radius;

@end
