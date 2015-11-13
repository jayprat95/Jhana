//
//  JHActivityViewController.h
//  Jhana
//
//  Created by Steven Chung on 10/31/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAloneViewController.h"
#import "JHDetailViewProtocol.h"

@interface JHActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *activityValues;
@property (strong, nonatomic) NSMutableDictionary *applicationData;
@property (nonatomic, weak) id <JHDetailViewProtocol> delegate;
@property (strong, nonatomic) NSString *otherLocation;
@end
