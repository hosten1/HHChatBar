//
//  PanelMapView.m
//  Linkdood
//
//  Created by yue on 6/23/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "PanelMapView.h"
#import "JZLocationConverter.h"

@interface PanelMapView (){
    MKCoordinateSpan theSpan;
    BOOL isLoaded;
}

@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation PanelMapView

-(void)awakeFromNib{
    [super awakeFromNib];
    _address = @"";
    theSpan.latitudeDelta=0.01;
    theSpan.longitudeDelta=0.01;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 50.0f;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [_locationManager requestWhenInUseAuthorization];
    }
    if(![CLLocationManager locationServicesEnabled]){
        NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
    }
    [_locationManager startUpdatingLocation];

    CLLocationCoordinate2D coordinate = [JZLocationConverter wgs84ToGcj02:_locationManager.location.coordinate];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self getUserLocation:location];
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.locationManager.delegate = self;
    isLoaded = YES;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(isLoaded){
        [self getUserLocation:userLocation.location];
        isLoaded = NO;
    }
}

//获取当前位置
- (void)getUserLocation:(CLLocation*)location
{
    MKCoordinateRegion theRegion;
    theRegion.center=location.coordinate;
    theRegion.span=theSpan;
    [_mapView setRegion:theRegion];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    _latitude = mapView.centerCoordinate.latitude;
    _longitude = mapView.centerCoordinate.longitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_latitude, _longitude);
    coordinate = [JZLocationConverter gcj02ToWgs84:coordinate];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    if(isLoaded){
        theSpan = _mapView.region.span;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             NSString *city = placemark.locality;
             if (!city) {
                 // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             _address = [NSString stringWithFormat:@"%@%@%@%@",city,placemark.subLocality,placemark.thoroughfare?placemark.thoroughfare:@"",placemark.subThoroughfare?placemark.subThoroughfare:@""];
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

- (IBAction)getMyselfLocPressed:(id)sender {
    isLoaded = YES;
    [self getUserLocation:_mapView.userLocation.location];
}

- (IBAction)sendLocPressed:(id)sender {
    [self.delegate locationButtonPressed:self];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.locationBlock) {
            self.locationBlock(_latitude,_longitude,_address);
        }
    });
}

@end
