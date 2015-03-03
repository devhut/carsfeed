//  DetailFeedViewController.m
//  CarsFeed
//  Created by Dan Lopez on 2/24/15.
//  Copyright (c) 2015 DevHut. All rights reserved.

#import "DetailFeedViewController.h"

@interface DetailFeedViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *forSaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *chassisLabel;

@end

@implementation DetailFeedViewController

- (void)logWithMessage:(NSString*)message {
    NSLog(@"%@ %@", self.class, message);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    // check to see if the image is in cahce, if not then fetch & cache it. image URL is the cache key
    // activity indicator needs to be setup
    NSString *imageURLString = self.vehicleDetail.photosDictionary[@"main_url"];
    UIImage *vehicleImage = [self.imageCache objectForKey:imageURLString];
    if (vehicleImage) {
        self.detailImageView.image = vehicleImage;
        [self.activityIndicator stopAnimating];

    } else {
        // just the async call part from the previous VC
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageURL];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSString *errorMessage =
                [NSString stringWithFormat:@"ERROR FETCHING DETAIL PHOTO -->%@", error];
                [self logWithMessage:errorMessage];
                [self.activityIndicator stopAnimating];
            } else {
                UIImage *theImage = [[UIImage alloc] initWithData:data];
                [self.imageCache setObject:theImage forKey:imageURLString];
                self.detailImageView.image = theImage;
                [self.activityIndicator stopAnimating];
            }
        }];
    }
    
    self.navigationItem.title = self.vehicleDetail.modelType;
    if (self.vehicleDetail.isForSale) {
        self.forSaleLabel.text = @"For Sale";
    } else {
        self.forSaleLabel.text = @"Just Sold";
    }
    self.yearLabel.text = [self.vehicleDetail.year stringValue];
    self.colorLabel.text = self.vehicleDetail.color;
    self.chassisLabel.text = self.vehicleDetail.chassisType;
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat scrollLength = self.chassisLabel.frame.origin.y+self.chassisLabel.frame.size.height+self.navigationController.navigationBar.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollLength);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
