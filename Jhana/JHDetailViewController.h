//
//  JHDetailViewController.h
//  Jhana
//
//  Created by Steven Chung on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JHLocationViewController.h"
#import "JHDetailViewProtocol.h"

@interface JHDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, JHDetailViewProtocol>
@property (strong, nonatomic) NSManagedObjectModel *detailContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
