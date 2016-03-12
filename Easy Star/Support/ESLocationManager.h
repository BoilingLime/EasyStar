//
//  ESLocationManager.h
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class ESLocationManager;

@protocol ESLocationManagerDelegate <NSObject>

@required

- (void)locationManager:(ESLocationManager *)manager didUpdateLatitude:(double)latitude andLongitude:(double)longitude;

@end

@interface ESLocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic, assign) id <ESLocationManagerDelegate> delegate;
@property (strong, nonatomic) CLLocation *currentLocation;

+ (instancetype)sharedInstance;
- (void)updateLocation;

@end