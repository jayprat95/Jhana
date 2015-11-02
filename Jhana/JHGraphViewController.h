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
#import "UIScrollView+EmptyDataSet.h"

@interface JHGraphViewController : UIViewController <GKLineGraphDataSource, UIScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) GKLineGraph *graph;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *entryArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@end
