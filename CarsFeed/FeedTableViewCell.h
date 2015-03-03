//  FeedTableViewCell.h
//  CarsFeed
//  Created by Dan Lopez on 2/18/15.
//  Copyright (c) 2015 DevHut. All rights reserved.

#import <UIKit/UIKit.h>

#define CELL_ID @"VehcileCell"

@interface FeedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *vehicleImageView;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelColorLabel;

@end
