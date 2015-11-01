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

#import <CoreData/CoreData.h>

@interface JHListViewController () <NSFetchedResultsControllerDelegate, WCSessionDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property BOOL editing;

@end

@implementation JHListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editing = false;
    [self.editButton setTitle:@"Edit"];
    
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
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
    
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
    }
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveEntry:) name:@"SaveData" object:nil];
    
    [self createLocalNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveEntry:(NSNotification *) notification {
    // Create Entity
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
    
    // Save Record
    NSError *error = nil;
    
     if ([self.managedObjectContext save:&error]) {
         [self.tableView reloadData]; 
     }
}


- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    // Create Entity
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JHReport" inManagedObjectContext:self.managedObjectContext];
    
    // Initialize Record
    NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    
    // Populate Record
    [record setValue:message[@"actionValue"] forKey:@"activity"];
    [record setValue:@"Foo Bar" forKey:@"annotation"];
    [record setValue:[NSNumber numberWithInt:10] forKey:@"attention"];
    [record setValue:[NSDate date] forKey:@"createdAt"];
    [record setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save Record
    NSError *error = nil;
    if ([self.managedObjectContext save:&error]) {
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
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
    NSDate *itemDate = [NSDate date];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [itemDate dateByAddingTimeInterval:10];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = @"Are you focused? Check how attentive you are!";
    localNotif.alertAction = @"Log an Entry";
    localNotif.alertTitle = @"Jhana";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
//    localNotif.userInfo = @{@"UDID" : };
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
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
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
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
    NSDate *timeStamp = [record valueForKey:@"timeStamp"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    [cell.timeLabel setText:[dateFormatter stringFromDate:timeStamp]];
    NSNumber *attention = [record valueForKey:@"attention"];
    if ([attention isEqualToNumber:@0]) {
        [cell.attentionLabel setText:@"Very Distracted"];
    } else if ([attention isEqualToNumber:@1]) {
        [cell.attentionLabel setText:@"Somewhat Distracted"];
    } else if ([attention isEqualToNumber:@2]) {
        [cell.attentionLabel setText:@"Neutral"];
    } else if ([attention isEqualToNumber:@3]) {
        [cell.attentionLabel setText:@"Somewhat Attentive"];
    } else {
        [cell.attentionLabel setText:@"Very Attentive"];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



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

@end
