//
//  CTViewController.m
//  LocationDataComparison
//
//  Created by Truman, Christopher on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTViewController.h"
#import "FacebookSupport.h"
#import "CTAppDelegate.h"
#import "CTSearchSettingsViewController.h"
#import "CTClusterTableViewViewController.h"


@implementation CTViewController
@synthesize mapView;
@synthesize settingsButton;
@synthesize toolbar;
@synthesize queue;
@synthesize pickerView;
@synthesize places;
@synthesize fsqPlaces;
@synthesize factualPlaces;
@synthesize dataSources;

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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFacebookPlaces) name:kFacebookConnectedNotificationKey object:nil];
  UIBarButtonItem * sourcesButton = [[UIBarButtonItem alloc] initWithTitle:@"Sources" style:UIBarButtonItemStyleDone target:self action:@selector(showSources:)];
  [self.toolbar setItems:[NSArray arrayWithObjects:sourcesButton, nil] animated:YES];
  self.dataSources = [[NSMutableArray alloc] initWithObjects:@"Facebook",@"Foursquare", @"CityGrid", @"Factual", @"Google", @"Yahoo", nil];
  self.mapView.clusteringEnabled = YES;
  self.mapView.clusteringMethod = OCClusteringMethodBubble;
  self.mapView.clusterSize = 0.1;
}

- (void)viewDidUnload
{
  [self setMapView:nil];
  [self setSettingsButton:nil];
  [self setToolbar:nil];
  [self setPickerView:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeCityGrid];
  [[CTLocationDataManager sharedCTLocationDataManager] setDelegate:self];
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
  if (!self.pickerView.isHidden) {
    [self showSources:self.pickerView];
  }
  // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (void) loadFacebookPlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeFacebook];
  float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:kCTRadiusSetting] floatValue];
  NSString * query = [[NSUserDefaults standardUserDefaults] objectForKey:kCTKeywordSetting];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:radius andQuery:query andMaxResults:[[[NSUserDefaults standardUserDefaults] objectForKey:kCTMaxResultsSetting] intValue]];
}

- (void) loadCityGridPlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeCityGrid];
  float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:kCTRadiusSetting] floatValue];
  NSString * query = [[NSUserDefaults standardUserDefaults] objectForKey:kCTKeywordSetting];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:radius andQuery:query andMaxResults:[[[NSUserDefaults standardUserDefaults] objectForKey:kCTMaxResultsSetting] intValue]];
}

- (void) loadFoursquarePlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeFoursquare];
  float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:kCTRadiusSetting] floatValue];
  NSString * query = [[NSUserDefaults standardUserDefaults] objectForKey:kCTKeywordSetting];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:radius andQuery:query andMaxResults:[[[NSUserDefaults standardUserDefaults] objectForKey:kCTMaxResultsSetting] intValue]];
}

- (void) loadFactualPlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeFactual];
  float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:kCTRadiusSetting] floatValue];
  NSString * query = [[NSUserDefaults standardUserDefaults] objectForKey:kCTKeywordSetting];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:radius andQuery:query andMaxResults:[[[NSUserDefaults standardUserDefaults] objectForKey:kCTMaxResultsSetting] intValue]];
}

- (void) loadGooglePlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeGoogle];
  float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:kCTRadiusSetting] floatValue];
  NSString * query = [[NSUserDefaults standardUserDefaults] objectForKey:kCTKeywordSetting];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:radius andQuery:query andMaxResults:[[[NSUserDefaults standardUserDefaults] objectForKey:kCTMaxResultsSetting] intValue]];
}

- (void) loadYahooPlaces {
  [[CTLocationDataManager sharedCTLocationDataManager] setupWithDataSource:CTLocationDataTypeYahoo];
  float radius = [[[NSUserDefaults standardUserDefaults] objectForKey:kCTRadiusSetting] floatValue];
  NSString * query = [[NSUserDefaults standardUserDefaults] objectForKey:kCTKeywordSetting];
  [[CTLocationDataManager sharedCTLocationDataManager] requestPlacesForCoordinate:mapView.userLocation.coordinate andRadius:radius andQuery:query andMaxResults:[[[NSUserDefaults standardUserDefaults] objectForKey:kCTMaxResultsSetting] intValue]];
}

-(void)showSources:(id)sender{
  if (self.pickerView.hidden) {
    [UIView animateWithDuration:0.2 animations:^{
      self.pickerView.hidden = NO;
      CGRect frame = self.pickerView.frame;
      frame.origin.y = self.view.bounds.size.height - (self.pickerView.frame.size.height + self.toolbar.frame.size.height);
      self.pickerView.frame = frame;
    }];
  }
  else{
    [UIView animateWithDuration:0.2 animations:^{
      CGRect frame = self.pickerView.frame;
      frame.origin.y = [UIScreen mainScreen].bounds.size.height;
      self.pickerView.frame = frame;
    } completion:^(BOOL finished){
      self.pickerView.hidden = YES;
    }];
  }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  return [self.dataSources count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  return [self.dataSources objectAtIndex:row];
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//  
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  switch ((CTLocationDataType) row) {
    case CTLocationDataTypeCityGrid:
      [self loadCityGridPlaces];
      break;
    case CTLocationDataTypeFactual:
      [self loadFactualPlaces];
      break;
    case CTLocationDataTypeFacebook:
      [self loadFacebookPlaces];
      break;
    case CTLocationDataTypeFoursquare:
      [self loadFoursquarePlaces];
      break;
    case CTLocationDataTypeYahoo:
      [self loadYahooPlaces];
      break;
    case CTLocationDataTypeGoogle:
      [self loadGooglePlaces];
      break;
    default:
      @throw @"ERROR, Unsupported data type";
      break;
  }
  [self showSources:self.pickerView];
}

#pragma mark
#pragma MapKitDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
  NSLog(@"Region will change");
//  [self loadPlaces];
  [self.mapView removeOverlays:self.mapView.overlays];
  [self.mapView doClustering];
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
  MKAnnotationView *annotationView;
  
  // if it's a cluster
  if ([annotation isKindOfClass:[OCAnnotation class]]) {
    
    OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;
    
    annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"ClusterView"];
    if (!annotationView) {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusterView"];
      annotationView.canShowCallout = YES;
      annotationView.centerOffset = CGPointMake(0, -20);
    }
    //calculate cluster region
    //CLLocationDistance clusterRadius = mapView.region.span.longitudeDelta * mapView.clusterSize * 111000; //static circle size of cluster
    CLLocationDistance clusterRadius = self.mapView.region.span.longitudeDelta/log(self.mapView.region.span.longitudeDelta*self.mapView.region.span.longitudeDelta) * log(pow([clusterAnnotation.annotationsInCluster count], 4)) * self.mapView.clusterSize * 50000; //circle size based on number of annotations in cluster
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
    [circle setTitle:@"background"];
    [self.mapView addOverlay:circle];
    
    MKCircle *circleLine = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
    [circleLine setTitle:@"line"];
    [self.mapView addOverlay:circleLine];
    
    // set title
    clusterAnnotation.title = @"Cluster";
    NSString * subtitle = @"";
    for (OCAnnotation * annotation in clusterAnnotation.annotationsInCluster) {
      subtitle = [subtitle stringByAppendingString:[NSString stringWithFormat:@" \"%@\" ", annotation.title]];
    }
    clusterAnnotation.subtitle = [NSString stringWithFormat:@"Containing %d annotations: %@", [clusterAnnotation.annotationsInCluster count], subtitle];
    
    // set its image
    annotationView.image = [UIImage imageNamed:@"regular.png"];
    
    // change pin image for group
    if (self.mapView.clusterByGroupTag) {
      if ([clusterAnnotation.groupTag isEqualToString:@"group"]) {
        annotationView.image = [UIImage imageNamed:@"bananas.png"];
      }
      else if([clusterAnnotation.groupTag isEqualToString:@"group2"]){
        annotationView.image = [UIImage imageNamed:@"oranges.png"];
      }
      clusterAnnotation.title = clusterAnnotation.groupTag;
    }
  }
  // If it's a single annotation
  else if([annotation isKindOfClass:[OCMapViewSampleHelpAnnotation class]]){
    OCMapViewSampleHelpAnnotation *singleAnnotation = (OCMapViewSampleHelpAnnotation *)annotation;
    annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"singleAnnotationView"];
    if (!annotationView) {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:singleAnnotation reuseIdentifier:@"singleAnnotationView"];
      annotationView.canShowCallout = YES;
      annotationView.centerOffset = CGPointMake(0, -20);
    }
    singleAnnotation.title = singleAnnotation.groupTag;
    
    if ([singleAnnotation.groupTag isEqualToString:@"group"]) {
      annotationView.image = [UIImage imageNamed:@"banana.png"];
    }
    else if([singleAnnotation.groupTag isEqualToString:@"group2"]){
      annotationView.image = [UIImage imageNamed:@"orange.png"];
    }
  }
  // Error
  else{
    annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"errorAnnotationView"];
    if (!annotationView) {
      annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"errorAnnotationView"];
      annotationView.canShowCallout = NO;
      ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorRed;
    }
  }
  
  [annotationView setCanShowCallout:YES];
  
  return annotationView;
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
  NSLog(@"%@", view.annotation.title);
  if ([view.annotation isKindOfClass:[OCAnnotation class]]) {
    CTClusterTableViewViewController * vc = [[CTClusterTableViewViewController alloc] initWithStyle:UITableViewStylePlain andAnnotations:((OCAnnotation*)view.annotation).annotationsInCluster];
    [self.navigationController pushViewController:vc animated:YES];
  }
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
  MKCircle *circle = overlay;
  MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
  
  if ([circle.title isEqualToString:@"background"])
  {
    circleView.fillColor = [UIColor yellowColor];
    circleView.alpha = 0.25;
  }
  else if ([circle.title isEqualToString:@"helper"])
  {
    circleView.fillColor = [UIColor redColor];
    circleView.alpha = 0.25;
  }
  else
  {
    circleView.strokeColor = [UIColor blackColor];
    circleView.lineWidth = 0.5;
  }
  
  return circleView;
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
      CTLocationDataManagerResult * annotation = [[CTLocationDataManagerResult alloc] init];
      [annotation setTitle:location.title];
      [annotation setCoordinate:location.coordinate];
      [annotation setGroupTag:@"group"];
      [array addObject:annotation];
	  }
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [mapView addAnnotations:array];
	}];

}
-(void)didFailWithError:(NSError*)error{
  NSLog(@"%@", error);
}

@end
