//
//  CTLocationConstants.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef LocationDataComparison_CTLocationConstants_h
#define LocationDataComparison_CTLocationConstants_h

#pragma mark
#pragma API_KEYS

#pragma CITY_GRID
#define CITY_GRID_PUBLISHER @"test"
#define CITY_GRID_PLACEMENT @"ios-example"
#define CITY_GRID_DEBUG NO

#pragma FOURSQUARE
#define FOURSQUARE_CLIENT_ID @"K4XTUDHZYEWKM3I0F543YWCCOILTEQXOXH3Z4UGMSJQOVM3B"
#define FOURSQUARE_CLIENT_SECRET @"IYGRZE1FC4X02XK03JDSTNVS1MYCR1B3C3WMPORAI3OHV5MK"
#define FOURSQUARE_AUTHORIZATION_CALLBACK_URL @"fsqdemo://foursquare"
#define FOURSQUARE_VERIFICATION_DATE @"20120227"

#pragma FACTUAL
#define FACTUAL_SERVER_KEY @"S0mvKJsSItrI76wNrFsa2Y9tfHEFENJ6fd5XFvdG9qFo1THE5Fh0FpUeHBUBybBD"


#pragma DATA_SOURCE_TYPE
typedef enum{
  CTLocationDataTypeFacebook = 0,
  CTLocationDataTypeFoursquare,
  CTLocationDataTypeCityGrid,
  CTLocationDataTypeFactual
}CTLocationDataType;

#endif
