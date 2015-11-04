//
//  JHDetailViewProtocol.h
//  Jhana
//
//  Created by Steven Chung on 11/3/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JHDetailViewProtocol <NSObject>
@required
- (void)changeLocation:(NSString *)newLocation;
- (void)changeActivity:(NSString *)newActivity;
- (void)changePerson:(NSString *)newPerson;
@end

@interface JHDetailViewProtocol : NSObject
@end
