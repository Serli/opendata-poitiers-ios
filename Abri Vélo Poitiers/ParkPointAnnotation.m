//
//  ParkPointAnnotation.m
//  TestApp
//
//  Created by Serli on 17/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import "ParkPointAnnotation.h"

@implementation ParkPointAnnotation

- (void)setParkData:(NSDictionary *)parkData {
    
    _parkData = parkData;
    NSArray * coordinates = self.parkData[@"location"];
    self.coordinate = CLLocationCoordinate2DMake([coordinates[1] doubleValue], [coordinates[0] doubleValue]);
    
    NSString * type = @"Place GIG-GIC";
    self.title = [NSString stringWithFormat:@"%@",type];
    
}

@end
