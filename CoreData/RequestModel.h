//
//  RequestModel.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RequestModel : NSManagedObject

@property (nonatomic, retain) NSString * remain;
@property (nonatomic, retain) NSString * total;

@end
