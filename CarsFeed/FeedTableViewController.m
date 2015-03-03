//  FeedTableViewController.m
//  CarsFeed
//  Created by Dan Lopez on 2/15/15.
//  Copyright (c) 2015 DevHut. All rights reserved.

#import "FeedTableViewController.h"
#import "DetailFeedViewController.h"
#import "FeedTableViewCell.h"
#import "CarsModel.h"

// alternative block syntax and ID's for the default image
typedef void (^DownloadImages) (BOOL success, UIImage *image);
NSString *const kDefaultImage = @"defaultImage.png";
#define DEFAULT_IMAGE @"defaultImage"

@interface FeedTableViewController () {
    NSMutableArray *_vehiclesArray;
    NSMutableArray *_searchResultsArray;
    NSCache *_cacheOnly;
    UITableView *_activeTableView;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation FeedTableViewController

- (void)logWithMessage:(NSString*)message {
    NSLog(@"%@ %@", self.class, message);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* if you wanted to use a xib
    UINib *cellNib = [UINib nibWithNibName:@"FeedTableViewCell"
                                    bundle:[NSBundle mainBundle]];
    [self.mainTableView registerNib:cellNib forCellReuseIdentifier:@"VehicleCell"];
    */
    
    // alloc/init our resources
    _vehiclesArray = [NSMutableArray array];
    _searchResultsArray = [NSMutableArray array];
    _cacheOnly = [[NSCache alloc]init];
    
    // lets perform this work on another thread to keep our UI fresh
    dispatch_async(dispatch_queue_create("com.loopingThroughData", NULL), ^{
        for (NSDictionary *vehicle in self.fetchedData) {
            // set up a mutable dictionary that we can alter
            NSMutableDictionary *mutVehicle = [NSMutableDictionary dictionaryWithDictionary:vehicle];
            /* loop through the fetched data and check for any null values (strings in this case), 
             set them to a string with "N/A". we check the dictionary in the fetchedData array, 
             but alter the mutVehicle because it can be problematic to mutate something while it is being enumerated */
            NSNull *null = [NSNull null];
            for (id key in vehicle) {
                if ([vehicle[key] isEqual:null]) {
                    //NSLog(@"NULL --> %@", mutVehicle);
                    mutVehicle[key] = @"N/A";
                }
            }
            /*  a NULL dictionary is dangerous! so lets check... */
            if ([vehicle[@"photos"] isEqual:null]) {
                mutVehicle[@"photos"] = @{@"main_url" : @""};
            }
            // create objects with the mutated dictionary and add it to the vehicles array
            CarsModel *model = [[CarsModel alloc]initWithListing:mutVehicle];
            [_vehiclesArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // update our UI on the main thread!! duh...
            self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
            [self.mainTableView reloadData];
        });
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchResultsArray.count;
    } else {
        return _vehiclesArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // a bit of a hack, but get the active tableView if you're using the segue
    _activeTableView = tableView;
    // good practice to reference self.tableView
    FeedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"VehicleCell"
                                                                   forIndexPath:indexPath];
    CarsModel *carsModel;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        carsModel = _searchResultsArray[indexPath.row];
    } else {
        carsModel = _vehiclesArray[indexPath.row];
    }
    /* set the default image while the photo is fetched. 
     check to see if we have already cached the image, if not then go fetch it. if there is an error in the fetch, the default image will stay rendered */
    cell.vehicleImageView.image = [UIImage imageNamed:kDefaultImage];
    NSString *photoURL = carsModel.photosDictionary[@"main_url"];
    UIImage *cachedImage = [_cacheOnly objectForKey:photoURL];
    if (cachedImage) {
        cell.vehicleImageView.image = cachedImage;
    } else {
        NSURL *imageURL = [NSURL URLWithString:photoURL];
        // perform an async fetch
        [self downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [_cacheOnly setObject:image forKey:photoURL];
                cell.vehicleImageView.image = image;
                UITableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                if (updateCell) {
                    cell.vehicleImageView.image = image;
                }
            }
        }];
    }
    
    cell.yearLabel.text = [carsModel.year stringValue];
    NSString *modelAndColor = [NSString stringWithFormat:@"///%@, %@", carsModel.modelType, carsModel.color];
    cell.modelColorLabel.text = modelAndColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /* alternative code to segue :)
    DetailFeedViewController *detailVC = [self.storyboard
            instantiateViewControllerWithIdentifier:@"DetailFeedViewController"];
    detailVC.imageCache = _imageCache;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        detailVC.vehicleDetail = _searchResultsArray[indexPath.row];
    } else {
        detailVC.vehicleDetail = _vehiclesArray[indexPath.row];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
    */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToDetail"]) {
        /* pass the cache object, and depending on what table view is being used, 
         an array with vehicle objects */
        DetailFeedViewController *detailVC = segue.destinationViewController;
        detailVC.imageCache = _cacheOnly;
        NSIndexPath *indexPath;
        // could also check with self.searchDisplayController.searchResultsTableView is active
        if (_activeTableView == self.searchDisplayController.searchResultsTableView) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            detailVC.vehicleDetail = _searchResultsArray[indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            detailVC.vehicleDetail = _vehiclesArray[indexPath.row];
        }
    }
}

#pragma mark - photo download
- (void)downloadImageWithURL:(NSURL *)url
             completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
           UIImage *image = [[UIImage alloc] initWithData:data];
           completionBlock(YES, image);
        } else {
           NSString *errorMessage = [NSString
                                     stringWithFormat:@"ERROR FETCHING PHOTOS --> %@",error];
            [self logWithMessage:errorMessage];
           completionBlock(NO, nil);
        }
    }];
    
}
/* the alternative block implementation for the declared typdef
- (void)downloadImageWithURL:(NSURL*)url withCompletion:(DownloadImages)complete {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
           UIImage *image = [[UIImage alloc] initWithData:data];
           complete(YES, image);
        } else {
           complete(NO, nil);
        }
    }];
}
*/
#pragma mark - UISearchDisplayController Delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    /* this method is called everytime text is entered into the search bar, 
     and refreshes the search results table view */
    [self filterContentForSearchText:searchString scope:nil];
    return YES;
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    /* remove all the objects in the results array, and re-instantiate with a capacity equal to the vehciles array. loop through the vehicles array, and with apples predicate class (query language) get the search text and check to see if any of those characters are contained in any of the model types of the vehicles. Those vehicle objects will then be added to the search results array. */
    [_searchResultsArray removeAllObjects];
    _searchResultsArray = [NSMutableArray arrayWithCapacity:_vehiclesArray.count];
    for (CarsModel *car in _vehiclesArray) {
        NSPredicate *predicate = [NSPredicate
                                  predicateWithFormat:@"%@ CONTAINS[c] %@", car.modelType, searchText];
        if ([predicate evaluateWithObject:car]) {
            //NSLog(@"EVAL NAME --> %@", car.modelType);
            [_searchResultsArray addObject:car];
        }
    }
}

@end
