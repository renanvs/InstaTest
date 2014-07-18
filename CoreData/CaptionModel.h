//
//  CaptionModel.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PublicationModel, UserModel;

@interface CaptionModel : NSManagedObject

@property (nonatomic, retain) NSString * createdTime;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) UserModel *user;
@property (nonatomic, retain) PublicationModel *publication;

@end
