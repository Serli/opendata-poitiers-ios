//
//  Setting2ViewController.m
//  TestApp
//
//  Created by Serli on 18/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import "Setting2ViewController.h"

@interface Setting2ViewController ()

@end

@implementation Setting2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL healthState = [[NSUserDefaults standardUserDefaults] boolForKey:@"healthValue"];
    BOOL schoolState = [[NSUserDefaults standardUserDefaults] boolForKey:@"schoolValue"];
    BOOL ticketmachineState = [[NSUserDefaults standardUserDefaults] boolForKey:@"ticketmachineValue"];
    BOOL historyState = [[NSUserDefaults standardUserDefaults] boolForKey:@"historyValue"];
    BOOL parkState = [[NSUserDefaults standardUserDefaults] boolForKey:@"parkValue"];
    [self.healthSwitch setOn:healthState];
    [self.schoolSwitch setOn:schoolState];
    [self.ticketmachineSwitch setOn:ticketmachineState];
    [self.historySwitch setOn:historyState];
    [self.parkSwitch setOn:parkState];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:self.healthSwitch.on forKey:@"healthValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.schoolSwitch.on forKey:@"schoolValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.ticketmachineSwitch.on forKey:@"ticketmachineValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.historySwitch.on forKey:@"historyValue"];
    [[NSUserDefaults standardUserDefaults] setBool:self.parkSwitch.on forKey:@"parkValue"];
    
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
