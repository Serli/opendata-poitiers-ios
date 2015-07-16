//
//  InfoViewController.m
//  Poitiers Vélo
//
//  Created by Matthias Lamoureux on 16/07/2015.
//  Copyright (c) 2015 serli. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL * rtfUrl = [[NSBundle mainBundle] URLForResource: @"infos" withExtension:@"rtf"];
    NSAttributedString * rtfFileContent = [[NSAttributedString alloc] initWithFileURL:rtfUrl options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
    self.infoTextView.attributedText = rtfFileContent;
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
