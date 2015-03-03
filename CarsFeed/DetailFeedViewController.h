//  DetailFeedViewController.h
//  CarsFeed
//  Created by Dan Lopez on 2/24/15.
//  Copyright (c) 2015 DevHut. All rights reserved.

#import <UIKit/UIKit.h>
#import "CarsModel.h"

@interface DetailFeedViewController : UIViewController

@property (nonatomic, weak) CarsModel *vehicleDetail;
@property (nonatomic, strong) NSCache *imageCache;

@end
