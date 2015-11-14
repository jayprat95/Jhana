//
//  JHGraphViewController.m
//  Jhana
//
//  Created by Steven Chung on 11/1/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHGraphViewController.h"

CGFloat const labelPadding = 75.0f;
CGFloat const labelCombinedHeights = 25.0f;

@interface JHGraphViewController ()

@end

@implementation JHGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Graph";
    
    [self refreshEntries:nil];
    
    self.textLabel.text = @"Your attention over time...";
    
    self.scrollView = [[UIScrollView alloc] init];
    CGRect scrollViewFrame = CGRectMake(0, 140, self.view.bounds.size.width, 400);
    self.scrollView.frame = scrollViewFrame;
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.emptyDataSetSource = self;
    self.scrollView.emptyDataSetDelegate = self;
    
    CGFloat spacing = (self.scrollView.bounds.size.height-labelCombinedHeights-labelPadding)/4;
    
    CGRect zeroFrame = CGRectMake(0, self.scrollView.bounds.size.height-labelCombinedHeights-labelPadding, 40, 12);
    self.zeroLabel = [[UILabel alloc] initWithFrame:zeroFrame];
    self.zeroLabel.text = @"VD";
    self.zeroLabel.font = [UIFont boldSystemFontOfSize:12];
    self.zeroLabel.textColor = [UIColor lightGrayColor];
    self.zeroLabel.textAlignment = NSTextAlignmentRight;
    self.zeroLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.zeroLabel];
    
    CGRect oneFrame = CGRectMake(0, self.scrollView.bounds.size.height-labelCombinedHeights-spacing-labelPadding, 40, 12);
    self.oneLabel = [[UILabel alloc] initWithFrame:oneFrame];
    self.oneLabel.text = @"SD";
    self.oneLabel.font = [UIFont boldSystemFontOfSize:12];
    self.oneLabel.textColor = [UIColor lightGrayColor];
    self.oneLabel.textAlignment = NSTextAlignmentRight;
    self.zeroLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.oneLabel];
    
    CGRect twoFrame = CGRectMake(0, (self.scrollView.bounds.size.height-labelCombinedHeights-labelPadding)/2, 40, 12);
    self.twoLabel = [[UILabel alloc] initWithFrame:twoFrame];
    self.twoLabel.text = @"N";
    self.twoLabel.font = [UIFont boldSystemFontOfSize:12];
    self.twoLabel.textColor = [UIColor lightGrayColor];
    self.twoLabel.textAlignment = NSTextAlignmentRight;
    self.zeroLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.twoLabel];
    
    CGRect threeFrame = CGRectMake(0, self.scrollView.bounds.size.height-labelCombinedHeights-3*spacing-labelPadding, 40, 12);
    self.threeLabel = [[UILabel alloc] initWithFrame:threeFrame];
    self.threeLabel.text = @"SA";
    self.threeLabel.font = [UIFont boldSystemFontOfSize:12];
    self.threeLabel.textColor = [UIColor lightGrayColor];
    self.threeLabel.textAlignment = NSTextAlignmentRight;
    self.zeroLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.threeLabel];
    
    CGRect fourFrame = CGRectMake(0, 0, 40, 12);
    self.fourLabel = [[UILabel alloc] initWithFrame:fourFrame];
    self.fourLabel.text = @"VA";
    self.fourLabel.font = [UIFont boldSystemFontOfSize:12];
    self.fourLabel.textColor = [UIColor lightGrayColor];
    self.fourLabel.textAlignment = NSTextAlignmentRight;
    self.zeroLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.fourLabel];
    
    self.zeroLabel.backgroundColor = [UIColor whiteColor];
    self.oneLabel.backgroundColor = [UIColor whiteColor];
    self.twoLabel.backgroundColor = [UIColor whiteColor];
    self.threeLabel.backgroundColor = [UIColor whiteColor];
    self.fourLabel.backgroundColor = [UIColor whiteColor];
    
    CGRect mostAttentiveLabelFrame = CGRectMake(0, 325, self.scrollView.frame.size.width, 20);
    self.mostAttentiveLabel = [[UILabel alloc] initWithFrame:mostAttentiveLabelFrame];
    [self.scrollView addSubview:self.mostAttentiveLabel];
    
    CGRect leastAttentiveLabelFrame = CGRectMake(0, 350, self.scrollView.frame.size.width, 20);
    self.leastAttentiveLabel = [[UILabel alloc] initWithFrame:leastAttentiveLabelFrame];
    [self.scrollView addSubview:self.leastAttentiveLabel];
    
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
    self.mostAttentiveLabel.hidden = YES;
    self.leastAttentiveLabel.hidden = YES;
    
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
            scrollViewContentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height-labelPadding);
            graphFrame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height-labelPadding);
        } else {
            scrollViewContentSize = CGSizeMake(width, self.scrollView.bounds.size.height-labelPadding);
            graphFrame = CGRectMake(0, 0, width, self.scrollView.bounds.size.height-labelPadding);
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
    self.mostAttentiveLabel.hidden = NO;
    self.leastAttentiveLabel.hidden = NO;
    
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
            graphFrame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height-labelPadding);
        } else {
            scrollViewContentSize = CGSizeMake(width, self.scrollView.bounds.size.height);
            graphFrame = CGRectMake(0, 0, width, self.scrollView.bounds.size.height-labelPadding);
        }
        [self.scrollView setContentSize:scrollViewContentSize];
        
        self.barGraph = [[GKBarGraph alloc] initWithFrame:graphFrame];
        self.barGraph.dataSource = self;
//        self.barGraph.marginBar = 50;
        self.barGraph.barWidth = 40;
        self.barGraph.barHeight = graphFrame.size.height-25;
        [self.barGraph draw];
        [self.scrollView addSubview:self.barGraph];
        
        double minValue = MAXFLOAT;
        double maxValue = -MAXFLOAT;
        double avgValue = 0;
        NSString *minKey;
        NSString *maxKey;
        
        for (NSString *key in self.barGraphData) {
            for (NSNumber *attention in self.barGraphData[key]) {
                avgValue += [attention doubleValue];
            }
            if (avgValue <= minValue) {
                if (avgValue == minValue) {
                    minKey = [NSString stringWithFormat:@"%@, %@", minKey, key];
                } else {
                    minKey = key;
                }
                minValue = avgValue;
            }
            if (avgValue >= maxValue) {
                if (avgValue == maxValue) {
                    maxKey = [NSString stringWithFormat:@"%@, %@", maxKey, key];
                } else {
                    maxKey = key;
                }
                maxValue = avgValue;
            }
            avgValue = 0;
        }
        NSMutableString *mostAttentiveString = [NSMutableString stringWithString:@"You were most attentive "];
        NSMutableString *leastAttentiveString = [NSMutableString stringWithString:@"You were least attentive "];
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            [mostAttentiveString appendString:@"at "];
            [leastAttentiveString appendString:@"at "];
        } else if (self.segmentedControl.selectedSegmentIndex == 2) {
            [mostAttentiveString appendString:@"when "];
            [leastAttentiveString appendString:@"when "];
        } else {
            [mostAttentiveString appendString:@"with "];
            [leastAttentiveString appendString:@"with "];
        }
        [mostAttentiveString appendString:maxKey];
        [leastAttentiveString appendString:minKey];
        self.mostAttentiveLabel.text = mostAttentiveString;
        self.mostAttentiveLabel.textAlignment = NSTextAlignmentCenter;
        self.leastAttentiveLabel.text = leastAttentiveString;
        self.leastAttentiveLabel.textAlignment = NSTextAlignmentCenter;
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

- (UIColor *)blendTwoColors:(UIColor *)color1 withColor:(UIColor *)color2 withAlpha:(CGFloat)alpha {
    alpha = MIN(1.f, MAX(0.f, alpha));
    float beta = 1.f - alpha;
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    CGFloat r = r1 * beta + r2 * alpha;
    CGFloat g = g1 * beta + g2 * alpha;
    CGFloat b = b1 * beta + b2 * alpha;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

#pragma mark - GKLineGraphDataSource

- (NSInteger)numberOfLines {
    return self.entryArray.count;
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    NSArray *colors = @[[UIColor paperColorPurple800],
                        [UIColor paperColorIndigo],
                        [UIColor paperColorTeal],
                        [UIColor paperColorLightGreen],
                        [UIColor paperColorOrange]
                        ];
    NSArray *attentionValues = [self valuesForLineAtIndex:0];
    NSInteger lastAttentionValue = [attentionValues[attentionValues.count-1] integerValue];
    return colors[lastAttentionValue];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    if (index == 0) {
        NSMutableArray *valuesArray = [NSMutableArray array];
        for (NSDictionary *entry in self.entryArray) {
            [valuesArray addObject:[entry valueForKey:@"attention"]];
        }
        return valuesArray;
    }
    return @[];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return .25*[self valuesForLineAtIndex:0].count;
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
                if (barGraphData[@"Yourself"] == nil) {
                    barGraphData[@"Yourself"] = [NSMutableArray array];
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
    if (isnan(avgVal)) {
        // Case where attention has value 0, still want user to see bar
        return [NSNumber numberWithDouble:1];
    }
    return [NSNumber numberWithDouble:avgVal*25];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    NSArray *colors = @[[UIColor paperColorPurple800],
                        [UIColor paperColorIndigo],
                        [UIColor paperColorTeal],
                        [UIColor paperColorLightGreen],
                        [UIColor paperColorOrange]
                        ];
    double attentionValue = [[self valueForBarAtIndex:index] doubleValue];
    if (attentionValue == 100) {
        return colors[4];
    }
    if (attentionValue > 75) {
        return [self blendTwoColors:colors[4] withColor:colors[3] withAlpha:(100-attentionValue)/25];
    }
    if (attentionValue == 75) {
        return colors[3];
    }
    if (attentionValue > 50) {
        return [self blendTwoColors:colors[3] withColor:colors[2] withAlpha:(75-attentionValue)/25];
    }
    if (attentionValue == 50) {
        return colors[2];
    }
    if (attentionValue > 25) {
        return [self blendTwoColors:colors[2] withColor:colors[1] withAlpha:(50-attentionValue)/25];
    }
    if (attentionValue == 25) {
        return colors[1];
    }
    if (attentionValue > 1) {
        return [self blendTwoColors:colors[1] withColor:colors[0] withAlpha:(25-attentionValue)/25];
    }
    return colors[0];
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
