//
//  ServicePointAnnotation.h
//  TestApp
//
//  Created by Serli on 18/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ServicePointAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSDictionary * serviceData;

- (BOOL)isEnvironment;
- (BOOL)isAdministration;
- (BOOL)isHealth;
- (BOOL)isSchool;
- (BOOL)isSport;
- (BOOL)isCulture;
- (BOOL)isChild;
- (BOOL)isTransport;
- (BOOL)isHistory;
- (BOOL)isSocial;

@end
