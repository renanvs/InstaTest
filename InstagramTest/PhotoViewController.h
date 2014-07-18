//
//  PhotoViewController.h
//  InstagramTest
//
//  Created by renanvs on 7/16/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UIImageView *image;
}

-(IBAction)takeAPicute:(id)sender;
-(IBAction)selectAPicute:(id)sender;

@end
