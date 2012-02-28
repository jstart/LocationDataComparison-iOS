//
//  CTYahooLocalObject.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTYahooLocalObject : NSObject
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * phone;
@property (readwrite) double latitude;
@property (readwrite) double longitude;
@property (nonatomic, strong) NSString * rating;

@end
