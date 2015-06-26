//
//  SettingViewController.m
//  TestApp
//
//  Created by Serli on 17/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL shelterState = [[NSUserDefaults standardUserDefaults] boolForKey:@"shelterValue"];
    BOOL cultureState = [[NSUserDefaults standardUserDefaults] boolForKey:@"cultureValue"];
    BOOL childState = [[NSUserDefaults standardUserDefaults] boolForKey:@"childValue"];
    BOOL environmentState = [[NSUserDefaults standardUserDefaults] boolForKey:@"environmentValue"];
    BOOL administrationState = [[NSUserDefaults standardUserDefaults] boolForKey:@"administrationValue"];
    [self.shelterSwitch setOn:shelterState];
    [self.cultureSwitch setOn:cultureState];
    [self.childSwitch setOn:childState];
    [self.environmentSwitch setOn:environmentState];
    [self.administrationSwitch setOn:administrationState];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:self.shelterSwitch.on forKey:@"shelterValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.cultureSwitch.on forKey:@"cultureValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.childSwitch.on forKey:@"childValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.environmentSwitch.on forKey:@"environmentValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.administrationSwitch.on forKey:@"administrationValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
