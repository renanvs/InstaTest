//
//  ViewController.m
//  InstagramTest
//
//  Created by renan veloso silva on 14/07/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"
#import "AssetViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObservers];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AssetViewController *vc = (AssetViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"VCAsset"];
    [[self navigationController] pushViewController:vc animated:YES];
    //[self presentViewController:pvc animated:YES completion:nil];
    //[self performSegueWithIdentifier:@"seguePhoto" sender:bt];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(IBAction)loadInstagram:(id)sender{
    [self addInstaWebView];
}

-(void)addInstaWebView{
    UIWebView *instaWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 250, 350)];
    instaWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=a2bd1d093fc44292918eb03475eed3c8&redirect_uri=http://www.macwingo.com/&response_type=code&scope=basic+likes+comments+relationships"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [instaWebView loadRequest:request];
    
    [self.view addSubview:instaWebView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"www");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = [request.URL absoluteString];
    //NSLog(@"url: %@", urlStr);
    
    if([urlStr isEqualToString:@"about:blank"]){
        [webView removeFromSuperview];
    }
    
    NSRange range = [urlStr rangeOfString:@"http://www.macwingo.com/?code="];
    if (range.length > 0) {
        NSUInteger size = urlStr.length;
        
        NSRange range1 = [urlStr rangeOfString:@"http://www.macwingo.com/?code="];
        NSRange range2 = NSMakeRange(range.length, (size - range1.length));
        NSString *code = [urlStr substringWithRange:range2];
        [[InstaManager sharedInstance] createInstaModelWithCode:code];
        [webView removeFromSuperview];
        return NO;
    }
    
    return YES;
}

-(IBAction)sharePhoto1:(id)sender{
    [self saveToInstagram];
}

-(IBAction)sharePhoto2:(id)sender{
    
}

-(IBAction)sharePhoto3:(id)sender{
    
}


-(void)saveToInstagram{
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"cant open instagram" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        CGRect rect = CGRectMake(0 ,0 , 0, 0);
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/img.igo"];
        
        NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath]];
        
        self.docFile.UTI = @"com.instagram.exclusivegram";
        self.docFile = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
        self.docFile=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
        self.docFile.annotation = [NSDictionary dictionaryWithObject:@"test de tag #bolodecenoura" forKey:@"InstagramCaption"];
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            [self.docFile presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
        }
        else {
            //NSLog(@"No Instagram Found");
        }
        
    }
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instaModelSaved) name:@"InstaModelSaved" object:nil];
}

-(void)instaModelSaved{
    [self performSegueWithIdentifier:@"segueRecentTag" sender:nil];
}

-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSLog(@"segue: %@", identifier);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"dsfsd");
}

@end
