//
//  CTViewController.m
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTViewController.h"
#import "BZFoursquare.h"
#import "CTAppDelegate.h"

@implementation CTViewController
@synthesize mapView;
@synthesize settingsButton;
@synthesize toolbar;
@synthesize queue;
@synthesize places;
@synthesize fsqPlaces;
@synthesize factualPlaces;

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.queue = [[NSOperationQueue alloc] init];
  self.places = [[NSMutableArray alloc] init];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFoursquarePlaces) name:@"FoursquareAuthSuccess" object:nil];
}

- (void)viewDidUnload
{
  [self setMapView:nil];
  [self setSettingsButton:nil];
  [self setToolbar:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [mapView removeAnnotations:mapView.annotations];
  [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//  [self loadFoursquarePlaces];
  [self loadFactualPlaces];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (void) loadPlaces {
  [self.queue addOperationWithBlock:^{
     CGPlacesSearch* search = [CityGrid placesSearch];
     search.type = CGPlacesSearchTypeRestaurant;
     CLLocation * location = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
     search.latlon = location;
     search.radius = 20.0;
     search.resultsPerPage = 20;

     NSArray* errors = nil;
     NSArray* tmpPlaces = [search search:&errors].locations;
     if ([errors count] > 0) {
       NSLog (@"%@", errors);
     } else {
       self.places = [tmpPlaces mutableCopy];
       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          //NSLog (@"%@", self.places);
          NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.places.count];
          for (CGPlacesSearchLocation * location in self.places) {
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
            [annotation setTitle:location.name];
            [annotation setSubtitle:location.tagline];
            [annotation setCoordinate:location.latlon.coordinate];
            [array addObject:annotation];
	  }
          [self.mapView removeAnnotations:self.mapView.annotations];
          [mapView addAnnotations:array];
	}];
     }
   }];
}

- (void) loadFoursquarePlaces {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f, %f",mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude], @"ll",  @"IYGRZE1FC4X02XK03JDSTNVS1MYCR1B3C3WMPORAI3OHV5MK", @"client_secret",@"K4XTUDHZYEWKM3I0F543YWCCOILTEQXOXH3Z4UGMSJQOVM3B", @"client_id", nil];
    BZFoursquareRequest * request = [appDelegate.foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request start];
}

- (void) loadFactualPlaces {
  // alloc query object
  FactualQuery* queryObject = [FactualQuery query];
  
  // set geo filter
  [queryObject setGeoFilter:mapView.centerCoordinate radiusInMeters:200.00];

  
  // run query against the US-POI table
  FactualAPIRequest* activeRequest = [appDelegate.factual queryTable:@"bi0eJZ" optionalQueryParams:queryObject withDelegate:self];
}

#pragma mark
#pragma MapKitDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
  NSLog(@"Region will change");
//  [self loadPlaces];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
}

// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  MKPinAnnotationView * view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
  [view setCanShowCallout:YES];

  if (annotation.coordinate.latitude != self.mapView.userLocation.location.coordinate.latitude && annotation.coordinate.longitude != self.mapView.userLocation.location.coordinate.longitude) {
    [view setAnimatesDrop:YES];
  }
  return view;
}

// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
}

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0){
  NSLog(@"%@, %@", view.annotation.title, view.annotation.subtitle);
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0){
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView NS_AVAILABLE(NA, 4_0){
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView NS_AVAILABLE(NA, 4_0){
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(NA, 4_0){
//  [self loadPlaces];
  [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error NS_AVAILABLE(NA, 4_0){
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
 fromOldState:(MKAnnotationViewDragState)oldState NS_AVAILABLE(NA, 4_0){
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0){
  return nil;
}

// Called after the provided overlay views have been added and positioned in the map.
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews NS_AVAILABLE(NA, 4_0){
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0){
}

#pragma mark
#pragma Foursquare
- (void)requestDidStartLoading:(BZFoursquareRequest *)request{  
  NSLog(@"Foursquare request did start loading %@, %@", request, [request response]);
}

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request{
  [self.queue addOperationWithBlock:^{
    NSArray* errors = nil;
    NSDictionary* tmpPlaces = [[request response] objectForKey:@"venues"];
    self.fsqPlaces = [tmpPlaces mutableCopy];
    if ([errors count] > 0) {
      NSLog (@"%@", errors);
    } else {
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //NSLog (@"%@", self.places);
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.fsqPlaces.count];
        for (NSDictionary * venue in self.fsqPlaces) {
          MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
          [annotation setTitle:[venue objectForKey:@"name"]];
//          [annotation setSubtitle:location.tagline];
          NSDictionary * locationDict = [venue objectForKey:@"location"];
          [annotation setCoordinate:CLLocationCoordinate2DMake([[locationDict objectForKey:@"lat"] floatValue], [[locationDict objectForKey:@"lng"] floatValue])];
          [array addObject:annotation];
        }
        [self.mapView removeAnnotations:self.mapView.annotations];
        [mapView addAnnotations:array];
      }];
    }
  }];

}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error{
  
}

#pragma mark
#pragma Factual
- (void)requestComplete:(FactualAPIRequest*) request{
  NSLog(@"Factual request complete: %@", request  );
}
- (void)requestComplete:(FactualAPIRequest*) request receivedUpdateResult:(FactualUpdateResult*) updateResult{
  
}

/*! @discussion This method gets called when a queryTable request successfully 
 completes on the server. The results of the request are passed to the caller
 in the FactualQueryResult object. Please see related FactualQueryResult 
 docs for more details.
 
 @param request The request context object 
 
 @param queryResult The FactualQueryResult result object
 */

- (void)requestComplete:(FactualAPIRequest*) request receivedQueryResult:(FactualQueryResult*) queryResult{
  [self.queue addOperationWithBlock:^{
    NSArray* errors = nil;
    NSDictionary* tmpPlaces = [queryResult rows];
    self.factualPlaces = [tmpPlaces mutableCopy];
    if ([errors count] > 0) {
      NSLog (@"%@", errors);
    } else {
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //NSLog (@"%@", self.places);
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.factualPlaces.count];
        for (FactualRow * venue in self.factualPlaces) {
          NSDictionary * factualDictionary = [venue namesAndValues];
          MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
          [annotation setTitle:[factualDictionary objectForKey:@"name"]];
          //          [annotation setSubtitle:location.tagline];
          [annotation setCoordinate:CLLocationCoordinate2DMake([[factualDictionary objectForKey:@"latitude"] floatValue], [[factualDictionary objectForKey:@"longitude"] floatValue])];
          [array addObject:annotation];
        }
        [self.mapView removeAnnotations:self.mapView.annotations];
        [mapView addAnnotations:array];
      }];
    }
  }];

}

/*! @discussion This method gets called when a getTableSchema request successfully 
 completes on the server. The results of the request are passed to the caller
 in the FactualSchemaResult object. Please see related FactualSchemaResult 
 docs for more details.
 
 @param request The request context object 
 
 @param schemaResult The FactualSchemaResult result object
 */

- (void)requestComplete:(FactualAPIRequest*) request receivedSchemaResult:(FactualSchemaResult*) schemaResult{
  
}

@end
