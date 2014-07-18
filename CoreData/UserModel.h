//
//  UserModel.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CaptionModel, CommentModel;

@interface UserModel : NSManagedObject

@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * identier;
@property (nonatomic, retain) NSString * profilePicture;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) CaptionModel *caption;
@property (nonatomic, retain) CommentModel *comment;

@end
