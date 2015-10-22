//
//  SurveyInterfaceController.m
//  Jhana
//
//  Created by Steven Chung on 10/21/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "SurveyInterfaceController.h"

@interface SurveyInterfaceController ()

@end

@implementation SurveyInterfaceController

- (IBAction)attentionValueSelected:(NSInteger)value {
    self.selectedAttentionValue = value;
}

- (IBAction)locationValueSelected:(NSInteger)value {
    self.selectedLocationValue = value;
}

- (IBAction)actionValueSelected:(NSInteger)value {
    self.selectedActionValue = value;
}

- (IBAction)submitButtonClicked {
    NSDictionary *applicationData = @{
                                      @"attentionValue" : self.attentionValues[self.selectedAttentionValue],
                                      @"locationValue" : self.locationValues[self.selectedLocationValue],
                                      @"actionValue" : self.actionValues[self.selectedActionValue]
                                      };

    [[WCSession defaultSession] sendMessage:applicationData
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
    }

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    [super willActivate];
    
    // Activiate session between watch and phone for transferring data
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    self.attentionValues = @[@"Very Attentive", @"Somewhat Attentive", @"Neutral", @"Somewhat Distracted", @"Very Distracted"];
    NSMutableArray *pickerItems = [NSMutableArray array];
    for (int i=0; i<self.attentionValues.count; i++) {
        WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
        pickerItem.title = self.attentionValues[i];
        pickerItems[i] = pickerItem;
    }
    [self.attentionPicker setItems:pickerItems];
    self.selectedAttentionValue = pickerItems.count/2;
    [self.attentionPicker setSelectedItemIndex:self.selectedAttentionValue];

    self.locationValues = @[@"School", @"Work", @"Home"];
    pickerItems = [NSMutableArray array];
    for (int i=0; i<self.locationValues.count; i++) {
        WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
        pickerItem.title = self.locationValues[i];
        pickerItems[i] = pickerItem;
    }
    [self.locationPicker setItems:pickerItems];
    self.selectedLocationValue = 0;
    
    self.actionValues = @[@"Cooking", @"Homework", @"Exercising"];
    pickerItems = [NSMutableArray array];
    for (int i=0; i<self.actionValues.count; i++) {
        WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
        pickerItem.title = self.actionValues[i];
        pickerItems[i] = pickerItem;
    }
    [self.actionPicker setItems:pickerItems];
    self.selectedActionValue = 0;
    
    [self setTitle:nil];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

//- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
//    if ([segueIdentifier isEqualToString:@"])
//}

@end



