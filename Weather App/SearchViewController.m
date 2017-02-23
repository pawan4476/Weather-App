//
//  SearchViewController.m
//  Weather App
//
//  Created by Nagam Pawan on 10/17/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import "SearchViewController.h"
#import "TableViewCell.h"
#import "ViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    self.listArray = [[NSMutableArray alloc]init];
    self.results = [[NSMutableArray alloc]init];
    self.urlString = [[NSString alloc]init];
    
}

-(void) callAPI: (NSString *)location{
    
    self.urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&location=15.3173,75.7139&radius=1000&key=AIzaSyBU10QM4h0d43h72beldCt94jn15xE9Mk0", location];
    [_dataTask suspend];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    self.dataTask = [session dataTaskWithURL:[NSURL URLWithString:_urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            
        self.json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.results = [self.json valueForKey:@"predictions"];
            NSLog(@"All the data is %@", _results);
            [_listArray removeAllObjects];
            if (_results != nil) {
                
                for (NSDictionary *search in _results) {
                    
                    NSRange range = [[search valueForKey:@"description"] rangeOfString:location];
                    if (range.location != NSNotFound) {
                        
                        [_listArray addObject:search];
                        
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];

                });
            }
        }
    }];
    
    [self.dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        
        [self.listArray removeAllObjects];
        NSLog(@"data is : %@", _listArray);
        
    }
    
    else{
        
        [self callAPI:searchText];
        
    }

    [self.view addSubview:searchBar];
    [self.tableView reloadData];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath] ;
    
    NSDictionary *obj = [_listArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    cell.textLabel.textColor = [UIColor redColor];
        
    cell.textLabel.text = [obj valueForKey:@"description"];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *obj = [_listArray objectAtIndex:indexPath.row];
    [_delegate searchedText:[obj valueForKey:@"description"]];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
