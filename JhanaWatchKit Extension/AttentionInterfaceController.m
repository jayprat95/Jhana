//
//  AttentionInterfaceController.m
//  Jhana
//
//  Created by Steven Chung on 10/22/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "AttentionInterfaceController.h"

@interface AttentionInterfaceController ()

@end

@implementation AttentionInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
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
    self.attentionValues = @[@"veryUnfocused", @"unfocused"];
    NSMutableArray *pickerItems = [NSMutableArray array];
    for (int i=0; i<self.attentionValues.count; i++) {
        WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
//        pickerItem.title = self.attentionValues[i];
        WKImage *image = [WKImage imageWithImageName:self.attentionValues[i]];
        pickerItem.contentImage = image;
        pickerItems[i] = pickerItem;
    }
    [self.attentionPicker setItems:pickerItems];
    [self.attentionPicker setSelectedItemIndex:self.selectedAttentionValue];
    [self.attentionPicker focus]; 
}

- (IBAction)attentionValueSelected:(NSInteger)value {
    self.selectedAttentionValue = value;
}

- (IBAction)cancelButtonPressed {
    [self popToRootController];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:@"attention"]) {
        NSMutableDictionary *applicationData = [NSMutableDictionary dictionary];
        applicationData[@"attentionValue"] = [NSNumber numberWithInt:self.selectedAttentionValue];
        return applicationData;
    }
    return nil;
}

@end



