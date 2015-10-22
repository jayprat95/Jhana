//
//  ActionInterfaceController.h
//  Jhana
//
//  Created by Steven Chung on 10/22/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface ActionInterfaceController : WKInterfaceController <WCSessionDelegate>
@property (strong, nonatomic) IBOutlet WKInterfacePicker *actionPicker;
@property (strong, nonatomic) NSArray *actionValues;
@property NSInteger selectedActionValue;
@property (strong, nonatomic) NSMutableDictionary *applicationData;
@end
