//
//  ActionInterfaceController.m
//  Jhana
//
//  Created by Steven Chung on 10/22/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "ActionInterfaceController.h"

@interface ActionInterfaceController ()

@end

@implementation ActionInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    self.applicationData = context;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self setUpPicker];
    // Activiate session between watch and phone for transferring data
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)setUpPicker {
    self.actionValues = @[@"Eating", @"Watching TV", @"Reading", @"Working", @"Travelling", @"Talking", @"Using Technology", @"Exercising", @"Errands", @"Other"];
    NSMutableArray *pickerItems = [NSMutableArray array];
    for (int i=0; i<self.actionValues.count; i++) {
        WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
        pickerItem.title = self.actionValues[i];
        pickerItems[i] = pickerItem;
    }
    [self.actionPicker setItems:pickerItems];
    [self.actionPicker focus]; 
}

- (IBAction)submitButtonClicked {
    self.applicationData[@"activity"] = self.actionValues[self.selectedActionValue];
    [[WCSession defaultSession] sendMessage:self.applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                               }
     ];
    WKAlertAction *action = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleCancel handler:^{
        [self popToRootController];
    }];
    [self presentAlertControllerWithTitle:@"Hooray!" message:@"Thanks for filling out this survey." preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
    [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeSuccess];
}

- (IBAction)actionValueSelected:(NSInteger)value {
    self.selectedActionValue = value;
    [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeClick];
}


- (IBAction)cancelButtonClicked {
    [self popToRootController];
}

@end



