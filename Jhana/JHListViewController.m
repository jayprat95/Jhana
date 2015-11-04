//
//  JHListViewController.m
//  Jhana
//
//  Created by Jayanth Prathipati on 10/7/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHListViewController.h"
#import "JHTableViewCell.h"
#import "AppDelegate.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "Flurry.h"
#import "UIColor+BFPaperColors.h"
#import "UIScrollView+EmptyDataSet.h"
#import <CoreData/CoreData.h>

@interface JHListViewController () <NSFetchedResultsControllerDelegate, WCSessionDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property BOOL editing;

@end

@implementation JHListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editing = false;
    [self.editButton setTitle:@"Edit"];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JHTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHCell"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"JHReport"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {
//        NSMutableArray *sections = [NSMutableArray array];
//        for (id<NSFetchedResultsSectionInfo> sectionInfo in self.fetchedResultsController.sections) {
//            
//        }
    }
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveEntry:) name:@"SaveData" object:nil];
    
    [self createLocalNotifications];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveEntry:(NSNotification *) notification {
    // Create Entity
    if (notification != nil && [notification.object isKindOfClass:[NSMutableDictionary class]]) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"JHReport" inManagedObjectContext:self.managedObjectContext];
        
        // Initialize Record
        NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    
        NSMutableDictionary *applicationData = notification.object;
        
        // Populate Record
        [record setValue:applicationData[@"activity"] forKey:@"activity"];
        [record setValue:applicationData[@"attention"] forKey:@"attention"];
        [record setValue:applicationData[@"location"] forKey:@"location"];
        [record setValue:applicationData[@"isAlone"] forKey:@"isAlone"];
        [record setValue:applicationData[@"person"] forKey:@"person"];
        [record setValue:[NSDate date] forKey:@"createdAt"];
        [record setValue:[NSDate date] forKey:@"timeStamp"];
    }
    
    // Save Record
    NSError *error = nil;
    
     if ([self.managedObjectContext save:&error]) {
         [self.tableView reloadEmptyDataSet];
         [self.tableView reloadData];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshGraph" object:self];
     }
}

- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    // Create Entity
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JHReport" inManagedObjectContext:self.managedObjectContext];
    
    // Initialize Record
    NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    
    // Populate Record
    [record setValue:message[@"activity"] forKey:@"activity"];
    [record setValue:message[@"attention"] forKey:@"attention"];
    [record setValue:message[@"location"] forKey:@"location"];
    [record setValue:message[@"isAlone"] forKey:@"isAlone"];
    [record setValue:message[@"person"] forKey:@"person"];
    [record setValue:[NSDate date] forKey:@"createdAt"];
    [record setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save Record
    NSError *error = nil;
    if ([self.managedObjectContext save:&error]) {
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadEmptyDataSet];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshGraph" object:self];
        });
    }
}

- (IBAction)editButtonClicked:(id)sender {
    if (self.editing == true)
    {
        [self.tableView setEditing:NO animated:YES];
        self.editing = false;
        [self.editButton setTitle:NSLocalizedString(@"Edit", @"Edit")];
        NSLog(@"Cancel");
    }
    else
    {
        [self.tableView setEditing:YES animated:YES];
        [self.editButton setTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        self.editing = true;
        NSLog(@"Add");

    }
}
- (void)createLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDate *itemDate = [NSDate date];
    
    // The local notification queue has a maximum capacity of 64
    for (int i=0; i<64; i++) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        localNotif.fireDate = [itemDate dateByAddingTimeInterval:1800*i];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:localNotif.fireDate];
        NSInteger hour = [components hour];
        if (hour < 8 || hour > 22) {
            // Don't schedule notifications between 10 PM to 8 AM
            continue;
        }
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotif.alertBody = @"Are you focused? Check how attentive you are!";
        localNotif.alertAction = @"Log an Entry";
        localNotif.alertTitle = @"Jhana";
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
}

#pragma mark Fetched Results Controller Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
//                [self configureCell:(TSPToDoCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshGraph" object:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Test";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JHTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.activityLabel setText:[record valueForKey:@"activity"]];
    [cell.locationLabel setText:[record valueForKey:@"location"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm\na"];
    NSString *startTimeString = [formatter stringFromDate:[record valueForKey:@"timeStamp"]];
    formatter.dateFormat = @"MM/dd/yy";
    
    NSString *dateString = [formatter stringFromDate: [record valueForKey:@"timeStamp"]];
    
    switch ([[record valueForKey:@"attention"] intValue])
    {
        case 0:
            [cell.attentionLabel setText:@"Very Unfocused"];
            [cell setBackgroundColor:[UIColor paperColorPurple800]];
            break;
        case 1:
            [cell.attentionLabel setText:@"Unfocused"];
            [cell setBackgroundColor:[UIColor paperColorIndigo]];
            break;
        case 2:
            [cell.attentionLabel setText:@"Neutral"];
            [cell setBackgroundColor:[UIColor paperColorTeal]];
            break;
        case 3:
            [cell.attentionLabel setText:@"Focused"];
            [cell setBackgroundColor:[UIColor paperColorLightGreen]];
            break;
        case 4:
            [cell.attentionLabel setText:@"Very Unfocused"];
            [cell setBackgroundColor:[UIColor paperColorOrange]];
            break;
            
    }
    
    [cell.attentionLabel setTextColor: [UIColor whiteColor]];
    [cell.activityLabel setTextColor: [UIColor whiteColor]];
    [cell.timeLabel setTextColor: [UIColor whiteColor]];
    [cell.locationLabel setTextColor: [UIColor whiteColor]];
    [cell.dateLabel setTextColor:[UIColor whiteColor]];
    
    [cell.activityLabel setText:[record valueForKey:@"activity"]];
    [cell.locationLabel setText:[record valueForKey:@"location"]];
    [cell.timeLabel setText:startTimeString];
    [cell.dateLabel setText:dateString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 133;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (record) {
            [Flurry logEvent:@"Deleted Report"];
            [self.fetchedResultsController.managedObjectContext deleteObject:record];
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Couldn't save: %@", error);
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        JHDetailViewController *detailViewController = (JHDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        NSManagedObjectModel *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        detailViewController.detailContext = record;
    }
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
    return [UIImage imageNamed:@"empty"];
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


#pragma mark - DZNEmptyDataSetSource Methods

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
    NSLog(@"%s",__FUNCTION__);
}

@end
