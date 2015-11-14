//
//  JHActivityViewController.m
//  Jhana
//
//  Created by Steven Chung on 10/31/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHActivityViewController.h"

@interface JHActivityViewController ()

@end

@implementation JHActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.activityValues = @[@"Eating", @"Watching TV", @"Reading", @"Working", @"Traveling", @"Talking", @"Using Technology", @"Exercising", @"Errands", @"Other"];
    self.title = @"Activity";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"activityCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.activityValues[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityValues.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Other"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Other Activity..." message:@"Please enter activity" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
            self.otherLocation = [((UITextField *)[alert.textFields objectAtIndex:0]).text capitalizedString];
            [self checkForAppropriateSegue:indexPath];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter activity here";
        }];
        [alert addAction:enterAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self checkForAppropriateSegue:indexPath];
}

- (void)checkForAppropriateSegue:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(JHDetailViewProtocol)]) {
        [self.delegate changeActivity:self.activityValues[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"activitySegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"activitySegue"]) {
        JHAloneViewController *aloneViewController = (JHAloneViewController *)segue.destinationViewController;
        NSMutableDictionary *applicationData = [NSMutableDictionary dictionaryWithDictionary:self.applicationData];
        if (self.otherLocation) {
            applicationData[@"activity"] = self.otherLocation;
        } else {
            applicationData[@"activity"] = self.activityValues[self.tableView.indexPathForSelectedRow.row];
        }
        aloneViewController.applicationData = applicationData;
    }
}

@end
