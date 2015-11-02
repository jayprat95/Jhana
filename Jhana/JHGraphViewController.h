//
//  JHGraphViewController.h
//  Jhana
//
//  Created by Steven Chung on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphKit.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface JHGraphViewController : UIViewController <GKLineGraphDataSource>
@property (nonatomic, strong) IBOutlet GKLineGraph *graph;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *entryArray;
@end
