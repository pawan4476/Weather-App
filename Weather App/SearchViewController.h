//
//  SearchViewController.h
//  Weather App
//
//  Created by Nagam Pawan on 10/17/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate <NSObject>

-(void) searchedText:(NSString *)text;

@end

@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) id<SearchViewControllerDelegate> delegate;

@property (strong, nonatomic) NSDictionary *json;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSString *urlString;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
