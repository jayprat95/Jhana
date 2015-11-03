//
//  JHDetailViewController.m
//  Jhana
//
//  Created by Steven Chung on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHDetailViewController.h"
#import "JHDetailTableViewCell.h"
@interface JHDetailViewController ()

@end

@implementation JHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setup {
//    self.activityLabel.text = [NSString stringWithFormat:@"Activity: %@", [self.detailContext valueForKey:@"activity"]];
//    NSNumber *attention = [self.detailContext valueForKey:@"attention"];
//    if ([attention isEqualToNumber:@0]) {
//        self.attentionLabel.text = @"Attention: Very Distracted";
//    } else if ([attention isEqualToNumber:@1]) {
//        self.attentionLabel.text = @"Attention: Somewhat Distracted";
//    } else if ([attention isEqualToNumber:@2]) {
//        self.attentionLabel.text = @"Attention: Neutral";
//    } else if ([attention isEqualToNumber:@3]) {
//        self.attentionLabel.text = @"Attention: Somewhat Attentive";
//    } else {
//        self.attentionLabel.text = @"Attention: Very Attentive";
//    }
//    self.locationLabel.text = [NSString stringWithFormat:@"You were at: %@", [self.detailContext valueForKey:@"location"]];
//    NSNumber *isAlone = [self.detailContext valueForKey:@"isAlone"];
//    if ([isAlone isEqualToNumber:@0]) {
//        self.personLabel.text = [NSString stringWithFormat:@"You were with: %@", [self.detailContext valueForKey:@"person"]];
//    } else {
//        self.personLabel.text = @"You were alone";
//    }
//}


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
                    cell.answerLabel.text = @"Attention: Very Distracted";
                } else if ([attention isEqualToNumber:@1]) {
                    cell.answerLabel.text = @"Attention: Somewhat Distracted";
                } else if ([attention isEqualToNumber:@2]) {
                    cell.answerLabel.text = @"Attention: Neutral";
                } else if ([attention isEqualToNumber:@3]) {
                    cell.answerLabel.text = @"Attention: Somewhat Attentive";
                } else {
                    cell.answerLabel.text = @"Attention: Very Attentive";
                }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}


@end
