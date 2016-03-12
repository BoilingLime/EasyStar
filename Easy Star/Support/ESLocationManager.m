//
//  ESLocationManager.m
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "ESLocationManager.h"

@implementation ESLocationManager

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        [self locationManager];
    }
    return self;
}


+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ESLocationManager alloc] init];
    });
    
    return sharedInstance;
}

- (void) locationManager
{
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    else {
        
    }
}

- (void)updateLocation
{
    
    [locationManager requestWhenInUseAuthorization];

    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = [locations lastObject];
 
    CLLocationCoordinate2D coordinate = [_currentLocation coordinate];

    [locationManager stopUpdatingLocation];
    if ([_delegate respondsToSelector:@selector(locationManager:didUpdateLatitude:andLongitude:)]) {
        [_delegate locationManager:self didUpdateLatitude:coordinate.latitude andLongitude:coordinate.longitude];
    };

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}


@end
