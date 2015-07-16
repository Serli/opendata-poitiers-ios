//
//  NSBundle+Version.h
//  Poitiers Vélo
//
//  Created by Matthias Lamoureux on 16/07/2015.
//  Copyright (c) 2015 serli. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief Catégorie de gestion de la version du projet
 *
 * @author Matthias Lamoureux
 * @copyright Serli SAS - 2015
 */
@interface NSBundle (Version)

/**
 * @brief Renvoie la version "marketing" du projet
 *
 * @return Version marketing du projet (e.g. "1.0")
 */
- (NSString *) marketingVersion;

/**
 * @brief Renvoie le numéro de build du projet
 *
 * @note C'est ce numéro du build qui est utilisé dans l'App Store pour gérer les versions, il doit toujours être croissant
 *
 * @return Numéro du build du projet (e.g. "123")
 */
- (NSString *) buildVersion;

/**
 * @brief Renvoie la version à afficher du projet
 *
 * @return Version du brojet (e.g. "v.1.0 build 123")
 */
- (NSString *) displayVersion;

/**
 * @brief Renvoie la version à afficher du projet
 *
 * @return Version du brojet (e.g. "v.1.0 build 123")
 */
+ (NSString *) displayVersion;

@end
