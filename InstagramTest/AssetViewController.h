//
//  AssetViewController.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray *assets;
    IBOutlet UITableView *table;
}


@end
