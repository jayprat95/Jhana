//
//  JHAttentionViewController.m
//  Jhana
//
//  Created by Steven Chung on 10/28/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHAttentionViewController.h"

@interface JHAttentionViewController ()

@end

@implementation JHAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.attentionValues = @[@"Very Distracted", @"Somewhat Distracted", @"Neutral", @"Somewhat Attentive", @"Very Attentive"];
    self.title = @"Attention";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)attentionSliderChanged:(UISlider *)sender {
    int value = (int)sender.value;
    sender.value = value;
    self.attentionLabel.text = self.attentionValues[value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"attentionSegue"]) {
        JHLocationViewController *locationViewController = (JHLocationViewController *)segue.destinationViewController;
        NSMutableDictionary *applicationData = [NSMutableDictionary dictionary];
        applicationData[@"attention"] = [NSNumber numberWithInt:(int)(self.attentionSlider.value)];
        locationViewController.applicationData = applicationData;
    }
}

@end
