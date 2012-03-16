//
//  CTSearchSettingsViewController.m
//  LocationDataComparison
//
//  Created by Truman, Christopher on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTSearchSettingsViewController.h"

@implementation CTSearchSettingsViewController
@synthesize keywordTextField;
@synthesize currentSearchRadius;
@synthesize radiusSlider;
@synthesize maxResultsField;
@synthesize searchButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
  [self setKeywordTextField:nil];
  [self setCurrentSearchRadius:nil];
  [self setRadiusSlider:nil];
  [self setSearchButton:nil];
  [self setMaxResultsField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)radiusChanged:(id)sender {
  self.currentSearchRadius.text = [NSString stringWithFormat:@"%.1fm", ((UISlider*)sender).value];
}

- (IBAction)searchClicked:(id)sender {
  //save settings
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.radiusSlider.value] forKey:kCTRadiusSetting];
  [[NSUserDefaults standardUserDefaults] setObject:self.keywordTextField.text ? self.keywordTextField.text : @"coffee" forKey:kCTKeywordSetting];
  [[NSUserDefaults standardUserDefaults] setObject:self.maxResultsField.text forKey:kCTMaxResultsSetting];
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  return YES;
}
@end
