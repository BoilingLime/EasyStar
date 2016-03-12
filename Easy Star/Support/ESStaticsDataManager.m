//
//  ESStaticsDataManager.m
//  Easy Star
//
//  Created by Longueville Xavier on 09/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "ESStaticsDataManager.h"
#import "CHCSVParser.h"
#import "ESStop.h"
#import "ESTrip.h"
#import "ESRoute.h"

@implementation ESStaticsDataManager

+ (instancetype) sharedInstance {
    static ESStaticsDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] initInstance];
    });

    return sharedInstance;
}

- (instancetype) initInstance {
    self = [super init];

    if (self) {
        return self;
    }

    return nil;
}


- (void) loadData
{
//    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealmConfiguration defaultConfiguration].path error:nil];

    [self loadStops];
    [self loadRoutes];
    [self loadTrips];
    
    NSLog(@"path : %@", [RLMRealmConfiguration defaultConfiguration].path);
}

- (void) loadStops
{
    NSURL *path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stops" ofType:@"csv"]];

    NSError *error = nil;
    NSArray *rows =  [NSArray arrayWithContentsOfDelimitedURL:path options:CHCSVParserOptionsUsesFirstLineAsKeys delimiter:',' error:&error];
    
    if (!error) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (NSDictionary *stopInfos in rows) {
            ESStop *stop = [[ESStop alloc] init];

            for (NSString *info in stopInfos) {
                NSString *parsedValue =  [[stopInfos objectForKey:info] substringWithRange:NSMakeRange(1,[[stopInfos objectForKey:info] length] - 2)];
                
                if ([info isEqualToString:@"stop_id"]) {
                    stop.id = parsedValue;
                }
                else if ([info isEqualToString:@"stop_code"]) {
                    stop.code = parsedValue;
                }
                else if ([info isEqualToString:@"stop_name"]) {
                    stop.name = parsedValue;
                }
                else if ([info isEqualToString:@"stop_desc"]) {
                    stop.desc = parsedValue;
                }
                else if ([info isEqualToString:@"stop_lat"]) {
                    stop.latitude = [parsedValue doubleValue];
                }
                else if ([info isEqualToString:@"stop_lon"]) {
                    stop.longitude = [parsedValue doubleValue];
                }
            }
            [realm addObject:stop];
        }
        [realm commitWriteTransaction];
    }
}

- (void) loadTrips
{
    NSURL *path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"trips" ofType:@"csv"]];
    
    NSError *error = nil;
    NSArray *rows =  [NSArray arrayWithContentsOfDelimitedURL:path options:CHCSVParserOptionsUsesFirstLineAsKeys delimiter:',' error:&error];
    
    if (!error) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (NSDictionary *stopInfos in rows) {
            ESTrip *trip = [[ESTrip alloc] init];

            for (NSString *info in stopInfos) {
                NSString *parsedValue =  [[stopInfos objectForKey:info] substringWithRange:NSMakeRange(1,[[stopInfos objectForKey:info] length] - 2)];
                
                if ([info isEqualToString:@"route_id"]) {
                    trip.tripId = parsedValue;
                }
                else if ([info isEqualToString:@"service_id"]) {
                    trip.serviceId = parsedValue;
                }
                else if ([info isEqualToString:@"trip_id"]) {
                    trip.routeId = parsedValue;
                }
                else if ([info isEqualToString:@"trip_headsign"]) {
                    trip.headsign = parsedValue;
                }
                else if ([info isEqualToString:@"direction_id"]) {
                    trip.direction = [parsedValue boolValue];
                }
                else if ([info isEqualToString:@"wheelchair_accessible"]) {
                    trip.wheelchairAccessible = [parsedValue boolValue];
                }
            }
            [realm addObject:trip];
        }
        [realm commitWriteTransaction];
    }
}

- (void) loadRoutes
{
    NSURL *path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"routes" ofType:@"csv"]];
    
    NSError *error = nil;
    NSArray *rows =  [NSArray arrayWithContentsOfDelimitedURL:path options:CHCSVParserOptionsUsesFirstLineAsKeys delimiter:',' error:&error];
    
    if (!error) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (NSDictionary *stopInfos in rows) {
            ESRoute *route = [[ESRoute alloc] init];
            
            for (NSString *info in stopInfos) {
                NSString *parsedValue =  [[stopInfos objectForKey:info] substringWithRange:NSMakeRange(1,[[stopInfos objectForKey:info] length] - 2)];

                if ([info isEqualToString:@"route_id"]) {
                    route.id = parsedValue;
                }
                else if ([info isEqualToString:@"agency_id"]) {
                    route.agencyId = parsedValue;
                }
                else if ([info isEqualToString:@"route_short_name"]) {
                    route.shortName = parsedValue;
                }
                else if ([info isEqualToString:@"route_long_name"]) {
                    route.longName = parsedValue;
                }
                else if ([info isEqualToString:@"route_desc"]) {
                    route.desc = parsedValue;
                }
                else if ([info isEqualToString:@"route_type"]) {
                    route.type = parsedValue;
                }
                else if ([info isEqualToString:@"route_color"]) {
                    route.color = parsedValue;
                }
                else if ([info isEqualToString:@"route_text_color"]) {
                    route.textColor = parsedValue;
                }
            }
            [realm addObject:route];
        }
        [realm commitWriteTransaction];
    }
}


- (void) changeDefaultRealmPath
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.readOnly = YES;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *seedFilePath = [mainBundle pathForResource:@"PreloadedStops" ofType:@"realm"];
    config.path = seedFilePath;
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

@end
