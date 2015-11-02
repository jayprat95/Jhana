//
//  JHListViewController.h
//  Jhana
//
//  Created by Jayanth Prathipati on 10/7/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHDetailViewController.h"

@interface JHListViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
