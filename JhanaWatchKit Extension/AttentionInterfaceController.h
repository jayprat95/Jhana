//
//  AttentionInterfaceController.h
//  Jhana
//
//  Created by Steven Chung on 10/22/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface AttentionInterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfacePicker *attentionPicker;
@property (strong, nonatomic) NSArray *attentionValues;
@property NSInteger selectedAttentionValue;

@end
