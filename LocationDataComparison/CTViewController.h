//
//  CTViewController.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "OCMapView.h"
#import "OCMapViewSampleHelpAnnotation.h"
#import "CTLocationDataManagerDelegate.h"
#import "CTLocationDataManagerResult.h"
#import "CTLocationDataManager.h"

@interface CTViewController : UIViewController <MKMapViewDelegate, CTLocationDataManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray * dataSources;
@property (strong, nonatomic) NSMutableArray * places;
@property (strong, nonatomic) NSMutableDictionary * fsqPlaces;
@property (strong, nonatomic) NSMutableDictionary * factualPlaces;
@property (strong, nonatomic) NSOperationQueue * queue;
@property (strong, nonatomic) IBOutlet OCMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (void) loadCityGridPlaces;
- (void) loadFoursquarePlaces;
- (void) loadFacebookPlaces;
- (void) loadFactualPlaces;
- (void) loadGooglePlaces;
- (void) loadYahooPlaces;

@end
