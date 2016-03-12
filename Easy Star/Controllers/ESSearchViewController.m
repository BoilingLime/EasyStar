//
//  ESSearchViewController.m
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "ESSearchViewController.h"
#import "ESCustomSearchController.h"
#import "ESDisplayBusResultViewController.h"
#import "ESStop.h"
#import "ESLocationManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ESSearchViewController () <UISearchBarDelegate, ESCustomSearchControllerDelegate, ESLocationManagerDelegate>
{
    ESCustomSearchController *stopsSearchController;

    BOOL shouldShowSearchResults;

    RLMResults *stops;
    
    NSMutableArray *filteredStops;
    NSMutableArray *disctinctStops;
    
    ESLocationManager *locationManager;
}

@end

@implementation ESSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_title_view"]];
    self.navigationItem.titleView = titleView;

    locationManager = [ESLocationManager sharedInstance];
    locationManager.delegate = self;
    
    shouldShowSearchResults = NO;

    filteredStops = [NSMutableArray array];
    
    stops = [[ESStop allObjects] sortedResultsUsingProperty:@"name" ascending:YES];
    
    disctinctStops = [ESStop filterUniqueNameFromSet:stops];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
}

-(void)viewDidLayoutSubviews
{
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        [self setUpSearchViewController];
    });
}


-(void)setUpSearchViewController
{
    stopsSearchController = [[ESCustomSearchController alloc] initWithSearchResultsController:nil
                                                                                            searchBarFrame:CGRectMake(0.0, 0.0, _tableView.frame.size.width, 60.0)
                                                                                             searchBarFont:[UIFont fontWithName:@"MavenProLight300-Regular" size:22.0]
                                                                                        searchBarTextColor:[UIColor whiteColor]
                                                                                        searchBarTintColor:[UIColor redColor]];
    
    
    [stopsSearchController.customSearchBar setShowsCancelButton:NO animated:NO];
    
    stopsSearchController.customDelegate = self;
    
    
    [_hearderView addSubview:stopsSearchController.customSearchBar];
}

# pragma mark - UITableViewDelegate & UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (shouldShowSearchResults) {
        return [filteredStops count];
    }
    else {
        return [disctinctStops count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"kCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"MavenProLight300-Regular" size:18.0];
    
    if (shouldShowSearchResults) {
        cell.textLabel.text = ((ESStop*)filteredStops[indexPath.item]).name;
    }
    else {
        cell.textLabel.text = ((ESStop*)disctinctStops[indexPath.item]).name;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueToBusResult" sender:indexPath];
}

# pragma mark - ESCustomSearchControllerDelegate


- (void)updateFilteredContentForProductName:(NSString *)productName
{
    if ((productName == nil) || [productName length] == 0) {
        [filteredStops removeAllObjects];
        for (RLMObject *object in disctinctStops) {
            [filteredStops addObject:object];
        }
        
        return;
    }
    
    
    [filteredStops removeAllObjects];
    
    for (ESStop* stop in disctinctStops) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange productNameRange = NSMakeRange(0, stop.name.length);
        NSRange foundRange = [stop.name rangeOfString:productName options:searchOptions range:productNameRange];
        if (foundRange.length > 0) {
            [filteredStops addObject:stop];
        }
    }
}

-(void)didStartSearching
{
    [stopsSearchController.customSearchBar setShowsCancelButton:YES animated:YES];
    [_tableView reloadData];
}

-(void)didTapOnSearchButton
{
    shouldShowSearchResults = YES;
    [stopsSearchController.customSearchBar setShowsCancelButton:NO animated:YES];
    [_tableView reloadData];
}

-(void)didTapOnCancelButton
{
    shouldShowSearchResults = NO;
    [stopsSearchController.customSearchBar setShowsCancelButton:NO animated:YES];
    [_tableView reloadData];
    
}

-(void)didChangeSearchText:(NSString*)searchText
{
    if ([searchText length] > 0) {
        shouldShowSearchResults = YES;
    }
    [self updateFilteredContentForProductName:searchText];
    
    [_tableView reloadData];
}

# pragma mark - Navigation


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ESDisplayBusResultViewController *vc = [segue destinationViewController];
    
    if ([vc isKindOfClass:[ESDisplayBusResultViewController class]] && [segue.identifier isEqualToString:@"segueToBusResult"]) {
        if (shouldShowSearchResults) {
            vc.busStops = [stops objectsWhere:[NSString stringWithFormat:@"name = '%@'", ((ESStop*)filteredStops[((NSIndexPath*)sender).item]).name]];
            vc.distinctStops = [NSMutableArray arrayWithObject:filteredStops[((NSIndexPath*)sender).item]];
            vc.title = ((ESStop*)filteredStops[((NSIndexPath*)sender).item]).name;
        }
        else {
            vc.busStops = [stops objectsWhere:[NSString stringWithFormat:@"name = '%@'", ((ESStop*)disctinctStops[((NSIndexPath*)sender).item]).name]];
            vc.distinctStops = [NSMutableArray arrayWithObject:disctinctStops[((NSIndexPath*)sender).item]];
            vc.title = ((ESStop*)disctinctStops[((NSIndexPath*)sender).item]).name;
        }
        
        shouldShowSearchResults = NO;
        [stopsSearchController.customSearchBar resignFirstResponder];
        stopsSearchController.customSearchBar.text = @"";
        [stopsSearchController.customSearchBar setShowsCancelButton:NO animated:YES];

        [filteredStops removeAllObjects];
        [_tableView reloadData];
    }
}

# pragma mark - ESLocationManager

- (IBAction)getLocationButtonTouched:(id)sender
{
    [locationManager updateLocation];
}

- (void)locationManager:(ESLocationManager *)manager didUpdateLatitude:(double)latitude andLongitude:(double)longitude
{
    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    //CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:48.0974422088 longitude:-1.6895658422];
    
    [filteredStops removeAllObjects];
    
    for (ESStop* stop in disctinctStops) {
        
        CLLocation *stopLocation = [[CLLocation alloc]initWithLatitude:stop.latitude longitude:stop.longitude];

        CLLocationDistance dist = [userLocation distanceFromLocation:stopLocation];

        if (dist <= 500) {
            [filteredStops addObject:stop];
        }
    }
    
    if ([filteredStops count] > 0) {
        shouldShowSearchResults = YES;
    }
    else {
        shouldShowSearchResults = NO;
        [SVProgressHUD setFont:[UIFont fontWithName:@"MavenProLight300-Regular" size:16]];
        [SVProgressHUD showErrorWithStatus:@"Aucun arrêt du bus\nà moins de 500 mètres"  maskType:SVProgressHUDMaskTypeGradient];
    }
    
    [_tableView reloadData];

}

@end
