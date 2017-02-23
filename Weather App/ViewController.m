//
//  ViewController.m
//  Weather App
//
//  Created by Nagam Pawan on 10/8/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"

@interface ViewController ()<SearchViewControllerDelegate>

@end

@implementation ViewController{
    NSString *urlString;
    NSString *placesUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        NSLog(@"No network");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error in Loading..." message:@"Network not found" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else if (remoteHostStatus == ReachableViaWiFi){
        NSLog(@"on the wifi");
    }
    else if (remoteHostStatus == ReachableViaWWAN){
        NSLog(@"on the mobiledata");
    }
    
    self.cityArray = [[NSMutableArray alloc]init];
    self.dateArray = [[NSMutableArray alloc]init];
    self.tempArray = [[NSMutableArray alloc]init];
    self.tempArray1 = [[NSMutableArray alloc]init];
    self.conditionsArray = [[NSMutableArray alloc]init];
    self.conditionsArray1 = [[NSMutableArray alloc]init];
    self.popArray = [[NSMutableArray alloc]init];
    self.precipitationArray = [[NSMutableArray alloc]init];
    self.snowArray = [[NSMutableArray alloc]init];
    self.windArray = [[ NSMutableArray alloc]init];
    self.windDirectionArray = [[NSMutableArray alloc]init];
    self.windArray1 = [[ NSMutableArray alloc]init];
    self.windDirectionArray1 = [[NSMutableArray alloc]init];
    self.humidityArray = [[NSMutableArray alloc]init];
    self.humidityArray1 = [[NSMutableArray alloc]init];
    self.json = [[NSDictionary alloc]init];
    self.dataArray = [[NSDictionary alloc]init];
    self.dayArray = [[NSMutableArray alloc]init];
    self.monthArray = [[NSMutableArray alloc]init];
    self.imagesArray = [[NSMutableArray alloc]init];
    self.imageArray1 = [[NSMutableArray alloc]init];
    self.dayFullArray = [[NSMutableArray alloc]init];
    self.monthNameArray = [[NSMutableArray alloc]init];
    self.yearArray = [[NSMutableArray alloc]init];
    self.dataArray1 = [[NSDictionary alloc]init];
    self.dataArray2 = [[NSDictionary alloc]init];
    self.countryArray = [[NSMutableArray alloc]init];
    self.places = [[NSMutableArray alloc]initWithCapacity:10];
    self.index = 0;
    
    self.locationManager = [[CLLocationManager alloc]init];
    CLLocation *location = [self.locationManager location];
    self.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    CLLocationCoordinate2D cordinate;
    cordinate.latitude = self.latitude.doubleValue;
    cordinate.longitude = self.longitude.doubleValue;
    NSString *string = [NSString stringWithFormat:@"%f,%f", cordinate.latitude, cordinate.longitude];
    NSLog(@"location string is %@", string);

    NSLog(@"location is : %@ and longitude is %@", self.latitude, self.longitude);
    urlString = [[NSString alloc]init];
    placesUrl = [[NSString alloc]init];
    [self getsession:@"http://api.wunderground.com/api/8492f44733b86cc1/forecast/conditions/geolookup/q/autoip.json"];
   
    self.backdroundImageView.image = [UIImage imageNamed:@"nature-wallpaper-high-definition.jpg"];
    [self startLocationUpdate];
   
}

-(void)startLocationUpdate{
    
    if (self.locationManager == nil) {
    
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        
    }
    
    else{
        
        nil;
        
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    
    else{
        
        nil;
        
    }
    
    self.locationManager.distanceFilter = 100;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
}

-(void)handleNetworkChange: (NSNotification *)notice{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        NSLog(@"No network");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error in Loading..." message:@"Network not found" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else if (remoteHostStatus == ReachableViaWiFi){
        NSLog(@"on the wifi");
    }
    else if (remoteHostStatus == ReachableViaWWAN){
        NSLog(@"on the mobiledata");
    }

}
-(void)getsession : (NSString *)jsonUrl{
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:jsonUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (data != nil) {
    
        self.json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"All the data is :%@", self.json);
            [self.activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
            
            if (_json != nil && [self.json valueForKey:@"forecast"] != nil) {
        
        self.dataArray =[[[_json valueForKey:@"forecast"] valueForKey:@"simpleforecast"] valueForKey:@"forecastday"];
        
        self.dataArray1 = [_json valueForKey:@"location"];
            
        self.dataArray2 = [_json valueForKey:@"current_observation"];
                
        self.tempArray1 = [_dataArray2 valueForKey:@"temp_c"];
        NSLog(@"present temp is : %@", _tempArray1);
        
        self.tempArray = [[_dataArray valueForKey:@"high"] valueForKey:@"celsius"];
        NSLog(@"Temperature is : %@", _tempArray);
            
        self.popArray = [_dataArray valueForKey:@"pop"];
        NSLog(@"pop is : %@", _popArray);
        
        self.humidityArray = [_dataArray valueForKey:@"avehumidity"];
        NSLog(@"average humidity is : %@", _humidityArray);
        self.humidityArray1 = [_dataArray2 valueForKey:@"relative_humidity"];
        
        self.conditionsArray = [_dataArray valueForKey:@"conditions"];
        NSLog(@"Conditions are : %@", _conditionsArray);
                
        self.conditionsArray1 = [_dataArray2 valueForKey:@"weather"];
        NSLog(@"Weather is : %@", _conditionsArray1);
        
        self.windArray = [[_dataArray valueForKey:@"avewind"] valueForKey:@"kph"];
        NSLog(@"wind is : %@", _windArray);
        self.windDirectionArray = [[_dataArray valueForKey:@"avewind"] valueForKey:@"dir"];
        NSLog(@"wind direction is : %@", _windDirectionArray);
                
        self.windArray1 = [_dataArray2 valueForKey:@"wind_kph"];
        self.windDirectionArray1 = [_dataArray2 valueForKey:@"wind_dir"];
        NSLog(@"Wind from %@ direction at %@ kms", _windDirectionArray, _windArray1);
                
        self.precipitationArray = [[_dataArray valueForKey:@"qpf_allday"] valueForKey:@"mm"];
        NSLog(@"Qpf is : %@", _precipitationArray);
        
        self.snowArray = [[_dataArray valueForKey:@"snow_allday"] valueForKey:@"cm"];
        NSLog(@"Snow is : %@", _snowArray);
        
        self.dateArray = [[_dataArray valueForKey:@"date"] valueForKey:@"day"];
        NSLog(@"Date is : %@", _dataArray);
        self.dayArray = [[_dataArray valueForKey:@"date"] valueForKey:@"weekday_short"];
        NSLog(@"Day is : %@", _dayArray);
        self.monthArray = [[_dataArray valueForKey:@"date"] valueForKey:@"month"];
        NSLog(@"Month is : %@", _monthArray);
        self.dayFullArray = [[_dataArray valueForKey:@"date"] valueForKey:@"weekday"];
        NSLog(@"Weekday is : %@", _dayFullArray);
        self.monthNameArray = [[_dataArray valueForKey:@"date"] valueForKey:@"monthname"];
        NSLog(@"Month name is : %@", _monthNameArray);
        self.yearArray = [[_dataArray valueForKey:@"date"] valueForKey:@"year"];
        NSLog(@"Year is : %@", _yearArray);
        
        self.imagesArray = [_dataArray valueForKey:@"icon_url"];
        NSLog(@"Images are : %@", _imagesArray);
		
        self.imageArray1 = [_dataArray2 valueForKey:@"icon_url"];
        NSLog(@"images are : %@", _imageArray1);
        
        self.cityArray = [_dataArray1 valueForKey:@"city"];
        self.countryArray = [_dataArray1 valueForKey:@"country_name"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *tempTemperature1 = [_tempArray objectAtIndex:1];
            NSArray *tempTemperature2 = [_tempArray objectAtIndex:2];
            self.tempLabel.text = [NSString stringWithFormat:@"+%@°C", _tempArray1];
            
            NSArray *tempPop = [_popArray objectAtIndex:0];
            self.popLabel.text = [NSString stringWithFormat:@"%@", tempPop];
            
        self.humidityLabel.text = [NSString stringWithFormat:@"%@", _humidityArray1];
            
        self.conditionLabel.text = [NSString stringWithFormat:@"%@", _conditionsArray1];
            
        self.windLabel.text = [NSString stringWithFormat:@"%@ kph, %@", _windArray1, _windDirectionArray1];
            
            NSArray *tempPrecipitation = [_precipitationArray objectAtIndex:0];
            self.precipitationLabel.text = [NSString stringWithFormat:@"%@ mm", tempPrecipitation];
            
            NSArray *tempSnow = [_snowArray objectAtIndex:0];
            self.snowLabel.text = [NSString stringWithFormat:@"%@ cm", tempSnow];
            
            NSArray *tempDate = [_dateArray objectAtIndex:0];
            NSArray *tempMonth = [_monthArray objectAtIndex:0];
            NSArray *tempYear = [_yearArray objectAtIndex:0];
            self.day1Label.text = [NSString stringWithFormat:@"%@/%@/%@", tempDate, tempMonth, tempYear];
            
            NSArray *tempDate2 = [_dateArray objectAtIndex:1];
            NSArray *tempMonth2 = [_monthArray objectAtIndex:1];
            NSArray *tempYear2 = [_yearArray objectAtIndex:1];
            self.day2Label.text = [NSString stringWithFormat:@"%@/%@/%@", tempDate2, tempMonth2, tempYear2];
            
            NSArray *tempDate3 = [_dateArray objectAtIndex:2];
            NSArray *tempMonth3 = [_monthArray objectAtIndex:2];
            NSArray *tempYear3 = [_yearArray objectAtIndex:2];
            self.day3Label.text = [NSString stringWithFormat:@"%@/%@/%@", tempDate3, tempMonth3, tempYear3];
            
            NSArray *tempWeek = [_dayFullArray objectAtIndex:0];
            NSArray *tempMonthName = [_monthNameArray objectAtIndex:0];
            self.dateLabel.text = [NSString stringWithFormat:@"%@ %@, %@", tempDate, tempMonthName, tempWeek];
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _imageArray1]]];
            NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_imagesArray objectAtIndex:1]]];
            NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_imagesArray objectAtIndex:2]]];
            self.imageView.image = [UIImage imageWithData:data];
            
            [self.button1 setTitle:[NSString stringWithFormat:@"+%@°C", _tempArray1] forState:UIControlStateNormal];
            [self.button1 setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            [self.button2 setTitle:[NSString stringWithFormat:@"+%@°C", tempTemperature1] forState:UIControlStateNormal];
            [self.button2 setImage:[UIImage imageWithData:data1] forState:UIControlStateNormal];
            [self.button3 setTitle:[NSString stringWithFormat:@"+%@°C", tempTemperature2] forState:UIControlStateNormal];
            [self.button3 setImage:[UIImage imageWithData:data2] forState:UIControlStateNormal];
            
            self.cityLabel.text = [NSString stringWithFormat:@"%@ , %@", _cityArray, _countryArray];
        
        });
            }
            
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error in Loading..." message:@"data not found" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    self.cityLabel.text = [NSString stringWithFormat:@"%@ , %@", _cityArray, _countryArray];
                    
                }];
                    
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                    
                });
            }
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error in Loading..." message:@"data not found" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
       
    }];
    
    [dataTask resume];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)cityPrev:(id)sender {
    
    if (_places.count == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong Input" message:@"Please search first" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else{
        
    if (self.index == 0) {
        _index = _places.count;
    }
        
    _index--;
    NSString *url = @"http://api.wunderground.com/api/8492f44733b86cc1/forecast/conditions/geolookup/q/autoip/%@.json";
    placesUrl = [url stringByReplacingOccurrencesOfString:@"%@" withString:[_places objectAtIndex:_index]];
    NSString *url1 = [placesUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self getsession:url1];
    NSLog(@"Places url is : %@", url1);

    }
}

- (IBAction)cityNext:(id)sender {
    
    if (_places.count == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong Input" message:@"Please search first" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else {if (self.index == ([_places count])) {
        
        _index = 0;
        
    }
        
    NSString *url = @"http://api.wunderground.com/api/8492f44733b86cc1/forecast/conditions/geolookup/q/autoip/%@.json";
    placesUrl = [url stringByReplacingOccurrencesOfString:@"%@" withString:[_places objectAtIndex:_index]];
    NSString *url1 = [placesUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self getsession:url1];
    NSLog(@"Places url is : %@", url1);
    //self.cityLabel.text = [NSString stringWithFormat:@"%@", [_places objectAtIndex:_index]];
    _index++;
        
    }
}

- (IBAction)datePrev:(id)sender {
    
    if (self.dateArray.count == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong Input" message:@"Please connect to the internet first" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else{
        
        if (self.index == 1) {
        _index = _dateArray.count;

    }
        
    _index--;
        
        if ([self.tempArray count] > 0 && [self.tempArray count] > _index) {
            
    NSArray *tempTemperature = [_tempArray objectAtIndex:_index];
    self.tempLabel.text = [NSString stringWithFormat:@"+%@°C", tempTemperature];
            
        }
    
        if ([self.popArray count] > 0 && [self.popArray count] > _index) {
            
    NSArray *tempPop = [_popArray objectAtIndex:_index];
    self.popLabel.text = [NSString stringWithFormat:@"%@", tempPop];
            
        }
    
        if ([self.windArray count] > 0 && [self.windArray count] > _index) {
            
    NSArray *tempWind = [_windArray objectAtIndex:_index];
    NSArray *tempDirec = [_windDirectionArray objectAtIndex:_index];
    self.windLabel.text = [NSString stringWithFormat:@"%@ kph, %@", tempWind, tempDirec];
            
        }
    
        if ([self.conditionsArray count] > 0 && [self.conditionsArray count] > _index) {
            
    NSArray *tempConditions = [_conditionsArray objectAtIndex:_index];
    self.conditionLabel.text = [NSString stringWithFormat:@"%@", tempConditions];
            
        }
        
        if ([self.humidityArray count] > 0 && [self.humidityArray count] > _index) {
    
    NSArray *tempHumidity = [_humidityArray objectAtIndex:_index];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%%", tempHumidity];
            
        }
        
        if ([self.precipitationArray count] > 0 && [self.precipitationArray count] > _index) {
    
    NSArray *tempPrecipitation = [_precipitationArray objectAtIndex:_index];
    self.precipitationLabel.text = [NSString stringWithFormat:@"%@ mm", tempPrecipitation];
            
        }
        
        if ([self.snowArray count] > 0 && [self.snowArray count] > _index) {
    
    NSArray *tempSnow = [_snowArray objectAtIndex:_index];
    self.snowLabel.text = [NSString stringWithFormat:@"%@ cm", tempSnow];
            
        }
        
        if ([self.imagesArray count] > 0 && [self.imagesArray count] > _index) {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_imagesArray objectAtIndex:_index]]];
    self.imageView.image = [UIImage imageWithData:data];
            
        }
        
        if ([self.dateArray count] > 0 && [self.dateArray count] > _index) {
    
    NSArray *tempDate = [_dateArray objectAtIndex:_index];
    NSArray *tempWeek = [_dayFullArray objectAtIndex:_index];
    NSArray *tempMonthName = [_monthNameArray objectAtIndex:_index];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@, %@", tempDate, tempMonthName, tempWeek];
            
        }
        
    }
}

- (IBAction)dateNext:(id)sender {
    
    if (self.dateArray.count == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong Input" message:@"Please connect to the internet first" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    else {
        
        if (self.index == ([_dateArray count])) {
        _index = 1;

    }
     
        if ([self.tempArray count] > 0 && [self.tempArray count] > _index) {
            
    NSArray *tempTemperature = [_tempArray objectAtIndex:_index];
    self.tempLabel.text = [NSString stringWithFormat:@"+%@°C", tempTemperature];
            
        }
        
        if ([self.popArray count] > 0 && [self.popArray count] > _index) {
    
    NSArray *tempPop = [_popArray objectAtIndex:_index];
    self.popLabel.text = [NSString stringWithFormat:@"%@", tempPop];
            
        }
        
        if ([self.windArray count] > 0 && [self.windArray count] > _index) {
    
    NSArray *tempWind = [_windArray objectAtIndex:_index];
    NSArray *tempDirec = [_windDirectionArray objectAtIndex:_index];
    self.windLabel.text = [NSString stringWithFormat:@"%@ kph, %@", tempWind, tempDirec];
            
        }
        
        if ([self.conditionsArray count] > 0 && [self.conditionsArray count] > _index) {
    
    NSArray *tempConditions = [_conditionsArray objectAtIndex:_index];
    self.conditionLabel.text = [NSString stringWithFormat:@"%@", tempConditions];
            
        }
        
        if ([self.humidityArray count] > 0 && [self.humidityArray count] > _index) {
    
    NSArray *tempHumidity = [_humidityArray objectAtIndex:_index];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%%", tempHumidity];
            
        }
        
        if ([self.precipitationArray count] > 0 && [self.precipitationArray count] > _index) {
    
    NSArray *tempPrecipitation = [_precipitationArray objectAtIndex:_index];
    self.precipitationLabel.text = [NSString stringWithFormat:@"%@ mm", tempPrecipitation];
            
        }
        
        if ([self.snowArray count] > 0 && [self.snowArray count] > _index) {
    
    NSArray *tempSnow = [_snowArray objectAtIndex:_index];
    self.snowLabel.text = [NSString stringWithFormat:@"%@ cm", tempSnow];
            
        }
        
        if ([self.imagesArray count] > 0 && [self.imagesArray count] > _index) {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_imagesArray objectAtIndex:_index]]];
    self.imageView.image = [UIImage imageWithData:data];
            
        }
        
        if ([self.dateArray count] > 0 && [self.dateArray count] > _index) {
    
    NSArray *tempDate = [_dateArray objectAtIndex:_index];
    NSArray *tempWeek = [_dayFullArray objectAtIndex:_index];
    NSArray *tempMonthName = [_monthNameArray objectAtIndex:_index];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@, %@", tempDate, tempMonthName, tempWeek];
            
        }
        
    _index++;
        
    }
}

- (IBAction)dayIButton:(id)sender {
    
    self.tempLabel.text = [NSString stringWithFormat:@"+%@°C", _tempArray1];
    
    NSArray *tempPop = [_popArray objectAtIndex:0];
    self.popLabel.text = [NSString stringWithFormat:@"%@", tempPop];
    
    self.windLabel.text = [NSString stringWithFormat:@"%@ kph, %@", _windArray1, _windDirectionArray1];
    
    self.conditionLabel.text = [NSString stringWithFormat:@"%@", _conditionsArray1];
    
    self.humidityLabel.text = [NSString stringWithFormat:@"%@", _humidityArray1];
    
    NSArray *tempPrecipitation = [_precipitationArray objectAtIndex:0];
    self.precipitationLabel.text = [NSString stringWithFormat:@"%@ mm", tempPrecipitation];
    
    NSArray *tempSnow = [_snowArray objectAtIndex:0];
    self.snowLabel.text = [NSString stringWithFormat:@"%@ cm", tempSnow];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _imageArray1]]];
    self.imageView.image = [UIImage imageWithData:data];
    
    NSArray *tempDate = [_dateArray objectAtIndex:0];
    NSArray *tempWeek = [_dayFullArray objectAtIndex:0];
    NSArray *tempMonthName = [_monthNameArray objectAtIndex:0];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@, %@", tempDate, tempMonthName, tempWeek];
    
}

- (IBAction)day2Button:(id)sender {
    
    NSArray *tempTemperature = [_tempArray objectAtIndex:1];
    self.tempLabel.text = [NSString stringWithFormat:@"+%@°C", tempTemperature];
    
    NSArray *tempPop = [_popArray objectAtIndex:1];
    self.popLabel.text = [NSString stringWithFormat:@"%@", tempPop];
    
    NSArray *tempWind = [_windArray objectAtIndex:1];
    NSArray *tempDirec = [_windDirectionArray objectAtIndex:1];
    self.windLabel.text = [NSString stringWithFormat:@"%@ kph, %@", tempWind, tempDirec];
    
    NSArray *tempConditions = [_conditionsArray objectAtIndex:1];
    self.conditionLabel.text = [NSString stringWithFormat:@"%@", tempConditions];
    
       NSArray *tempHumidity = [_humidityArray objectAtIndex:1];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%%", tempHumidity];
    
    NSArray *tempPrecipitation = [_precipitationArray objectAtIndex:1];
    self.precipitationLabel.text = [NSString stringWithFormat:@"%@ mm", tempPrecipitation];
    
    NSArray *tempSnow = [_snowArray objectAtIndex:1];
    self.snowLabel.text = [NSString stringWithFormat:@"%@ cm", tempSnow];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_imagesArray objectAtIndex:1]]];
    self.imageView.image = [UIImage imageWithData:data];
    
    NSArray *tempDate = [_dateArray objectAtIndex:1];
    NSArray *tempWeek = [_dayFullArray objectAtIndex:1];
    NSArray *tempMonthName = [_monthNameArray objectAtIndex:1];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@, %@", tempDate, tempMonthName, tempWeek];

}

- (IBAction)day3Button:(id)sender {
    
    NSArray *tempTemperature = [_tempArray objectAtIndex:2];
    self.tempLabel.text = [NSString stringWithFormat:@"+%@°C", tempTemperature];
    
    NSArray *tempPop = [_popArray objectAtIndex:2];
    self.popLabel.text = [NSString stringWithFormat:@"%@", tempPop];
    
    NSArray *tempWind = [_windArray objectAtIndex:2];
    NSArray *tempDirec = [_windDirectionArray objectAtIndex:2];
    self.windLabel.text = [NSString stringWithFormat:@"%@ kph, %@", tempWind, tempDirec];
    
    NSArray *tempConditions = [_conditionsArray objectAtIndex:2];
    self.conditionLabel.text = [NSString stringWithFormat:@"%@", tempConditions];
    
    NSArray *tempHumidity = [_humidityArray objectAtIndex:2];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%%", tempHumidity];
    
    NSArray *tempPrecipitation = [_precipitationArray objectAtIndex:2];
    self.precipitationLabel.text = [NSString stringWithFormat:@"%@ mm", tempPrecipitation];
    
    NSArray *tempSnow = [_snowArray objectAtIndex:2];
    self.snowLabel.text = [NSString stringWithFormat:@"%@ cm", tempSnow];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_imagesArray objectAtIndex:2]]];
    self.imageView.image = [UIImage imageWithData:data];
    
    NSArray *tempDate = [_dateArray objectAtIndex:2];
    NSArray *tempWeek = [_dayFullArray objectAtIndex:2];
    NSArray *tempMonthName = [_monthNameArray objectAtIndex:2];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@, %@", tempDate, tempMonthName, tempWeek];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"send"]) {
        
        SearchViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        
    }
}


-(void) searchedText:(NSString *)text{
    
    NSString *url = @"http://api.wunderground.com/api/8492f44733b86cc1/forecast/conditions/geolookup/q/%@.json";
    urlString = [url stringByReplacingOccurrencesOfString:@"%@" withString:text];
    NSString *url1 = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self getsession:url1];
    NSLog(@"appended url is : %@", url1);
    
    [self.places addObject:_cityArray];
    [self.places insertObject:text atIndex:1];
    NSLog(@"Places are : %@", _places);

   }

-(void)stopAnimating{
    
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    
}

@end
