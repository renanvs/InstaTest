//
//  CommentsModel.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CommentModel, PublicationModel;

@interface CommentsModel : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSSet *list;
@property (nonatomic, retain) PublicationModel *publication;
@end

@interface CommentsModel (CoreDataGeneratedAccessors)

- (void)addListObject:(CommentModel *)value;
- (void)removeListObject:(CommentModel *)value;
- (void)addList:(NSSet *)values;
- (void)removeList:(NSSet *)values;

@end
