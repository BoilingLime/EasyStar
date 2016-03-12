//
//  ESCustomSearchController.m
//  Easy Star
//
//  Created by Longueville Xavier on 10/03/16.
//  Copyright © 2016 Longueville Xavier. All rights reserved.
//

#import "ESCustomSearchController.h"

@interface ESCustomSearchController () <UISearchBarDelegate>

@end

@implementation ESCustomSearchController

@synthesize customSearchBar = _customSearchBar;


- (instancetype)initWithSearchResultsController:(UIViewController*)searchResultController   searchBarFrame:(CGRect)frame
                                  searchBarFont:(UIFont *)searchBarFont
                             searchBarTextColor:(UIColor *)searchBarTextColor
                             searchBarTintColor:(UIColor *)searchBarTintColor
{
    self = [super init];
    if (self) {
        [self configureSearchBarWithFrame:frame font:searchBarFont textColor:searchBarTextColor bgColor:searchBarTintColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureSearchBarWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor bgColor:(UIColor*)bgColor {
    _customSearchBar = [[ESCustomSearchBar alloc] initWithFrame:frame font:font fontColor:textColor];
    
    [_customSearchBar setImage:[UIImage imageNamed:@"search_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    _customSearchBar.delegate = self;
    _customSearchBar.barTintColor = bgColor;
    _customSearchBar.tintColor = textColor;
    _customSearchBar.showsBookmarkButton = NO;
    _customSearchBar.showsCancelButton = YES;
    _customSearchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_customSearchBar setBackgroundImage:[UIImage new]];

}

-(void)searchBarTextDidBeginEditing:(UISearchBar*)seatchBar {
    [self.customDelegate didStartSearching];
}


-(void)searchBarCancelButtonClicked:(UISearchBar*) searchBar {
    [_customSearchBar resignFirstResponder];
    _customSearchBar.text = @"";
    [self.customDelegate didTapOnCancelButton];
}

-(void)searchBarSearchButtonClicked:(UISearchBar*) searchBar {
    [_customSearchBar resignFirstResponder];
    [self.customDelegate didTapOnSearchButton];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.customDelegate didChangeSearchText:searchText];
}
@end
