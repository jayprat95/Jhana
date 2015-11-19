//
//  JHLocationViewController.m
//  Jhana
//
//  Created by Steven Chung on 10/31/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHLocationViewController.h"

@interface JHLocationViewController ()

@end

@implementation JHLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.locationValues = @[@"Work", @"Home", @"Restaurant", @"Coffee Shop", @"Bar/Pub", @"Store", @"Outside", @"Hotel/Lodging", @"Friend's House", @"Other"];
    self.title = @"Location";
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
    static NSString *cellIdentifier = @"locationCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.locationValues[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Other"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Other Location..." message:@"Please enter location" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
            self.otherLocation = [((UITextField *)[alert.textFields objectAtIndex:0]).text capitalizedString];
            [self checkForAppropriateSegue:indexPath];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter location here";
        }];
        [alert addAction:enterAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self checkForAppropriateSegue:indexPath];
}

- (void)checkForAppropriateSegue:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(JHDetailViewProtocol)]) {
        if (self.otherLocation) {
            [self.delegate changeLocation:self.otherLocation];
        } else {
            [self.delegate changeLocation:self.locationValues[indexPath.row]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"locationSegue" sender:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationValues.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"locationSegue"]) {
        JHActivityViewController *activityViewController = (JHActivityViewController *)segue.destinationViewController;
        NSMutableDictionary *applicationData = [NSMutableDictionary dictionaryWithDictionary:self.applicationData];
        if (self.otherLocation) {
            applicationData[@"location"] = self.otherLocation;
        } else {
            applicationData[@"location"] = self.locationValues[self.tableView.indexPathForSelectedRow.row];
        }
        activityViewController.applicationData = applicationData;
    }
}

@end
