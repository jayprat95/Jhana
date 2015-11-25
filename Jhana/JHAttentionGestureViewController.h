//
//  JHAttentionGestureViewController.h
//  Jhana
//
//  Created by Jayanth Prathipati on 11/2/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLocationViewController.h"

@interface JHAttentionGestureViewController : UIViewController 
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableDictionary *applicationData;
- (IBAction)cancelButtonClicked:(id)sender;
@end
