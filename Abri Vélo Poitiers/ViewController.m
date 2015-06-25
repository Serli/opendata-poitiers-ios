//
//  ViewController.m
//  Abri Vélo Poitiers
//
//  Created by Matthias Lamoureux on 05/05/2015.
//  Copyright (c) 2015 serli. All rights reserved.
//

#import "ViewController.h"
@import MapKit;
#import "AFNetworking.h"
#import "ShelterPointAnnotation.h"


// position de test dans Poitiers : 46,583719    0,3400767

/// URL du serveur
#define kSERVER_URL @"https://open-data-poitiers.herokuapp.com/bike-shelters/"
/// URL du service de récupération de tous les abris
#define kSERVICE_URL_ALL kSERVER_URL"all"
/// URL du service de recherche des abris les plus proches
#define kSERVICE_URL_FIND_FMT kSERVER_URL"find?lat=%f&lon=%f"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

/// Outlet de la carte
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

/// Gestionnaire de positionnement
@property (nonatomic, strong) CLLocationManager * locationManager;
/// Totalité des données de tous les abris
@property (nonatomic, strong) NSArray * allData;

@end

@implementation ViewController

/**
 * @brief Exécute un service web de manière asynchrone
 *
 * @param aServiceURL URL du service à appeler
 * @param aSuccessBlock Block exécuté en cas de succès, le résultat JSON est passé au paramètre responseObject
 * @param aFailureBlock Block exécuté en cas d'échec
 */
- (void) executeService:(NSString *) aServiceURL
            withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock {
    NSURL *url = [NSURL URLWithString:aServiceURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:aSuccessBlock failure:aFailureBlock];
    
    [operation start];
}

/**
 * @brief Mise à jour des données depuis le serveur
 */
- (void) updateData {
    [self executeService:kSERVICE_URL_ALL
             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 self.allData = responseObject;
                 [self updateMapAnnotations];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
}

/**
 * @brief Met à jour le zoom de la carte centré sur la position de l'utilisateur et des abris les plus proches
 */
- (void) updateZoomAround {
    CLLocationCoordinate2D userCoordinates = self.locationManager.location.coordinate;
    
    [self executeService:[NSString stringWithFormat:kSERVICE_URL_FIND_FMT, userCoordinates.latitude, userCoordinates.longitude]
             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self updateRegionWithShelters:responseObject andUserCoordinates:userCoordinates];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
}

/**
 * @brief Met à jour le zoom de la carte en fonction d'un tableau d'abris et des coordonnées de l'utilisateur
 *
 * @param aShelters Tableau d'abris dont les coordonnées sont stockées dans le keypath shelter.location
 * @param aUserCoordinates Coordonnées de l'utilisateur
 */
- (void) updateRegionWithShelters:(NSArray*) aShelters andUserCoordinates:(CLLocationCoordinate2D) aUserCoordinates {
    if ((aShelters == nil) || (aShelters.count == 0)) {
        return;
    }
    NSArray * allCoords = [[aShelters valueForKeyPath:@"shelter.location"] arrayByAddingObject:@[@(aUserCoordinates.longitude),@(aUserCoordinates.latitude)]];
    MKCoordinateRegion fullRegion = [self regionFromCoordinates:allCoords];
    [self.mapView setRegion:fullRegion animated:YES];
}

/**
 * @brief Événement exécuté au chargement de la vue
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    
    NSData * json = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"abris_appuis_velos" ofType:@".json"]];
    self.allData = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
}

/**
 * @brief Événement exécuté avant l'affichage de la vue
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MKCoordinateRegion fullRegion = [self regionFromCoordinates:[self.allData valueForKey:@"location"]];
    [self.mapView setRegion:fullRegion animated:animated];
    
    [self updateMapAnnotations];

    [self updateData];
    [self.locationManager startUpdatingLocation];
}

/**
 * @brief Met à jour les annoations de la carte
 */
- (void) updateMapAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self createAnnotations:self.allData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map Helpers

/**
 * @brief Renvoie une région à partir d'un tableau de coordonnées
 *
 * @param aCoordoniates Tableau de coordonnées
 * @return Région englobant les coordonnées
 */
- (MKCoordinateRegion) regionFromCoordinates:(NSArray *) aCoordinates {
    __block CLLocationDegrees maxLat = DBL_MIN;
    __block CLLocationDegrees minLat = DBL_MAX;
    __block CLLocationDegrees maxLon = DBL_MIN;
    __block CLLocationDegrees minLon = DBL_MAX;
    
    [aCoordinates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CLLocationDegrees lat = [obj[1] doubleValue];
        CLLocationDegrees lon = [obj[0] doubleValue];
        
        if (lat > maxLat) {
            maxLat = lat;
        }
        if (lat < minLat) {
            minLat = lat;
        }
        if (lon > maxLon) {
            maxLon = lon;
        }
        if (lon < minLon) {
            minLon = lon;
        }
    }];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(0.5*(maxLat + minLat), 0.5*(maxLon + minLon));
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    
    return MKCoordinateRegionMake(center, span);
}

/**
 * @brief Crée les annotations pour tous les abris
 *
 * @param aSelters Tableau des abris
 */
- (void) createAnnotations:(NSArray *) aShelters {
    [aShelters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ShelterPointAnnotation * annotation = [[ShelterPointAnnotation alloc] init];
        annotation.shelterData = obj;
        [self.mapView addAnnotation:annotation];
    }];
}

#pragma mark - MKMapViewDelegate

/**
 * @brief Méthode du protocole MKMapViewDelegate renvoyant la vue associées à une annotation
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[ShelterPointAnnotation class]]) {
        ShelterPointAnnotation * shelterAnnotation = annotation;
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"BIKE_ANNOTATION"];
        if (pinView == nil) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BIKE_ANNOTATION"];
        }

        pinView.annotation = annotation;
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:shelterAnnotation.isShelter?@"bike_shelter":@"bike"];

        UIImage * buttonImage = [UIImage imageNamed:@"go"];
        UIButton * detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
        [detailButton setImage:buttonImage forState:UIControlStateNormal];
        pinView.rightCalloutAccessoryView = detailButton;

        return pinView;
    }
    else {
        return nil;
    }
}

/**
 * @brief Méthode du protocole MKMapViewDelegate renvoyant la vue associées à une couche
 */
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}

/**
 * @brief Méthode du protocole MKMapViewDelegate exécutée quand l'utilisateur clique sur le bouton de la bulle d'une annotation
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"accessory button tapped for annotation %@", view.annotation);
    
    id <MKAnnotation> annotation = view.annotation;
    
    [self.mapView deselectAnnotation:annotation animated:YES];
    
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    
    CLLocationCoordinate2D coordinate = [annotation coordinate];
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.source = source;
    request.destination = destination;
    request.transportType = MKDirectionsTransportTypeWalking;
    request.departureDate = [NSDate date];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *route = obj;
            
            MKPolyline *line = route.polyline;
            [self.mapView removeOverlays:self.mapView.overlays];
            [self.mapView addOverlay:line];
            [self.mapView setVisibleMapRect:line.boundingMapRect edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:YES];
            NSLog(@"Route Name : %@",route.name);
            NSLog(@"Total Distance (in Meters) :%f",route.distance);
            
            NSArray *steps = route.steps;
            
            NSLog(@"Total Steps : %ld",(long)steps.count);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Route Instruction : %@",[obj instructions]);
                NSLog(@"Route Distance : %f",[obj distance]);
            }];
        }];
    }];
}

#pragma mark - CLLocationManagerDelegate

/**
 * @brief Méthode du protocole CLLocationManager exécutée lorsque la position de l'utilisateur est mise à jour
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self updateZoomAround];
    self.locationManager.delegate = nil;
}

@end
