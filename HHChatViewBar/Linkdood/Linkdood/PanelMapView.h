//
//  PanelMapView.h
//  Linkdood
//
//  Created by yue on 6/23/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@protocol PanelMapViewDelegate <NSObject>

@required
- (void)locationButtonPressed:(id)sender;
@end


typedef void(^goBackLocation)(double latitude,double longitude,NSString *address);

@interface PanelMapView : UIView<MKMapViewDelegate,CLLocationManagerDelegate>

/*!
 @property  latitude
 @descript  位置经度
 */
@property (assign,nonatomic) double latitude;

/*!
 @property  longitude
 @descript  位置纬度
 */
@property (assign,nonatomic) double longitude;

/*!
 @property  address
 @descript  位置对应的地名
 */
@property (strong,nonatomic) NSString *address;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (copy,nonatomic) goBackLocation locationBlock;

@property (strong,nonatomic) id<PanelMapViewDelegate> delegate;

- (void)getUserLocation:(CLLocation*)location;

@end
