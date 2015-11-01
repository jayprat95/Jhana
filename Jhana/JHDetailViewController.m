//
//  JHDetailViewController.m
//  Jhana
//
//  Created by Steven Chung on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHDetailViewController.h"

@interface JHDetailViewController ()

@end

@implementation JHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    self.activityLabel.text = [NSString stringWithFormat:@"Activity: %@", [self.detailContext valueForKey:@"activity"]];
    NSNumber *attention = [self.detailContext valueForKey:@"attention"];
    if ([attention isEqualToNumber:@0]) {
        self.attentionLabel.text = @"Attention: Very Distracted";
    } else if ([attention isEqualToNumber:@1]) {
        self.attentionLabel.text = @"Attention: Somewhat Distracted";
    } else if ([attention isEqualToNumber:@2]) {
        self.attentionLabel.text = @"Attention: Neutral";
    } else if ([attention isEqualToNumber:@3]) {
        self.attentionLabel.text = @"Attention: Somewhat Attentive";
    } else {
        self.attentionLabel.text = @"Attention: Very Attentive";
    }
    self.locationLabel.text = [NSString stringWithFormat:@"You were at: %@", [self.detailContext valueForKey:@"location"]];
    NSNumber *isAlone = [self.detailContext valueForKey:@"isAlone"];
    if ([isAlone isEqualToNumber:@0]) {
        self.personLabel.text = [NSString stringWithFormat:@"You were with: %@", [self.detailContext valueForKey:@"person"]];
    } else {
        self.personLabel.text = @"You were alone";
    }
}

@end
