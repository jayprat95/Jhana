//
//  SurveyInterfaceController.h
//  Jhana
//
//  Created by Steven Chung on 10/21/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface SurveyInterfaceController : WKInterfaceController <WCSessionDelegate>
@property (strong, nonatomic) IBOutlet WKInterfacePicker *attentionPicker;
@property (strong, nonatomic) IBOutlet WKInterfacePicker *locationPicker;
@property (strong, nonatomic) IBOutlet WKInterfacePicker *actionPicker;

@property (strong, nonatomic) NSArray *attentionValues;
@property NSInteger selectedAttentionValue;
@property (strong, nonatomic) NSArray *locationValues;
@property NSInteger selectedLocationValue;
@property (strong, nonatomic) NSArray *actionValues;
@property NSInteger selectedActionValue;
@end
