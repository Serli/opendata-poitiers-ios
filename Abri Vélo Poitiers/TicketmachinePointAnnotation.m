//
//  TimestampPointAnnotation.m
//  TestApp
//
//  Created by Serli on 16/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import "TicketmachinePointAnnotation.h"

@implementation TicketmachinePointAnnotation

- (void)setTicketmachineData:(NSDictionary *)ticketmachineData {
    
    _ticketmachineData = ticketmachineData;
    
    //NSLog(@"%@",timestampData);
    
    NSArray * coordinates = self.ticketmachineData[@"location"];
    self.coordinate = CLLocationCoordinate2DMake([coordinates[1] doubleValue], [coordinates[0] doubleValue]);
    
    NSString * type = @"Horodateur";
    NSString * num = self.ticketmachineData[@"numberTicketmachine"];
    self.title = [NSString stringWithFormat:@"%@ n° %@",type,num];
    
    
    
}

@end
