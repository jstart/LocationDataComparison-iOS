//
//  CTSearchSettingsViewController.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCTRadiusSetting @"RadiusSettingStoreKey"
#define kCTKeywordSetting @"KeywordSettingStoreKey"

@interface CTSearchSettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *keywordTextField;
@property (strong, nonatomic) IBOutlet UILabel *currentSearchRadius;
@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)radiusChanged:(id)sender;
- (IBAction)searchClicked:(id)sender;

@end
