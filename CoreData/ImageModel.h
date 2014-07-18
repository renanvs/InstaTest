//
//  ImageModel.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PublicationModel;

@interface ImageModel : NSManagedObject

@property (nonatomic, retain) NSString * lowResUrl;
@property (nonatomic, retain) NSNumber * lowWidth;
@property (nonatomic, retain) NSNumber * lowHeight;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSNumber * thumbnailWidth;
@property (nonatomic, retain) NSNumber * thumbnailHeight;
@property (nonatomic, retain) NSString * standardResolutionUrl;
@property (nonatomic, retain) NSNumber * standardResolutionWidth;
@property (nonatomic, retain) NSNumber * standardResolutionHeight;
@property (nonatomic, retain) PublicationModel *publication;

@end
