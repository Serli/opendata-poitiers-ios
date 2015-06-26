//
//  ServicePointAnnotation.m
//  TestApp
//
//  Created by Serli on 18/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import "ServicePointAnnotation.h"

@implementation ServicePointAnnotation

- (void)setServiceData:(NSDictionary *)serviceData {
    
    _serviceData = serviceData;
    NSArray * coordinates = self.serviceData[@"location"];
    self.coordinate = CLLocationCoordinate2DMake([coordinates[1] doubleValue], [coordinates[0] doubleValue]);
    
    NSString * type = @"";
    id rawType = self.serviceData[@"name"];
    if ([rawType isKindOfClass:[NSString class]]) {
        type = rawType;
    }
    self.title = [NSString stringWithFormat:@"%@",type];
    
    NSString * address = @"";
    id rawAdress = self.serviceData[@"address"];
    if ([rawAdress isKindOfClass:[NSString class]]) {
        address = rawAdress;
    }
    NSString * postCode = self.serviceData[@"postCode"];
    NSString * town = self.serviceData[@"town"];
    self.subtitle = [NSString stringWithFormat:@"%@ %@ %@",address, postCode, town];
    
}

- (BOOL)isEnvironment {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"ENVIRONNEMENT"];
    } else {
        return NO;
    }
    
}

- (BOOL)isAdministration {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"ADMINISTRATION"];
    } else {
        return NO;
    }
    
}

- (BOOL)isHealth {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"SANTE"];
    } else {
        return NO;
    }
    
}

- (BOOL)isSchool {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"SCOLAIRE"];
    } else {
        return NO;
    }
    
}

- (BOOL)isSport {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"SPORT"];
    } else {
        return NO;
    }
    return YES;
    
}

- (BOOL)isCulture {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"CULTURE"];
    } else {
        return NO;
    }
    
}

- (BOOL)isChild {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"ENFANCE"];
    } else {
        return NO;
    }
    
}

- (BOOL)isTransport {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"TRANSPORT_STATIONNEMENT"];
    } else {
        return NO;
    }
    
}

- (BOOL)isHistory {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"PATRIMOINE"];
    } else {
        return NO;
    }
    
}

- (BOOL)isSocial {
    id rawType = self.serviceData[@"theme"];
    if ([rawType isKindOfClass:[NSString class]]) {
        return [self.serviceData[@"theme"] isEqualToString:@"SOCIAL"];
    } else {
        return NO;
    }
    
}

@end
