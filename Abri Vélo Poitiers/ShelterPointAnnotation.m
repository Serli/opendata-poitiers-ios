//
//  ShelterPointAnnotation.m
//  Abri Vélo Poitiers
//
//  Created by Matthias Lamoureux on 05/06/2015.
//  Copyright (c) 2015 serli. All rights reserved.
//

#import "ShelterPointAnnotation.h"

@implementation ShelterPointAnnotation

/**
 * @brief Modifieur de la propriété shelterData
 *
 * @param aShelterData Nouvelles données sur l'abri
 */
- (void)setShelterData:(NSDictionary *)aShelterData {
    _shelterData = aShelterData;
    
    NSLog(@"%@",aShelterData);
    
    NSArray * coordinates = aShelterData[@"location"];
    CLLocationDegrees lat = [coordinates[1] doubleValue];
    CLLocationDegrees lon = [coordinates[0] doubleValue];
    
    self.coordinate = CLLocationCoordinate2DMake(lat, lon);
    
    id type = aShelterData[@"type"];
    if (![type isKindOfClass:[NSString class]]) {
        type = @"Type de stationnement inconnu";
    }
    
    id places = aShelterData[@"capacity"];
    NSString * capacity = [places isKindOfClass:[NSNumber class]]?[NSString stringWithFormat:@"%@ places",places]:@"Capacité inconnue";

    self.title = [NSString stringWithFormat:@"%@ - %@",type,capacity];
    id address = aShelterData[@"address"];
    if ([address isKindOfClass:[NSString class]]) {
        NSArray * addressComponents = [address componentsSeparatedByString:@","];
        self.subtitle = addressComponents[0];
    }
}

- (BOOL) isShelter {
    return [self.shelterData[@"type"] isEqual:@"Site abri vélo"];
}

@end
