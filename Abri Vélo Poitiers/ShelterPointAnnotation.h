//
//  ShelterPointAnnotation.h
//  Abri Vélo Poitiers
//
//  Created by Matthias Lamoureux on 05/06/2015.
//  Copyright (c) 2015 serli. All rights reserved.
//

#import <MapKit/MapKit.h>

/**
 * @brief Classe représentant les annotations personnalisées sur la carte
 *
 * @author Matthias Lamoureux
 * @copyright Serli SAS - 2015
 */
@interface ShelterPointAnnotation : MKPointAnnotation

/// Dictionnaire de données de l'abri de vélos
@property (nonatomic, strong) NSDictionary * shelterData;

/**
 * @brief Renvoie si le site est un abri
 *
 * @return YES si le site est un abri, NO sinon
 */
- (BOOL) isShelter;

@end
