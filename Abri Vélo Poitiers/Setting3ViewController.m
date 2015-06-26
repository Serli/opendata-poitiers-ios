//
//  Setting3ViewController.m
//  TestApp
//
//  Created by Serli on 19/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import "Setting3ViewController.h"

@interface Setting3ViewController ()

@end

@implementation Setting3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL transportState = [[NSUserDefaults standardUserDefaults] boolForKey:@"transportValue"];
    BOOL sportState = [[NSUserDefaults standardUserDefaults] boolForKey:@"sportValue"];
    BOOL socialState = [[NSUserDefaults standardUserDefaults] boolForKey:@"socialValue"];
    [self.transportSwitch setOn:transportState];
    [self.sportSwitch setOn:sportState];
    [self.socialSwitch setOn:socialState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:self.transportSwitch.on forKey:@"transportValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.sportSwitch.on forKey:@"sportValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.socialSwitch.on forKey:@"socialValue"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
