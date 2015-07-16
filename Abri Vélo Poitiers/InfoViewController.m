//
//  InfoViewController.m
//  Poitiers Vélo
//
//  Created by Matthias Lamoureux on 16/07/2015.
//  Copyright (c) 2015 serli. All rights reserved.
//

#import "InfoViewController.h"
#import "NSBundle+Version.h"

@interface InfoViewController ()

@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadInfos];
    [self updateVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - Prepare view

- (void) loadInfos {
    NSURL * rtfUrl = [[NSBundle mainBundle] URLForResource: @"infos" withExtension:@"rtf"];
    NSAttributedString * rtfFileContent = [[NSAttributedString alloc] initWithFileURL:rtfUrl options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
    self.infoTextView.attributedText = rtfFileContent;
}

- (void) updateVersion {
    self.versionLabel.text = [NSBundle displayVersion];
}

@end
