//
//  CTViewController.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CityGrid/CityGrid.h>

@interface CTViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSMutableArray * places;
@property (strong, nonatomic) NSOperationQueue * queue;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (void) loadPlaces;

@end
