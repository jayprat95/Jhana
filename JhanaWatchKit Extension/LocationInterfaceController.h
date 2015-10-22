//
//  LocationInterfaceController.h
//  Jhana
//
//  Created by Steven Chung on 10/22/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface LocationInterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfacePicker *locationPicker;
@property (strong, nonatomic) NSArray *locationValues;
@property NSInteger selectedLocationValue;
@property (strong, nonatomic) NSMutableDictionary *applicationData;
@end
