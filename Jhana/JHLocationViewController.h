//
//  JHLocationViewController.h
//  Jhana
//
//  Created by Steven Chung on 10/31/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHActivityViewController.h"
#import "JHDetailViewProtocol.h"

@interface JHLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *locationValues;
@property (strong, nonatomic) NSMutableDictionary *applicationData;
@property (nonatomic, weak) id <JHDetailViewProtocol> delegate;
@end
