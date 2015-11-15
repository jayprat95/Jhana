//
//  JHAloneViewController.m
//  Jhana
//
//  Created by Steven Chung on 10/31/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHAloneViewController.h"
#import "Flurry.h"

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
    
    if ([self.delegate conformsToProtocol:@protocol(JHDetailViewProtocol)]) {
        JHDetailViewController *detailViewController = (JHDetailViewController *)self.delegate;
        BOOL isAlone = [[detailViewController.detailContext valueForKey:@"isAlone"] boolValue];
        if (!isAlone) {
            self.aloneSegmentedControl.selectedSegmentIndex = 1;
            NSString *personName = [detailViewController.detailContext valueForKey:@"person"];
            self.personTextField.text = personName;
            self.personTextField.hidden = NO;
            self.submitButton.hidden = NO;
        } else {
            self.aloneSegmentedControl.selectedSegmentIndex = 0;
        }
    }
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
        if ([self.personTextField.text isEqualToString:@""]) {
            self.submitButton.hidden = YES;
        }
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
        self.applicationData[@"person"] = [self.personTextField.text capitalizedString];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveData" object:self.applicationData];
        UINavigationController *navController = (UINavigationController *)self.navigationController;
        JHAttentionGestureViewController *attentionViewController = (JHAttentionGestureViewController *)navController.viewControllers[0];
        [Flurry logEvent:@"New Event Created"];
        [Flurry endTimedEvent:@"New Event Creation Started" withParameters:self.applicationData];
        [attentionViewController cancelButtonClicked:self];
    }
}

@end
