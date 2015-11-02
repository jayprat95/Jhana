//
//  JHGraphViewController.m
//  Jhana
//
//  Created by Steven Chung on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHGraphViewController.h"

@interface JHGraphViewController ()

@end

@implementation JHGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Graph";
    
    [self refreshEntries:nil];
    
    CGRect labelFrame = CGRectMake(50, 100, 200, 40);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = @"Your attention over time...";
    [self.view addSubview:label];
    
    CGRect scrollViewFrame = CGRectMake(0, 240, self.view.bounds.size.width, 250);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [self.view addSubview:self.scrollView];
    CGSize scrollViewContentSize = CGSizeMake(640, 250);
    [self.scrollView setContentSize:scrollViewContentSize];
    
    [self setupGraph];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshEntries:) name:@"RefreshGraph" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshEntries:(NSNotification *) notification {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"JHReport"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
    
    // Perform Fetch
    NSError *error = nil;
    self.entryArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    // Called to refresh from JHListViewController
    if (notification != nil) {
        [self.graph removeFromSuperview];
        [self setupGraph];
    }
}

- (void)setupGraph {
    CGRect graphFrame = CGRectMake(0, 0, 640, 250);
    self.graph = [[GKLineGraph alloc] initWithFrame:graphFrame];
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    self.graph.startFromZero = YES;
    [self.graph draw];
    [self.scrollView addSubview:self.graph];
}

#pragma mark - GKLineGraphDataSource

- (NSInteger)numberOfLines {
    return self.entryArray.count;
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    NSArray *colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_sunflowerColor]
                  ];
    return colors[index%colors.count];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    NSMutableArray *valuesArray = [NSMutableArray array];
    for (NSDictionary *entry in self.entryArray) {
        [valuesArray addObject:[entry valueForKey:@"attention"]];
    }
    return valuesArray;
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    NSArray *animationTimes = @[@1, @1.6, @2.2, @1.4];
    return [animationTimes[index%animationTimes.count] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    NSDate *timeStamp = [self.entryArray[index] valueForKey:@"timeStamp"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm\na"];
    return [dateFormatter stringFromDate:timeStamp];
}

@end
