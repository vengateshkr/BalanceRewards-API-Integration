//
//  ViewController.m
//  BRApiSample
//
//  Created by ctsuser1 on 3/25/16.
//  Copyright © 2016 ctsuser1. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "ActivityViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    NSString * redirectUri;
    NSString * accessToken;
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel *loginLbl;
@property (weak, nonatomic) IBOutlet UILabel *tknLbl;
@property (weak, nonatomic) IBOutlet UILabel *actvtyLbl;
@property (weak, nonatomic) IBOutlet UILabel *brLbl;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *tokenView;
@property (weak, nonatomic) IBOutlet UIView *postActView;
@property (weak, nonatomic) IBOutlet UIView *getbrView;

@end
@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.loginLbl.text = @"✖️";
    self.tknLbl.text = @"✖️";
    self.actvtyLbl.text = @"✖️";
    self.brLbl.text = @"✖️";
    
    self.tokenView.hidden = YES;
    self.postActView.hidden = YES;
    self.getbrView.hidden = YES;
    
    appDelegate = [UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([appDelegate.loginSuccess isEqualToString:@"pass"]) {
        self.loginLbl.text = @"✔️";
        self.tokenView.hidden = NO;
        appDelegate.loginSuccess = @"fail";
    }
    if ([appDelegate.activitySuccess isEqualToString:@"pass"]) {
        self.actvtyLbl.text = @"✔️";
        self.getbrView.hidden = NO;
        appDelegate.activitySuccess = @"fail";
    }
}

- (IBAction)getAccessToken:(id)sender {
    
    NSString * clienId = CLIENT_ID;
    redirectUri  = REDIRECT_URI;
    NSString * channel = CHANNEL;
    NSString * transID = TRANSACTION_ID;
    NSString * state = STATE;
    NSString * client_secret = CLIENT_SECRET_KEY;
    
    NSString *auth_Code  = [[NSUserDefaults standardUserDefaults] valueForKey:@"code"];
    
    NSString *requestStr = [NSString stringWithFormat:@"grant_type=authorization_code&act=getOAuthToken&client_id=%@&client_secret=%@&code=%@&redirect_uri=%@&channel=%@&transaction_id=%@&state=%@",clienId,client_secret,auth_Code,redirectUri,channel,transID,state];
    
    NSURL *url = [NSURL URLWithString:@"https://services-qa.walgreens.com/api/oauthtoken/v1"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *jsonData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString
                       stringWithFormat:@"%lu",(unsigned long)[requestStr length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        if (!error && ![dict objectForKey:@"error"] ) {
            accessToken = [dict objectForKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"access_token"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tknLbl.text = @"✔️";
                self.postActView.hidden = NO;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                self.tknLbl.text = @"✖️";
            });
        }
    }
];
    
    NSLog(@"%@", requestStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getBRPoints:(id)sender {
    
    NSString * clienId = CLIENT_ID;
    NSString * transID = TRANSACTION_ID;
    NSString * client_secret = CLIENT_SECRET_KEY;
    
    NSString *urlStr =[NSString stringWithFormat:@"https://services-qa.walgreens.com/api/steps/brpoints/v1?apiKey=%@",client_secret];
    
    NSString *requestStr =[NSString stringWithFormat:@"{\r\n\"access_token\":\"%@\",\r\n\"affiliate_id\":\"%@\",\r\n\"act\":\"getBRPoints\",\r\n\"transaction_id\":\"%@\"\r\n}",accessToken,clienId,transID];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //    NSData *jsonData = [requestStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *jsonData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString
                       stringWithFormat:@"%lu",(unsigned long)[requestStr length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
        
        
        if (!error && [dict objectForKey:@"total_rewards_points"] != NULL  && [dict objectForKey:@"healthy_choice_points"] != NULL ) {
            
            NSString *pointStr = [NSString stringWithFormat:@"Your health choice points is %@ \n Your total rewards points is %@",[dict objectForKey:@"healthy_choice_points"],[dict objectForKey:@"total_rewards_points"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:pointStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.delegate = self;
                alertView.tag = 401;
                [alertView show];
                self.tknLbl.text = @"✔️";
                self.postActView.hidden = NO;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You dont have points. Kindly post your activities." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alertView.delegate = self;
                alertView.tag = 402;
                [alertView show];
                self.tknLbl.text = @"✖️";
            });
        }
    }
     ];
}

- (IBAction)postActivity:(id)sender {
    
    [self performSegueWithIdentifier:@"toPostVC" sender:sender];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 401) {
        self.brLbl.text = @"✔️";
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
