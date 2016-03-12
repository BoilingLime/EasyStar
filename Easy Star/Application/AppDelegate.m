//
//  AppDelegate.m
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "AppDelegate.h"
#import "ESStaticsDataManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the default Realm to the one with preloaded data from GTFS format
    
    [[ESStaticsDataManager sharedInstance] changeDefaultRealmPath];
 
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName :[UIFont fontWithName:@"MavenProLight300-Regular" size:22.0],
                                                            NSForegroundColorAttributeName : [UIColor colorWithRed:243.0 / 255.0 green:13.0 / 255.0 blue:27.0 / 255.0 alpha:1.0]}];
    return YES;
}

@end
