//
//  JHAloneViewController.m
//  Jhana
//
//  Created by Steven Chung on 10/31/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHAloneViewController.h"

@interface JHAloneViewController ()

@end

@implementation JHAloneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Alone";
    self.personTextField.delegate = self;
    self.personLabel.hidden = YES;
    self.personTextField.hidden = YES;
    self.submitButton.hidden = YES;
    self.aloneSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)personTextFieldWasEdited:(UITextField *)sender {
    if ([self.personTextField.text isEqualToString:@""]) {
        self.submitButton.hidden = YES;
    } else {
        self.submitButton.hidden = NO;
    }
}

- (IBAction)aloneSegmentedControlValueSelected:(id)sender {
    if (self.aloneSegmentedControl.selectedSegmentIndex == 0) {
        // User is alone
        self.submitButton.hidden = NO;
        self.personLabel.hidden = YES;
        self.personTextField.hidden = YES;
    } else {
        // User is with other people
        self.submitButton.hidden = YES;
        self.personTextField.hidden = NO;
        self.personLabel.hidden = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.personTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)submitButtonClicked:(UIButton *)sender {
    if ([self.delegate conformsToProtocol:@protocol(JHDetailViewProtocol)]) {
        [self.delegate changePerson:self.personTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.applicationData[@"isAlone"] = (self.aloneSegmentedControl.selectedSegmentIndex == 0) ? @YES : @NO;
//        if ([self.applicationData[@"isAlone"] isEqual: @NO]) {
            self.applicationData[@"person"] = self.personTextField.text;
//        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveData" object:self.applicationData];
        UINavigationController *navController = (UINavigationController *)self.navigationController;
        JHAttentionGestureViewController *attentionViewController = (JHAttentionGestureViewController *)navController.viewControllers[0];
        [attentionViewController cancelButtonClicked:self];
    }
}

@end
