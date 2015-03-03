//
//  AppDelegate.m
//  CarsFeed
//
//  Created by Dan Lopez on 2/15/15.
//  Copyright (c) 2015 DevHut. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
/* 
Have students copy and paste code. Run in iphone 57.3, and observe sizing issue.
 
 
*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // access to the Xcode project bundle files, not OS file paths
    // NSString *pathToPList = [[NSBundle mainBundle] pathForResource:@"listings" ofType:@"plist"];
    // NSArray *plistArray = [NSArray arrayWithContentsOfFile:pathToPList];
    // these dictionaries are a simulated JSON fetch
    NSDictionary *photos0 = @{@"main_url" : @"http://devhut.me/axdemo/dakare90.jpg"};
    NSDictionary *car0 = @{@"photos" : photos0,
                             @"year" : @2011,
                            @"color" : @"Dakar Yellow",
                       @"model_type" : @"M3",
                     @"chassis_type" : @"E90 Saloon",
                         @"for_sale" : @1};
    NSDictionary *photos1 = @{@"main_url" : @"http://devhut.me/axdemo/e39.png"};
    NSDictionary *car1 = @{@"photos" : photos1,
                             @"year" : @2002,
                            @"color" : @"Le Mans Blue",
                       @"model_type" : @"M5",
                     @"chassis_type" : @"E39",
                         @"for_sale" : @1};
    NSDictionary *photos2 = @{@"main_url" : @"http://devhut.me/axdemo/e46csl.jpg"};
    NSDictionary *car2 = @{@"photos" : photos2,
                             @"year" : @2001,
                            @"color" : @"Silver Grey Metallic",
                       @"model_type" : @"M3 CSL",
                     @"chassis_type" : @"E46",
                         @"for_sale" : @0};
    NSDictionary *photos3 = @{@"main_url" : @"http://devhut.me/axdemo/e60.png"};
    NSDictionary *car3 = @{@"photos" : photos3,
                             @"year" : @2006,
                            @"color" : @"Cosmos Black",
                       @"model_type" : [NSNull null],
                     @"chassis_type" : @"E60",
                         @"for_sale" : @1};
    NSDictionary *photos4 = @{@"main_url" : @"http://devhut.me/axdemo/e303.jpg"};
    NSDictionary *car4 = @{@"photos" : photos4,
                             @"year" : @1990,
                            @"color" : @"Alpine White I",
                       @"model_type" : @"M3",
                     @"chassis_type" : @"E30",
                         @"for_sale" : @1};
    NSDictionary *photos5 = @{@"main_url" : @"http://devhut.me/axdemo/estroil1.jpg"};
    NSDictionary *car5 = @{@"photos" : photos5,
                             @"year" : @1999,
                            @"color" : @"Estoril Blue",
                       @"model_type" : @"M3",
                     @"chassis_type" : @"E36",
                         @"for_sale" : @0};
    NSDictionary *photos6 = @{@"main_url" : @"http://devhut.me/axdemo/gtr.jpg"};
    NSDictionary *car6 = @{@"photos" : photos6,
                             @"year" : @2000,
                            @"color" : @"Motorsport White",
                       @"model_type" : @"M3",
                     @"chassis_type" : @"E46",
                         @"for_sale" : @0};
    NSDictionary *photos7 = @{@"main_url" : @"http://devhut.me/axdemo/imola3.jpg"};
    NSDictionary *car7 = @{@"photos" : photos7,
                             @"year" : @2003,
                            @"color" : @"Imola Red",
                       @"model_type" : @"M3",
                     @"chassis_type" : [NSNull null],
                         @"for_sale" : @1};
    NSDictionary *photos8 = @{@"main_url" : @"http://devhut.me/axdemo/imolae30.jpg"};
    NSDictionary *car8 = @{@"photos" : photos8,
                             @"year" : @1990,
                            @"color" : @"Imola Red",
                       @"model_type" : @"M3",
                     @"chassis_type" : @"E30",
                         @"for_sale" : @1};
    NSDictionary *photos9 = @{@"main_url" : @"http://devhut.me/axdemo/whitee36saloon.jpg"};
    NSDictionary *car9 = @{@"photos" : photos9,
                             @"year" : @1997,
                            @"color" : @"Alpine White II",
                       @"model_type" : @"M3",
                     @"chassis_type" : @"E36 Saloon",
                         @"for_sale" : @1};

    NSArray *allListings = @[car0, car1, car2, car3, car4, car5, car6, car7, car8, car9];
    // pass this array to the root VC in the nav controller
    UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
    FeedTableViewController *feedTableVC = nav.viewControllers[0];
    feedTableVC.fetchedData = allListings;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
