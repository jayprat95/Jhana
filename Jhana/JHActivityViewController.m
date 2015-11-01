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
    self.activityValues = @[@"Work", @"Leisure", @"Errands", @"Commuting"];
    self.title = @"Activity";
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"activitySegue"]) {
        JHAloneViewController *aloneViewController = (JHAloneViewController *)segue.destinationViewController;
        NSMutableDictionary *applicationData = [NSMutableDictionary dictionaryWithDictionary:self.applicationData];
        applicationData[@"activity"] = self.activityValues[self.tableView.indexPathForSelectedRow.row];
        aloneViewController.applicationData = applicationData;
    }
}

@end
