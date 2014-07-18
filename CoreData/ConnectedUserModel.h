//
//  ConnectedUserModel.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ConnectedUserModel : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSString * profile_picture;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * username;

@end
