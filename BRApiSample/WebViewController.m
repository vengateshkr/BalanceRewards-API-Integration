//
//  WebViewController.m
//  BRApiSample
//
//  Created by ctsuser1 on 4/2/16.
//  Copyright © 2016 ctsuser1. All rights reserved.
//

#import "WebViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface WebViewController ()
{
 
  NSString * redirectUri;
  AppDelegate *appDelegate;

}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backActn:(id)sender;

@end

@implementation WebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    appDelegate = [UIApplication sharedApplication].delegate;

 //Loading the authorize jsp
    
    NSString * clienId = CLIENT_ID;
    redirectUri  = REDIRECT_URI;
    NSString * channel = CHANNEL;
    NSString * transID = TRANSACTION_ID;
    NSString * state = STATE;
    
    NSString *str = [NSString stringWithFormat:@"https://m-qa2.walgreens.com/oauth/authorize.jsp?client_id=%@&response_type=code&redirect_uri=%@&scope=steps&channel=%@&transaction_id=%@&state=%@",clienId,redirectUri,channel,transID,state];
    
    NSURL *url = [NSURL URLWithString: str];
    NSURLRequest *urlReq  = [ NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlReq];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString * str = [request.URL absoluteString];

    if ( [str containsString:redirectUri] && [str containsString:@"error="]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Login failed.Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        appDelegate.loginSuccess = @"fail";

        [alertView show];
        
    }
    else if([str containsString:redirectUri] && [str containsString:@"code="])
    {
        
        NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
        NSArray *arr = [str componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in arr)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            [queryStringDictionary setObject:value forKey:key];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:[queryStringDictionary objectForKey:@"code"] forKey:@"code"];
        [self dismissViewControllerAnimated:YES completion:nil];
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Login successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 101;
        appDelegate.loginSuccess = @"pass";
        [alertView show];
        
    }
    return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)backActn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil ];
}
@end
