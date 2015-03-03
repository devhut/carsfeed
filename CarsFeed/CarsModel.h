//  CarsModel.h
//  CarsFeed
//  Created by Dan Lopez on 2/18/15.
//  Copyright (c) 2015 DevHut. All rights reserved.

#import <Foundation/Foundation.h>

@interface CarsModel : NSObject

@property (strong, nonatomic) NSDictionary *photosDictionary;
@property (strong, nonatomic) NSNumber *year;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *modelType;
@property (strong, nonatomic) NSString *chassisType;
@property (nonatomic) BOOL isForSale;

- (id)initWithListing:(NSDictionary*)listing;

@end
