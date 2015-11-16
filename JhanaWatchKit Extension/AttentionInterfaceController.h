//
//  AttentionInterfaceController.h
//  Jhana
//
//  Created by Steven Chung on 10/22/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface AttentionInterfaceController : WKInterfaceController <WCSessionDelegate>
@property (strong, nonatomic) IBOutlet WKInterfacePicker *attentionPicker;
@property (strong, nonatomic) NSArray *attentionValues;
@property NSInteger selectedAttentionValue;
@property BOOL hasPreviouslyLoaded;
@end
