//
//  UIImageView+mapView.m
//  Linkdood
//
//  Created by yue on 6/23/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "UIImage+mapView.h"

@implementation UIImage(mapView)

+(UIImage *)shotCoordinate:(CLLocationCoordinate2D)coordinate withSize:(CGSize)size{
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.center = coordinate;
    region.span = span;
    options.region = region;
    options.size = size;
    options.scale = [[UIScreen mainScreen] scale];
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    
    // Initialize the semaphore to 0 because there are no resources yet.
    dispatch_semaphore_t snapshotSem = dispatch_semaphore_create(0);
    
    // Get a global queue (it doesn't matter which one).
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Create variables to hold return values. Use the __block modifier because these variables will be modified inside a block.
    __block MKMapSnapshot *mapSnapshot = nil;
    __block NSError *error = nil;
    
    // Start the asynchronous snapshot-creation task.
    [snapshotter startWithQueue:queue
              completionHandler:^(MKMapSnapshot *snapshot, NSError *e) {
                  mapSnapshot = snapshot;
                  error = e;
                  // The dispatch_semaphore_signal function tells the semaphore that the async task is finished, which unblocks the main thread.
                  dispatch_semaphore_signal(snapshotSem);
              }];
    
    // On the main thread, use dispatch_semaphore_wait to wait for the snapshot task to complete.
    dispatch_semaphore_wait(snapshotSem, DISPATCH_TIME_FOREVER);
    
    if (error) { // Handle error. }
        
        // Get the image from the newly created snapshot.
        //UIImage *image = mapSnapshot.image;
        // Optionally, draw annotations on the image before displaying it.
    }
    UIImage *profileImage = mapSnapshot.image;
    UIImage *badge = [UIImage imageNamed:@"pin"];
    
    UIGraphicsBeginImageContextWithOptions(profileImage.size, NO, 0.0f);
    [profileImage drawInRect:CGRectMake(0, 0, profileImage.size.width, profileImage.size.height)];
    [badge drawInRect:CGRectMake(profileImage.size.width / 2, profileImage.size.height / 3, badge.size.width, badge.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
