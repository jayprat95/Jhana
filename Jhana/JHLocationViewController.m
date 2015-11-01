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
    self.locationValues = @[@"Work", @"Home", @"Restaurant"];
    self.title = @"Location";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationValues.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"locationSegue"]) {
        JHActivityViewController *activityViewController = (JHActivityViewController *)segue.destinationViewController;
        NSMutableDictionary *applicationData = [NSMutableDictionary dictionaryWithDictionary:self.applicationData];
        applicationData[@"location"] = self.locationValues[self.tableView.indexPathForSelectedRow.row];
        activityViewController.applicationData = applicationData;
    }
}

@end
