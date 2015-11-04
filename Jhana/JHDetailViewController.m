//
//  JHDetailViewController.m
//  Jhana
//
//  Created by Steven Chung on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHDetailViewController.h"
#import "JHDetailTableViewCell.h"
#import "UIColor+BFPaperColors.h"

@interface JHDetailViewController ()

@end

@implementation JHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSDate *time = [self.detailContext valueForKey:@"timeStamp"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    NSString *dateString = [formatter stringFromDate:time];
    formatter.dateFormat = @"h:mm a";
    self.title = [NSString stringWithFormat:@"%@ at %@", dateString, [formatter stringFromDate:time]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    self.title = @"Back";
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JHDetailCell";
    JHDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JHDetailTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    NSNumber *attention = [self.detailContext valueForKey:@"attention"];
    
    switch (indexPath.row) {
        case 0:
            [cell.questionLabel setText:@"What is your attention?"];
                if ([attention isEqualToNumber:@0]) {
                    cell.answerLabel.text = @"Very Distracted";
                    cell.answerLabel.textColor = [UIColor paperColorPurple800];
                } else if ([attention isEqualToNumber:@1]) {
                    cell.answerLabel.text = @"Somewhat Distracted";
                    cell.answerLabel.textColor = [UIColor paperColorIndigo];
                } else if ([attention isEqualToNumber:@2]) {
                    cell.answerLabel.text = @"Neutral";
                    cell.answerLabel.textColor = [UIColor paperColorTeal];
                } else if ([attention isEqualToNumber:@3]) {
                    cell.answerLabel.text = @"Somewhat Attentive";
                    cell.answerLabel.textColor = [UIColor paperColorLightGreen];
                } else {
                    cell.answerLabel.text = @"Very Attentive";
                    cell.answerLabel.textColor = [UIColor paperColorOrange];
                }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 1:
            [cell.questionLabel setText:@"Where are you located?"];
             cell.answerLabel.text = [NSString stringWithFormat:@"%@", [self.detailContext valueForKey:@"location"]];
            break;
        case 2:
            [cell.questionLabel setText:@"What are you doing?"];
            cell.answerLabel.text = [NSString stringWithFormat:@"%@", [self.detailContext valueForKey:@"activity"]];
            break;
        case 3:
            [cell.questionLabel setText:@"Who were you with?"];
            NSNumber *isAlone = [self.detailContext valueForKey:@"isAlone"];
            if ([isAlone isEqualToNumber:@0]) {
                cell.answerLabel.text = [NSString stringWithFormat:@"You were with: %@", [self.detailContext valueForKey:@"person"]];
            } else {
                cell.answerLabel.text = @"You were alone";
            }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 1) {
        //call location vc
        JHLocationViewController *locationViewController =
        [storyboard instantiateViewControllerWithIdentifier:@"JHLocationViewController"];
        locationViewController.delegate = self;
        [self.navigationController pushViewController:locationViewController animated:YES];
    } else if (indexPath.row == 2) {
        //call activity vc
        JHActivityViewController *activityViewController = [storyboard instantiateViewControllerWithIdentifier:@"JHActivityViewController"];
        activityViewController.delegate = self;
        [self.navigationController pushViewController:activityViewController animated:YES];
    } else if (indexPath.row == 3) {
        //call alone vc
        JHAloneViewController *aloneViewController = [storyboard instantiateViewControllerWithIdentifier:@"JHAloneViewController"];
        aloneViewController.delegate = self;
        [self.navigationController pushViewController:aloneViewController animated:YES];
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}

- (void)changeLocation:(NSString *)newLocation {
    JHDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.answerLabel.text = newLocation;
    [self.detailContext setValue:newLocation forKey:@"location"];
    // Save Record
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveData" object:nil];
}

- (void)changeActivity:(NSString *)newActivity {
    JHDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.answerLabel.text = newActivity;
    [self.detailContext setValue:newActivity forKey:@"activity"];
    // Save Record
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveData" object:nil];
}

- (void)changePerson:(NSString *)newPerson {
    JHDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if ([newPerson isEqualToString:@""]) {
        cell.answerLabel.text = @"You were alone";
        [self.detailContext setValue:@YES forKey:@"isAlone"];
        [self.detailContext setValue:@"" forKey:@"person"];
    } else {
        cell.answerLabel.text = [NSString stringWithFormat:@"You were with: %@", newPerson];
        [self.detailContext setValue:@NO forKey:@"isAlone"];
        [self.detailContext setValue:newPerson forKey:@"person"];
    }
    // Save Record
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveData" object:nil];

}

@end
