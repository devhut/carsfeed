//  FeedTableViewController.h
//  CarsFeed
//  Created by Dan Lopez on 2/15/15.
//  Copyright (c) 2015 DevHut. All rights reserved.

#import <UIKit/UIKit.h>

@interface FeedTableViewController : UITableViewController

/* The copy attribute is an alternative to strong. Instead of taking ownership of the existing object, it 
 creates a copy of whatever you assign to the property, then takes ownership of that. */
@property (nonatomic, copy) NSArray *fetchedData;

@end
