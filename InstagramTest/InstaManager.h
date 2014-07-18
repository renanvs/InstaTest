//
//  InstaManager.h
//  InstagramTest
//
//  Created by renanvs on 7/15/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface InstaManager : NSObject{
    NSString *mainCode;
    NSManagedObjectContext *ctx;
    NSArray *assetArray;
}

@property (strong, nonatomic) NSArray *assetArray;

+(id)sharedInstance;

-(void)createInstaModelWithCode:(NSString*)code;

+(ALAssetsLibrary *)defaultAssetsLibrary;

-(void)asset;

@end
