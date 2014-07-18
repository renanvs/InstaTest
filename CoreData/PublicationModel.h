//
//  PublicationModel.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CaptionModel, CommentsModel, ImageModel;

@interface PublicationModel : NSManagedObject

@property (nonatomic, retain) NSString * createdTime;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * likesCount;
@property (nonatomic, retain) CaptionModel *caption;
@property (nonatomic, retain) CommentsModel *comments;
@property (nonatomic, retain) ImageModel *image;

@end
