//  CarsModel.m
//  CarsFeed
//  Created by Dan Lopez on 2/18/15.
//  Copyright (c) 2015 DevHut. All rights reserved.

#import "CarsModel.h"

@implementation CarsModel

- (id)initWithListing:(NSDictionary*)listing {
    self = [super init];
    if (self) {
        _photosDictionary = listing[@"photos"];
        _year = listing[@"year"];
        _color = listing[@"color"];
        _modelType = listing[@"model_type"];
        _chassisType = listing[@"chassis_type"];
        _isForSale = [listing[@"for_sale"] boolValue];
    }
    return self;
}

@end
