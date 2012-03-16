//
//  CTClusterTableViewViewController.h
//  LocationDataComparison
//
//  Created by Truman, Christopher on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTClusterTableViewViewController : UITableViewController
@property (nonatomic, readwrite) NSArray * annotations;
- (id)initWithStyle:(UITableViewStyle)style andAnnotations:(NSArray*)newAnnotations;
@end
