//
//  SettingViewController.h
//  TestApp
//
//  Created by Serli on 17/06/2015.
//  Copyright (c) 2015 Serli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *shelterSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *environmentSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *administrationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *cultureSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *childSwitch;

@end
