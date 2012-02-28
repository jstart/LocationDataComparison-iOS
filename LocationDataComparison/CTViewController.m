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
  
  UIBarButtonItem * cityGridButton = [[UIBarButtonItem alloc] initWithTitle:@"CityGrid" style:UIBarButtonItemStyleDone target:self action:@selector(loadCityGridPlaces)];
  UIBarButtonItem * foursquareButton = [[UIBarButtonItem alloc] initWithTitle:@"Foursquare" style:UIBarButtonItemStyleDone target:self action:@selector(loadFoursquarePlaces)];
  UIBarButtonItem * factualButton = [[UIBarButtonItem alloc] initWithTitle:@"Factual" style:UIBarButtonItemStyleDone target:self action:@selector(loadFactualPlaces)];
  UIBarButtonItem * facebookButton = [[UIBarButtonItem alloc] initWithTitle:@"Facebook" style:UIBarButtonItemStyleDone target:self action:@selector(loadFacebookPlaces)];
  [facebookButton setWidth:60.0f];
  

  [self.toolbar setItems:[NSArray arrayWithObjects:cityGridButton, foursquareButton, factualButton, facebookButton, nil] animated:YES];
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
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeCityGrid];
  [[CTLocationDataManager sharedCTLocationDataManager] setDelegate:self];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:20.0f];
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

- (void) loadFacebookPlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeFacebook];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:20.0f];
}

- (void) loadCityGridPlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeCityGrid];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:20.0f];
}

- (void) loadFoursquarePlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeFoursquare];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:20.0f];
}

- (void) loadFactualPlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeFactual];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:20.0f];
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
#pragma CTLocationDataManagerDelegate methods
-(void)didReceiveResults:(NSArray*)results{
  NSLog(@"Location Data Manager received %d results.", results.count);
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:results.count];
    for (CTLocationDataManagerResult * location in results) {
      MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
      [annotation setTitle:location.name];
      [annotation setCoordinate:location.coordinate];
      [array addObject:annotation];
	  }
    [self.mapView removeAnnotations:self.mapView.annotations];
    [mapView addAnnotations:array];
	}];

}
-(void)didFailWithError:(NSError*)error{
  NSLog(@"%@", error);
}

@end
