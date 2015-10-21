//
//  JHListViewController.m
//  Jhana
//
//  Created by Jayanth Prathipati on 10/7/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHListViewController.h"
#import "AppDelegate.h"
#import <WatchConnectivity/WatchConnectivity.h>

#import <CoreData/CoreData.h>

@interface JHListViewController () <NSFetchedResultsControllerDelegate, WCSessionDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation JHListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonClicked:(id)sender {
    // Create Entity
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JHReport" inManagedObjectContext:self.managedObjectContext];
    
    // Initialize Record
    NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    
    // Populate Record
    [record setValue:@"running" forKey:@"activity"];
    [record setValue:@"Foo Bar" forKey:@"annotation"];
    [record setValue:[NSNumber numberWithInt:10] forKey:@"attention"];
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



#pragma mark -
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
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
//        case NSFetchedResultsChangeDelete: {
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        }
//        case NSFetchedResultsChangeUpdate: {
//            [self configureCell:(TSPToDoCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//        }
//        case NSFetchedResultsChangeMove: {
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHCell" forIndexPath:indexPath];
    
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:[record valueForKey:@"activity"]]; 
    
    
    return cell;
}

@end
