//
//  ParkPointAnnotation.h
//  TestApp
//
//  Created by Serli on 17/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ParkPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSDictionary * parkData;

@end
