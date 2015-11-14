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
#import "UIColor+BFPaperColors.h"

@interface JHGraphViewController : UIViewController <GKLineGraphDataSource, GKBarGraphDataSource, UIScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) GKLineGraph *lineGraph;
@property (nonatomic, strong) GKBarGraph *barGraph;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *entryArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) UILabel *mostAttentiveLabel;
@property (strong, nonatomic) UILabel *leastAttentiveLabel;
@property (strong, nonatomic) NSMutableDictionary *barGraphData;
@property (strong, nonatomic) UILabel *zeroLabel;
@property (strong, nonatomic) UILabel *oneLabel;
@property (strong, nonatomic) UILabel *twoLabel;
@property (strong, nonatomic) UILabel *threeLabel;
@property (strong, nonatomic) UILabel *fourLabel;
@end
