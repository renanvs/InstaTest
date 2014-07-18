//
//  ViewController.h
//  InstagramTest
//
//  Created by renan veloso silva on 14/07/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UIDocumentInteractionControllerDelegate>

@property(nonatomic,retain)UIDocumentInteractionController *docFile; 

-(IBAction)loadInstagram:(id)sender;

-(IBAction)sharePhoto1:(id)sender;
-(IBAction)sharePhoto2:(id)sender;
-(IBAction)sharePhoto3:(id)sender;

@end
