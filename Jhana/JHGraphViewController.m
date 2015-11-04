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
    
    self.textLabel.text = @"Your attention over time...";
    
    self.scrollView = [[UIScrollView alloc] init];
    CGRect scrollViewFrame = CGRectMake(0, 140, self.view.bounds.size.width, 350);
    self.scrollView.frame = scrollViewFrame;
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.emptyDataSetSource = self;
    self.scrollView.emptyDataSetDelegate = self;
    
    CGFloat spacing = (self.scrollView.bounds.size.height-30)/4;
    
    CGRect zeroFrame = CGRectMake(0, self.scrollView.bounds.size.height-30, 40, 12);
    self.zeroLabel = [[UILabel alloc] initWithFrame:zeroFrame];
    self.zeroLabel.text = @"0";
    self.zeroLabel.font = [UIFont boldSystemFontOfSize:12];
    self.zeroLabel.textColor = [UIColor lightGrayColor];
    self.zeroLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:self.zeroLabel];
    
    CGRect oneFrame = CGRectMake(0, self.scrollView.bounds.size.height-30-spacing, 40, 12);
    self.oneLabel = [[UILabel alloc] initWithFrame:oneFrame];
    self.oneLabel.text = @"1";
    self.oneLabel.font = [UIFont boldSystemFontOfSize:12];
    self.oneLabel.textColor = [UIColor lightGrayColor];
    self.oneLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:self.oneLabel];
    
    CGRect twoFrame = CGRectMake(0, (self.scrollView.bounds.size.height-50)/2, 40, 12);
    self.twoLabel = [[UILabel alloc] initWithFrame:twoFrame];
    self.twoLabel.text = @"2";
    self.twoLabel.font = [UIFont boldSystemFontOfSize:12];
    self.twoLabel.textColor = [UIColor lightGrayColor];
    self.twoLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:self.twoLabel];
    
    CGRect threeFrame = CGRectMake(0, self.scrollView.bounds.size.height-50-3*spacing, 40, 12);
    self.threeLabel = [[UILabel alloc] initWithFrame:threeFrame];
    self.threeLabel.text = @"3";
    self.threeLabel.font = [UIFont boldSystemFontOfSize:12];
    self.threeLabel.textColor = [UIColor lightGrayColor];
    self.threeLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:self.threeLabel];
    
    CGRect fourFrame = CGRectMake(0, 0, 40, 12);
    self.fourLabel = [[UILabel alloc] initWithFrame:fourFrame];
    self.fourLabel.text = @"4";
    self.fourLabel.font = [UIFont boldSystemFontOfSize:12];
    self.fourLabel.textColor = [UIColor lightGrayColor];
    self.fourLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:self.fourLabel];
    
    
    [self setupLineGraph];
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
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            [self setupLineGraph];
        } else {
            [self setupBarGraph];
        }
    }
}

- (void)setupLineGraph {
    self.zeroLabel.hidden = YES;
    self.oneLabel.hidden = YES;
    self.twoLabel.hidden = YES;
    self.threeLabel.hidden = YES;
    self.fourLabel.hidden = YES;
    
    // Remove existing line graph if it exists
    if (self.lineGraph != nil) {
        [self.lineGraph removeFromSuperview];
    }
    // Remove existing bar graph if it exists
    if (self.barGraph != nil) {
        [self.barGraph removeFromSuperview];
    }
    [self.scrollView reloadEmptyDataSet];
    if (self.entryArray.count > 0) {
        CGFloat width = self.entryArray.count*75;
        CGSize scrollViewContentSize;
        CGRect graphFrame;
        if (width < self.view.bounds.size.width) {
            scrollViewContentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
            graphFrame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        } else {
            scrollViewContentSize = CGSizeMake(width, self.scrollView.bounds.size.height);
            graphFrame = CGRectMake(0, 0, width, self.scrollView.bounds.size.height);
        }
        [self.scrollView setContentSize:scrollViewContentSize];
        self.lineGraph = [[GKLineGraph alloc] initWithFrame:graphFrame];
        self.lineGraph.dataSource = self;
        self.lineGraph.lineWidth = 3.0;
        self.lineGraph.startFromZero = YES;
        [self.lineGraph draw];
        [self.scrollView addSubview:self.lineGraph];
    } else {
        [self.lineGraph removeFromSuperview];
    }
}

- (void)setupBarGraph {
    self.zeroLabel.hidden = NO;
    self.oneLabel.hidden = NO;
    self.twoLabel.hidden = NO;
    self.threeLabel.hidden = NO;
    self.fourLabel.hidden = NO;
    
    // Remove existing line graph if it exists
    if (self.lineGraph != nil) {
        [self.lineGraph removeFromSuperview];
    }
    // Remove existing bar graph if it exists
    if (self.barGraph != nil) {
        [self.barGraph removeFromSuperview];
    }
    [self.scrollView reloadEmptyDataSet];
    // Call delegate method to populate dictionary containing data
    [self numberOfBars];
    if (self.entryArray.count > 0) {
        CGFloat width = self.barGraphData.count*75;
        CGSize scrollViewContentSize;
        CGRect graphFrame;
        if (width < self.view.bounds.size.width) {
            scrollViewContentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
            graphFrame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        } else {
            scrollViewContentSize = CGSizeMake(width, self.scrollView.bounds.size.height);
            graphFrame = CGRectMake(0, 0, width, self.scrollView.bounds.size.height);
        }
        [self.scrollView setContentSize:scrollViewContentSize];
        
        self.barGraph = [[GKBarGraph alloc] initWithFrame:graphFrame];
        self.barGraph.dataSource = self;
//        self.barGraph.marginBar = 50;
        self.barGraph.barWidth = 40;
        self.barGraph.barHeight = self.scrollView.bounds.size.height;
        [self.barGraph draw];
        [self.scrollView addSubview:self.barGraph];
    } else {
        [self.barGraph removeFromSuperview];
    }
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.textLabel.text = @"Your attention over time...";
            [self setupLineGraph];
            break;
        case 1:
            self.textLabel.text = @"Your attention at different locations...";
            [self setupBarGraph];
            break;
        case 2:
            self.textLabel.text = @"Your attention for different activities...";
            [self setupBarGraph];
            break;
        case 3:
            self.textLabel.text = @"Your attention with different people...";
            [self setupBarGraph];
            break;
        default:
            break;
    }
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

#pragma mark - GKBarGraphDataSource

- (NSInteger)numberOfBars {
    NSMutableDictionary *barGraphData = [NSMutableDictionary dictionary];
    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    for (NSDictionary *entry in self.entryArray) {
        NSNumber *attention = [entry valueForKey:@"attention"];
        if (selectedIndex == 1) {
            // Location
            NSString *location = [entry valueForKey:@"location"];
            if (barGraphData[location] == nil) {
                barGraphData[location] = [NSMutableArray array];
            }
            [barGraphData[location] addObject:attention];
        } else if (selectedIndex == 2) {
            // Activity
            NSString *activity = [entry valueForKey:@"activity"];
            if (barGraphData[activity] == nil) {
                barGraphData[activity] = [NSMutableArray array];
            }
            [barGraphData[activity] addObject:attention];
        } else if (selectedIndex == 3) {
            // People
            NSNumber *isAlone = [entry valueForKey:@"isAlone"];
            if (isAlone == nil || [isAlone isEqualToNumber:@1]) {
                if (barGraphData[@"You"] == nil) {
                    barGraphData[@"You"] = [NSMutableArray array];
                }
                [barGraphData[@"You"] addObject:attention];
            } else {
                NSString *person = [entry valueForKey:@"person"];
                if (barGraphData[person] == nil) {
                    barGraphData[person] = [NSMutableArray array];
                }
                [barGraphData[person] addObject:attention];
            }
        }
    }
    self.barGraphData = barGraphData;
    return barGraphData.count;
}

- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
    NSInteger i = 0;
    double avgVal = 0;
    for (NSString *key in self.barGraphData) {
        if (i == index) {
            NSMutableArray *contents = self.barGraphData[key];
            for (NSNumber *attentionValue in contents) {
                avgVal += [attentionValue doubleValue];
            }
            avgVal /= contents.count;
            break;
        }
        i++;
    }
    return [NSNumber numberWithDouble:avgVal*25];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    NSArray *colors = @[[UIColor gk_turquoiseColor],
                        [UIColor gk_peterRiverColor],
                        [UIColor gk_alizarinColor],
                        [UIColor gk_sunflowerColor]
                        ];
    return colors[index%colors.count];
}

- (UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index {
    return [UIColor whiteColor];
}

- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
    NSArray *animationTimes = @[@1, @1.6, @2.2, @1.4];
    return [animationTimes[index%animationTimes.count] doubleValue];
}

- (NSString *)titleForBarAtIndex:(NSInteger)index {
    NSInteger i = 0;
    for (NSString *key in self.barGraphData) {
        if (i == index) {
            return key;
        }
        i++;
    }
    return @"Error occurred";
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Prior Entries";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"To get started, tap the red arrow button below.";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"emptyGraph"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (!self.entryArray || self.entryArray.count == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

@end
