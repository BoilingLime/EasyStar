//
//  ESDiplayBusResultViewController.m
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "ESDisplayBusResultViewController.h"
#import "ESHttpClient.h"
#import "ESBusDeparture.h"
#import "ESBusTableViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>


@interface ESDisplayBusResultViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation ESDisplayBusResultViewController

@synthesize busData = _busData;
@synthesize busStops = _busStops;
@synthesize distinctStops = _distinctStops;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self fetchDataFromApiToDataSource];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchDataFromApiToDataSource
{
    _busData = [NSMutableArray array];
    
    NSMutableArray *stopIds = [self buildSubArrays];
    
    __block int finished = 0;
    
    for (__block int it = 0; it < [stopIds count]; it++) {
        [ESHttpClient getDepartureInfosAtStops:stopIds[it] withCompletionHandler:^(NSDictionary *data){
            
            finished += 1;
            
            NSArray *allDepartures = [NSArray array];
            
            allDepartures = [data valueForKeyPath:@"opendata.answer.data.stopline"];
            
            if ([allDepartures isKindOfClass:[NSDictionary class] ]) {
                allDepartures = nil;
                allDepartures = [NSArray arrayWithObject:[data valueForKeyPath:@"opendata.answer.data.stopline"]];
            }
            
            for (NSDictionary *dic in allDepartures) {
                
                NSArray *departures = [dic valueForKeyPath:@"departures.departure"];
                
                for (NSDictionary *departuresDic in departures) {
                    ESBusDeparture *bus = [[ESBusDeparture alloc] init];
                    bus.routeId = [dic valueForKey:@"route"];
                    bus.stopId = [dic valueForKey:@"stop"];
                    if ([departures isKindOfClass:[NSArray class]]) {
                        bus.dateString = [departuresDic valueForKey:@"content"];
                        bus.headSign = [[departuresDic objectForKey:@"@attributes"] objectForKey:@"headsign"];
                        [_busData addObject:bus];
                    }
                    else if ([departures isKindOfClass:[NSDictionary class]]){
                        bus.dateString = [departures valueForKey:@"content"];
                        bus.headSign = [[(NSDictionary *)departures objectForKey:@"@attributes"] objectForKey:@"headsign"];
                        [_busData addObject:bus];
                        break;
                    }
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [_tableView reloadData];
                if (finished == it && [_busData count] == 0) {
                    [SVProgressHUD setFont:[UIFont fontWithName:@"MavenProLight300-Regular" size:16]];
                    [SVProgressHUD showInfoWithStatus:@"Aucun départ" maskType:SVProgressHUDMaskTypeGradient];
                }
            });
            
        }
                                       failure:^(NSError *error) {
                                           [SVProgressHUD setFont:[UIFont fontWithName:@"MavenProLight300-Regular" size:16]];
                                           [SVProgressHUD showErrorWithStatus:@"Une erreur est survenue\ndans la recupération des données!" maskType:SVProgressHUDMaskTypeGradient];
                                       }];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_busData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"kCellBusDisplay";
    
    
    ESBusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    cell.routeLabel.text = ((ESBusDeparture*)_busData[indexPath.item]).headSign;
    [cell.routeLabel sizeToFit];
    
    [cell.iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", ((ESBusDeparture*)_busData[indexPath.item]).routeId]]];
    
    cell.timeLabel.text = [self dateFormaterFromString:((ESBusDeparture*)_busData[indexPath.item]).dateString];
    
    [cell.timeLabel sizeToFit];
    
    
    return cell;
}

#pragma mark - Utils

- (NSString *)dateFormaterFromString:(NSString*)stringDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    NSDate *date = [dateFormat dateFromString:stringDate];
    NSDate *now = [NSDate date];
    
    NSTimeInterval secondsBetween = [date timeIntervalSinceDate:now];
    
    NSInteger minutes = secondsBetween / 60;
    
    NSString *formattedString;
    
    if (minutes < 60) {
        formattedString = [NSString stringWithFormat:@"%ld minutes", (minutes < 0 ? 0 : minutes)];
    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        
        formattedString = [NSString stringWithFormat:@"%ld H %ld minutes", hour, minute];
    }
    
    return formattedString;
}

- (NSMutableArray *)buildSubArrays
{
    NSMutableArray *containerArray = [NSMutableArray array];
    NSMutableArray *subArray = [NSMutableArray array];
    
    for (int it = 0; it < [_busStops count]; it++) {
        [subArray addObject:((ESStop *)_busStops[it]).id];

        if ([subArray count] == 5 || it == ([_busStops count] - 1)) {
            [containerArray addObject:[subArray copy]];
            [subArray removeAllObjects];
        }
    }
    
    return containerArray;
}

@end
