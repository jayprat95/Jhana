//
//  JHTableViewCell.h
//  Jhana
//
//  Created by Jayanth Prathipati on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *attentionLabel;

@end
