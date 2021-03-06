//
//  LocationInterfaceController.m
//  Jhana
//
//  Created by Steven Chung on 10/22/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "LocationInterfaceController.h"

@interface LocationInterfaceController ()

@end

@implementation LocationInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    self.applicationData = context;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self setUpPicker];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)setUpPicker {
    self.locationValues = @[@"Work", @"School", @"Home", @"Restaurant", @"Coffee Shop", @"Bar/Pub", @"Store", @"Outside", @"Hotel/Lodging", @"Friend's House", @"Other"];
    NSMutableArray *pickerItems = [NSMutableArray array];
    for (int i=0; i<self.locationValues.count; i++) {
        WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
        pickerItem.title = self.locationValues[i];
        pickerItems[i] = pickerItem;
    }
    [self.locationPicker setItems:pickerItems];
        [self.locationPicker focus];
}

- (IBAction)locationValueSelected:(NSInteger)value {
    self.selectedLocationValue = value;
    [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeClick];
}

- (IBAction)cancelButtonClicked {
    [self popToRootController];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:@"location"]) {
        self.applicationData[@"location"] = self.locationValues[self.selectedLocationValue];
        return self.applicationData;
    }
    return nil;
}

@end



