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
#import "TicketmachinePointAnnotation.h"
#import "ParkPointAnnotation.h"
#import "ServicePointAnnotation.h"

#import "SettingViewController.h"
#import "Setting2ViewController.h"
#import "Setting3ViewController.h"


// position de test dans Poitiers : 46,583719    0,3400767

#define kSERVER_URL @"http://192.168.86.184:8080/allInstallations/"
#define kSERVICE_URL_ALL_SHELTERS kSERVER_URL"allShelters"
#define kSERVICE_URL_ALL_TICKETMACHINES kSERVER_URL"allTicketmachines"
#define kSERVICE_URL_ALL_PARKS kSERVER_URL"allParks"
#define kSERVICE_URL_ALL_SERVICES kSERVER_URL"allServices"
#define kSERVICE_URL_FIND_FMT kSERVER_URL"find?lat=%f&lon=%f"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) NSArray * shelterData;
@property (nonatomic, strong) NSArray * ticketmachineData;
@property (nonatomic, strong) NSArray * parkData;
@property (nonatomic, strong) NSArray * serviceData;

@end

@implementation ViewController

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

- (void) updateData {
    [self executeService:kSERVICE_URL_ALL_SHELTERS
             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 self.shelterData = responseObject;
                 [self updateMapAnnotations];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
    
    [self executeService:kSERVICE_URL_ALL_TICKETMACHINES
             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 self.ticketmachineData = responseObject;
                 [self updateMapAnnotations];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
    
    [self executeService:kSERVICE_URL_ALL_PARKS
             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 self.parkData = responseObject;
                 [self updateMapAnnotations];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
    
    [self executeService:kSERVICE_URL_ALL_SERVICES
             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 self.serviceData = responseObject;
                 [self updateMapAnnotations];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
}

- (void) updateZoomAround {
    CLLocationCoordinate2D userCoordinates = self.locationManager.location.coordinate;
    
    [self executeService:[NSString stringWithFormat:kSERVICE_URL_FIND_FMT, userCoordinates.latitude, userCoordinates.longitude]
             withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self updateRegionWithShelters:responseObject andUserCoordinates:userCoordinates];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",error);
             }];
}

- (void) updateRegionWithShelters:(NSArray*) aShelters andUserCoordinates:(CLLocationCoordinate2D) aUserCoordinates {
    if ((aShelters == nil) || (aShelters.count == 0)) {
        return;
    }
    NSArray * allCoords = [[aShelters valueForKeyPath:@"shelter.location"] arrayByAddingObject:@[@(aUserCoordinates.longitude),@(aUserCoordinates.latitude)]];
    MKCoordinateRegion fullRegion = [self regionFromCoordinates:allCoords];
    [self.mapView setRegion:fullRegion animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    
    NSData * jsonShelter = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"abris_appuis_velos" ofType:@".json"]];
    self.shelterData = [NSJSONSerialization JSONObjectWithData:jsonShelter options:0 error:NULL];
    
    NSData * jsonTicketmachine = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Horodateurs" ofType:@".json"]];
    self.ticketmachineData = [NSJSONSerialization JSONObjectWithData:jsonTicketmachine options:0 error:NULL];
    
    NSData * jsonPark = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GIG_GIC" ofType:@".json"]];
    self.parkData = [NSJSONSerialization JSONObjectWithData:jsonPark options:0 error:NULL];
    
    NSData * dataService = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Equipements_publics" ofType:@"json"]];
    self.serviceData = [NSJSONSerialization JSONObjectWithData: dataService options: 0 error: NULL];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray * shelterLocation = [self.shelterData valueForKey:@"location"];
    NSArray * ticketmachineLocation = [self.ticketmachineData valueForKey:@"location"];
    NSArray * parkLocation = [self.parkData valueForKey:@"location"];
    NSArray * serviceLocation = [self.serviceData valueForKey:@"location"];
    MKCoordinateRegion fullRegion = [self regionFromCoordinates:[[[shelterLocation arrayByAddingObjectsFromArray:ticketmachineLocation] arrayByAddingObjectsFromArray:parkLocation] arrayByAddingObjectsFromArray:serviceLocation]];
    [self.mapView setRegion:fullRegion animated:animated];
    
    [self updateMapAnnotations];

    [self updateData];
    [self.locationManager startUpdatingLocation];
}

- (void) updateMapAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self createAnnotationsForShelters:self.shelterData andTicketmachines:self.ticketmachineData andParks:self.parkData andServices:self.serviceData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map Helpers

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

- (void) createAnnotationsForShelters:(NSArray *) aShelters andTicketmachines:(NSArray *) aTicketmachine andParks:(NSArray *) aPark andServices:(NSArray *) aService{
    [aShelters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ShelterPointAnnotation * annotation = [[ShelterPointAnnotation alloc] init];
        annotation.shelterData = obj;
        [self.mapView addAnnotation:annotation];
    }];
    
    [aTicketmachine enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TicketmachinePointAnnotation * annotation = [[TicketmachinePointAnnotation alloc] init];
        annotation.ticketmachineData = obj;
        [self.mapView addAnnotation:annotation];
    }];
    
    [aPark enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ParkPointAnnotation * annotation = [[ParkPointAnnotation alloc] init];
        annotation.parkData = obj;
        [self.mapView addAnnotation:annotation];
    }];
    
    [aService enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ServicePointAnnotation * annotation = [[ServicePointAnnotation alloc] init];
        annotation.serviceData = obj;
        [self.mapView addAnnotation:annotation];
    }];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    MKAnnotationView * pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ANNOTATION"];
    if (pinView == nil) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ANNOTATION"];
    }
    
    pinView.annotation = annotation;
    pinView.canShowCallout =YES;
    UIImage * buttonImage = [UIImage imageNamed:@"go"];
    UIButton * detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [detailButton setImage:buttonImage forState:UIControlStateNormal];
    pinView.rightCalloutAccessoryView = detailButton;
    
    if ([annotation isKindOfClass:[ShelterPointAnnotation class]]) {
        ShelterPointAnnotation * shelterAnnotation = annotation;
        pinView.image = [UIImage imageNamed:shelterAnnotation.isShelter?@"bike_shelter":@"bike"];
    } else if ([annotation isKindOfClass:[TicketmachinePointAnnotation class]]) {
        pinView.image = [UIImage imageNamed:@"horodateur"];
    } else if ([annotation isKindOfClass:[ParkPointAnnotation class]]) {
        pinView.image = [UIImage imageNamed:@"handicap"];
    } else if ([annotation isKindOfClass:[ServicePointAnnotation class]]) {
        ServicePointAnnotation * serviceAnnotation = annotation;
        if(serviceAnnotation.isEnvironment) {
            pinView.image = [UIImage imageNamed:@"environnement"];
        } else if (serviceAnnotation.isAdministration) {
            pinView.image = [UIImage imageNamed:@"administration"];
        } else if (serviceAnnotation.isHealth) {
            pinView.image = [UIImage imageNamed:@"sante"];
        } else if (serviceAnnotation.isSchool){
            pinView.image = [UIImage imageNamed:@"scolaire"];
        } else if (serviceAnnotation.isSport){
            pinView.image = [UIImage imageNamed:@"sport"];
        } else if (serviceAnnotation.isCulture){
            pinView.image = [UIImage imageNamed:@"culture"];
        } else if (serviceAnnotation.isChild){
            pinView.image = [UIImage imageNamed:@"enfance"];
        } else if (serviceAnnotation.isTransport){
            pinView.image = [UIImage imageNamed:@"transport"];
        } else if (serviceAnnotation.isHistory){
            pinView.image = [UIImage imageNamed:@"patrimoine"];
        } else if (serviceAnnotation.isSocial){
            pinView.image = [UIImage imageNamed:@"social"];
        } else {
            [self.mapView removeAnnotation:annotation];
        }
    } else {
        return nil;
    }
    return pinView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}

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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self updateZoomAround];
    self.locationManager.delegate = nil;
}

@end
