//
//  JHTableViewCell.m
//  Jhana
//
//  Created by Jayanth Prathipati on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHTableViewCell.h"

@implementation JHTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"%@", self.timeLabel.text);

    // Configure the view for the selected state
}

@end
