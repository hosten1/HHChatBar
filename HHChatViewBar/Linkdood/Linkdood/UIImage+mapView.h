//
//  UIImageView+mapView.h
//  Linkdood
//
//  Created by yue on 6/23/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mapView)

+(UIImage *)shotCoordinate:(CLLocationCoordinate2D)coordinate withSize:(CGSize)size;

@end
