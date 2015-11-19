//
//  AppDelegate.m
//  Jhana
//
//  Created by Jayanth Prathipati on 10/7/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import "OnboardingViewController.h"
#import "TPTabBarController.h"

static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";
static NSString * const kUserID = @"user_id";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    // Override point for customization after application launch.
    [Flurry startSession:@"2WRXHZNGKJXSCM86D9WZ"];
    
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    if (!userHasOnboarded) {
        self.window.rootViewController = [self generateOnboardViewController];
    }
    return YES;
}

- (OnboardingViewController *)generateOnboardViewController {
    UIImage *image = [UIImage imageNamed:@"jhana_onboarding_1"];
    UIImage *brain = [UIImage imageNamed:@"brain_icon"];
    UIImage *color = [UIImage imageNamed:@"color_scale"];
    UIImage *watch = [UIImage imageNamed:@"watch_icon"];
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Welcome to Jhana!" body:@"Journal. Reflect. Analyze." image:brain buttonText:@"" action:nil];
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:kUserID];
    if (!userID) {
        firstPage.viewDidAppearBlock = ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Enter User ID..." message:@"If you are seeing this as a participant of the study, please contact the researcher responsible for the study." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
                NSString *userID = ((UITextField *)[alert.textFields objectAtIndex:0]).text;
                [[NSUserDefaults standardUserDefaults] setValue:userID forKey:kUserID];
            }];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Enter User ID Here";
            }];
            [alert addAction:enterAction];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        };
    }
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"Survey With Jhana" body:@"Jhana helps you find trends within your focus" image:nil buttonText:@"" action:nil];
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Colors help" body:@"Use Colors to identify your focus" image:color buttonText:@"" action:nil];
    OnboardingContentViewController *fourthPage = [OnboardingContentViewController contentWithTitle:@"Have an Apple Watch?" body:@"Install the Apple Watch app to make fast Reports!" image:watch buttonText:@"" action:nil];
    OnboardingContentViewController *fifthPage = [OnboardingContentViewController contentWithTitle:@"Please enable Notifications" body:@"Get a better overall view on your day with reminders to fill out surveys" image:nil buttonText:@"" action:nil];
    
    OnboardingContentViewController *sixthPage = [OnboardingContentViewController contentWithTitle:@"Ready?" body:@"" image:nil buttonText:@"" action:nil];
    
    sixthPage.viewDidAppearBlock = ^{
        // Register device for local push notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    };
    

    
    OnboardingContentViewController *seventhPage = [OnboardingContentViewController contentWithTitle:@"" body:@"Let's get started!!" image:nil buttonText:@"Click Here" action:^{
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TPTabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            self.window.rootViewController = tabBarController;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    }];
    
    

    
    OnboardingViewController *onboardViewController = [OnboardingViewController onboardWithBackgroundImage:image contents:@[firstPage, secondPage, thirdPage, fourthPage, fifthPage, sixthPage, seventhPage]];
    onboardViewController.shouldFadeTransitions = YES;
    onboardViewController.fadePageControlOnLastPage = YES;
    onboardViewController.fadeSkipButtonOnLastPage = YES;
    onboardViewController.shouldMaskBackground = NO;

    onboardViewController.fontName = @"Avenir-Black";
    onboardViewController.bodyFontSize = 25;
    return onboardViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:kUserID];
    [Flurry logEvent:[NSString stringWithFormat:@"%@-Notification_Received", userID]];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler  {
    if ([identifier isEqualToString:@"ACTION_MUTE"]) {
        NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:kUserID];
        [Flurry logEvent:[NSString stringWithFormat:@"%@-Notification_Muted", userID]];
        NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSDate *date = [NSDate date];
        NSDate *dateHourAhead = [date dateByAddingTimeInterval:60*60];
        for (int i=0; i<scheduledNotifications.count; i++) {
            if (i > 2) {
                // No need to look past 2 notifications since they're scheduled for 30 min intervals
                break;
            }
            UILocalNotification *notification = scheduledNotifications[i];
            if ([notification.fireDate compare:dateHourAhead] == NSOrderedAscending) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
    completionHandler(UIBackgroundFetchResultNoData);
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.TT.Jhana" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Jhana" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Jhana.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
