//
//  ViewController.h
//  Weather App
//
//  Created by Nagam Pawan on 10/8/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>{
    
    Reachability *reachability;
    
}

@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionLabel;
@property (strong, nonatomic) IBOutlet UILabel *popLabel;
@property (strong, nonatomic) IBOutlet UILabel *precipitationLabel;
@property (strong, nonatomic) IBOutlet UILabel *snowLabel;
@property (strong, nonatomic) IBOutlet UILabel *windLabel;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;

@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSMutableArray *countryArray;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) NSMutableArray *tempArray;
@property (strong, nonatomic) NSMutableArray *tempArray1;
@property (strong, nonatomic) NSMutableArray *conditionsArray;
@property (strong, nonatomic) NSMutableArray *conditionsArray1;
@property (strong, nonatomic) NSMutableArray *popArray;
@property (strong, nonatomic) NSMutableArray *precipitationArray;
@property (strong, nonatomic) NSMutableArray *snowArray;
@property (strong, nonatomic) NSMutableArray *windArray;
@property (strong, nonatomic) NSMutableArray *windArray1;
@property (strong, nonatomic) NSMutableArray *windDirectionArray;
@property (strong, nonatomic) NSMutableArray *windDirectionArray1;
@property (strong, nonatomic) NSMutableArray *humidityArray;
@property (strong, nonatomic) NSMutableArray *humidityArray1;
@property (strong, nonatomic) NSDictionary *json;
@property (strong, nonatomic) NSDictionary *dataArray;
@property (strong, nonatomic) NSDictionary *dataArray1;
@property (strong, nonatomic) NSDictionary *dataArray2;
@property (strong, nonatomic) NSMutableArray *dayArray;
@property (strong, nonatomic) NSMutableArray *monthArray;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (strong, nonatomic) NSMutableArray *dayFullArray;
@property (strong, nonatomic) NSMutableArray *monthNameArray;
@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSString *cityString;
@property (strong, nonatomic) NSMutableArray *places;

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *day1Label;
@property (strong, nonatomic) IBOutlet UILabel *day2Label;
@property (strong, nonatomic) IBOutlet UILabel *day3Label;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *backdroundImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)cityPrev:(id)sender;
- (IBAction)cityNext:(id)sender;
- (IBAction)datePrev:(id)sender;
- (IBAction)dateNext:(id)sender;

- (IBAction)dayIButton:(id)sender;
- (IBAction)day2Button:(id)sender;
- (IBAction)day3Button:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;

@property (nonatomic) NSInteger index;


@end

