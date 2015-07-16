//
//  NSBundle+Version.m
//  Poitiers Vélo
//
//  Created by Matthias Lamoureux on 16/07/2015.
//  Copyright (c) 2015 serli. All rights reserved.
//

#import "NSBundle+Version.h"

@implementation NSBundle (Version)

/**
 * @brief Renvoie la valeur localisée d'une clé du projet
 *
 * @param aKey Clé du projet située dans info.plist
 * @return Renvoie la valeur associées à la clé, localisée de préférence
 */
- (id) infoValueForKey:(NSString*)aKey {
    id result = [[self localizedInfoDictionary] objectForKey:aKey];
    
    return (result!=nil)?result:[[self infoDictionary] objectForKey:aKey];
}

#pragma mark - Version

- (NSString *) marketingVersion {
    return [self infoValueForKey:@"CFBundleShortVersionString"];
}


- (NSString *) buildVersion {
    return [self infoValueForKey:@"CFBundleVersion"];
}

- (NSString *) displayVersion {
    return [NSString stringWithFormat:@"v.%@ build %@", [self marketingVersion], [self buildVersion]];
}

+ (NSString *) displayVersion {
    return [self mainBundle].displayVersion;
}


@end
