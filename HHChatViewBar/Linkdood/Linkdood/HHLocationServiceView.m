//
//  HHLocationServiceView.m
//  Linkdood
//
//  Created by VRV2 on 16/5/26.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "HHLocationServiceView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HHLocationServiceView ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;

@end
@implementation HHLocationServiceView
-(MKMapView *)mapView{
    if (!_mapView) {
        _mapView =[[MKMapView alloc]initWithFrame:self.bounds];
        _mapView.zoomEnabled = YES;
        _mapView.showsUserLocation = YES;
        _mapView.scrollEnabled = YES;
       
    }
    return _mapView;
}
-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        //kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 50.0f;
        if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
        {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}
-(instancetype)initWithFrame:(CGRect)frame inView:(UIView*)containView{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (containView) {
            [containView addSubview:self];
        }
        
        [self addSubview:self.mapView];
        //请求成功后设置代理
        self.mapView.delegate = self;
        self.locationManager.delegate = self;
    }
    return self;
}
//获取当前位置
- (void)getUserLocation
{
  
    /**********开始获取定位信息*************/
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled ]) {
        
        NSLog(@"定位服务打开");
    }
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
        [self.locationManager requestWhenInUseAuthorization];
    }else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"授权成功");
        
        //更新位置
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"授权失败");
    }
    
    //设定显示范围
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.01;
    theSpan.longitudeDelta=0.01;
    //设置地图显示的中心及范围
    CLLocationCoordinate2D theCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    MKCoordinateRegion theRegion;
    theRegion.center=theCoordinate;
    theRegion.span=theSpan;
    [_mapView setRegion:theRegion];
    // 设置地图显示的类型及根据范围进行显示  安放大头针
    MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
    pinAnnotation.coordinate = theCoordinate;
    pinAnnotation.title = self.address;
    dispatch_sync(dispatch_get_main_queue(), ^{
//          NSLog(@">>>>>>>>>>>>>>>>>>>>>%@",[NSThread currentThread]);
        [_mapView addAnnotation:pinAnnotation];
    });
    
   
}

#pragma mark-CLLocationManagerDelegate  位置更新后的回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //停止位置更新
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *loc = [locations firstObject];
    CLLocationCoordinate2D theCoordinate;
    //位置更新后的经纬度
    theCoordinate.latitude = loc.coordinate.latitude;
    theCoordinate.longitude = loc.coordinate.longitude;
   
    self.location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak typeof(self) mySelf = self;
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *array, NSError *error)
     {
            if (array.count > 0)
             {
                 CLPlacemark *placemark = [array objectAtIndex:0];
                 // 将获得的所有信息显示到label上
                 // 获取城市
                 NSString *city = placemark.administrativeArea;
                 if (!city) {
                     // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                     city = placemark.administrativeArea;
                 }
                 NSString *locationStr = [NSString stringWithFormat:@"%@%@%@%@%@",city,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];
                 
                 if (mySelf.locationBlock) {
                       mySelf.locationBlock(theCoordinate.latitude,theCoordinate.longitude,locationStr);
                 }
               
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

// 每次添加大头针都会调用此方法  可以设置大头针的样式
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // 判断大头针位置是否在原点,如果是则不加大头针
    if([annotation isKindOfClass:[mapView.userLocation class]])
        return nil;
    static NSString *annotationName = @"annotation";
    MKPinAnnotationView *anView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationName];
    if(anView == nil)
    {
        anView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationName];
    }
    anView.animatesDrop = YES;
    //    // 显示详细信息
    anView.canShowCallout = YES;
    //    anView.leftCalloutAccessoryView   可以设置左视图
    //    anView.rightCalloutAccessoryView   可以设置右视图
    return anView;
}

//长按添加大头针事件
- (void)lpgrClick:(UILongPressGestureRecognizer *)lpgr
{
    // 判断只在长按的起始点下落大头针
    if(lpgr.state == UIGestureRecognizerStateBegan)
    {
        // 首先获取点
        CGPoint point = [lpgr locationInView:_mapView];
        // 将一个点转化为经纬度坐标
        CLLocationCoordinate2D center = [_mapView convertPoint:point toCoordinateFromView:_mapView];
        MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
        pinAnnotation.coordinate = center;
        pinAnnotation.title = @"长按";
        [_mapView addAnnotation:pinAnnotation];
    }
}

//计算两个位置之间的距离
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


@end
