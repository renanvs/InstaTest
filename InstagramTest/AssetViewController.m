//
//  AssetViewController.m
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "AssetViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetViewController ()

@end

@implementation AssetViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObservers];
    [[InstaManager sharedInstance] asset];
    assets = [[InstaManager sharedInstance] assetArray];
    // Do any additional setup after loading the view.
}

-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refreshAsset" object:nil];
}

-(void)refresh{
    assets = [[InstaManager sharedInstance] assetArray];
    [table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return assets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"assetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UIImageView *img = (UIImageView*)[cell viewWithTag:0];
    ALAsset *as = [assets objectAtIndex:indexPath.row];
    img.image = [UIImage imageWithCGImage:[as thumbnail]];
    
    return cell;
}



@end
