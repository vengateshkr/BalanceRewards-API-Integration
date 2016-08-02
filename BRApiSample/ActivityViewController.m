//
//  ActivityViewController.m
//  BRApiSample
//
//  Created by ctsuser1 on 4/12/16.
//  Copyright © 2016 ctsuser1. All rights reserved.
//



#import "ActivityViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface ActivityViewController ()

{
    NSDateFormatter *DateFormatter;
    AppDelegate *appDelegate;
    NSString *walkTime;
    NSString *walkSteps;
    NSUserDefaults *defaults;
    int updateSteps;
    int updateWalkDist;
    int updateWalkTime;
    int updateWalkSteps;
}

@property (weak, nonatomic) IBOutlet UIButton *walkBtn;
@property (weak, nonatomic) IBOutlet UIButton *stepsBtn;
@property (weak, nonatomic) IBOutlet UIButton *genExBtn;
@property (weak, nonatomic) IBOutlet UITextField *stepsTextFld;
@property (weak, nonatomic) IBOutlet UITextField *walkTimeTextFld;
@property (weak, nonatomic) IBOutlet UITextField *walkDistTextFld;
@property (weak, nonatomic) IBOutlet UITextField *walkStepsTextFld;
@property (weak, nonatomic) IBOutlet UITextField *genexTimeTextFld;
@property (weak, nonatomic) IBOutlet UITextField *bldGlcTextFld;
@property (weak, nonatomic)  NSString *activityFlag;

@end

@implementation ActivityViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Post Activities";
    DateFormatter =[[NSDateFormatter alloc]init];
    appDelegate = [UIApplication sharedApplication].delegate ;
    
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *stepsCreateDate = [defaults objectForKey:@"stepscreatedate"];
    NSString *walkCreateDate = [defaults objectForKey:@"walkcreatedate"];
    NSString *genExCreateDate = [defaults objectForKey:@"genxcreatedate"];

    NSDate *date = [NSDate date];
    [DateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString * currentDateStr = [DateFormatter stringFromDate:date];
    
    
    if ( [currentDateStr isEqualToString:stepsCreateDate] ) {
        [self.stepsBtn setTitle:@"Update" forState:UIControlStateNormal];
    }
    else
    {
        [self.stepsBtn setTitle:@"Create" forState:UIControlStateNormal];
        [defaults setInteger:0 forKey:@"steps"];
        [defaults synchronize];
    }
    if ( [currentDateStr isEqualToString:walkCreateDate] ) {
        [self.walkBtn setTitle:@"Update" forState:UIControlStateNormal];
    }
    else
    {
        [self.walkBtn setTitle:@"Create" forState:UIControlStateNormal];
        [defaults setInteger:0 forKey:@"walkdistvalue"];
        [defaults setInteger:0 forKey:@"walktimevalue"];
        [defaults setInteger:0 forKey:@"walkstepsvalue"];
        [defaults synchronize];
    }
    
    if ( [currentDateStr isEqualToString:genExCreateDate] ) {
        [self.genExBtn setHidden:YES];
    }
    else
    {
        [self.genExBtn setHidden:NO];
    }

    // [btn setTitle:@"update" forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)stepsPost:(id)sender {
    
    NSString * postStr;
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [DateFormatter stringFromDate:[NSDate date]];
    
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:s"];
    NSString *timestamp = [DateFormatter stringFromDate:[NSDate date]];
    
    UIButton *btn = (UIButton*)sender;
    
    if (btn.tag == 1001 ) {
        
        if ([btn.titleLabel.text isEqualToString:@"Create"]) {
            
            self.activityFlag = @"stepscreate";
            
            [btn setTitle:@"Update" forState:UIControlStateNormal];
            
            [self saveStepsDefaults];
            
            postStr =   [NSString stringWithFormat:@"{\r\n \"creates\":[\r\n     {\r\n     \"access_token\":\"%@\",\r\n     \"affiliate_id\":\"%@\",\r\n     \"transaction_id\":\"%@\",\r\n     \"date\":\"%@\",\r\n     \"user_device_id\":\"1234\",\r\n     \"manufacturer_name\":\"Wag\",\r\n     \"device_name\":\"WalgreensTest\",\r\n     \"data\":[\r\n     {\r\n     \"id\":\"ABCxNS0wOC0yNiAyMzowNTo1OTNHUHRqVzVSQlFrME1QRWo3Y3V2WHJCVXZX\",\r\n     \"type\":\"total_steps\",\r\n     \"value\":%@,\r\n     \"device_tracked\":\"false\",\r\n     \"timestamp\":\"%@\"\r\n     }]\r\n     }]\r\n     }",accessToken,CLIENT_ID,TRANSACTION_ID,dateString,self.stepsTextFld.text,timestamp];
        }
        
        if ([btn.titleLabel.text isEqualToString:@"Update"])
        {
            self.activityFlag = @"stepsupdate";
            
             defaults = [NSUserDefaults standardUserDefaults];
            updateSteps = (int)[defaults integerForKey:@"steps"];
            if (updateSteps > 0 ) {
                updateSteps = [self.stepsTextFld.text intValue] + updateSteps ;
                [defaults setInteger:updateSteps forKey:@"steps"];
                [defaults synchronize];
                
                postStr =  [NSString stringWithFormat:@"{\r\n \"updates\":[\r\n     {\r\n     \"access_token\":\"%@\",\r\n     \"affiliate_id\":\"%@\",\r\n     \"transaction_id\":\"%@\",\r\n     \"date\":\"%@\",\r\n     \"user_device_id\":\"1234\",\r\n     \"manufacturer_name\":\"Wag\",\r\n     \"device_name\":\"WalgreensTest\",\r\n     \"data\":[\r\n     {\r\n     \"id\":\"ABCxNS0wOC0yNiAyMzowNTo1OTNHUHRqVzVSQlFrME1QRWo3Y3V2WHJCVXZX\",\r\n     \"type\":\"total_steps\",\r\n     \"value\":%@,\r\n     \"device_tracked\":\"false\",\r\n     \"timestamp\":\"%@\"\r\n     }]\r\n     }]\r\n     }",accessToken,CLIENT_ID,TRANSACTION_ID,dateString,[NSString stringWithFormat:@"%i",updateSteps],timestamp];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Steps activity not created yet. Please do the create." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                });
            }
        }
        
        
    }
    else if (btn.tag == 1002)
    {
        walkTime = self.walkTimeTextFld.text ;
        walkSteps = self.walkStepsTextFld.text;
        
        if ([self.walkDistTextFld.text length] > 0 ) {
            
            if ( [walkTime length] == 0 && [walkSteps length] == 0) {
                
                walkTime =  [NSString stringWithFormat:@"%i",[self.walkDistTextFld.text intValue] * 600];
                walkSteps =  [NSString stringWithFormat:@"%i",[self.walkDistTextFld.text intValue] * 2000];
                
            }
            
            if ([btn.titleLabel.text isEqualToString:@"Create"]) {
                self.activityFlag = @"walkcreate";
                
                [btn setTitle:@"Update" forState:UIControlStateNormal];
                
                [self saveWalkDefaults];
                
                postStr =   [NSString stringWithFormat:@"{\r\n    \"creates\":[\r\n    {\r\n        \"access_token\":\"%@\",\r\n        \"affiliate_id\":\"%@\",\r\n        \"transaction_id\":\"%@\",\r\n        \"date\":\"%@\",\r\n        \"user_device_id\":\"1234\",\r\n        \"manufacturer_name\":\"test\",\r\n        \"device_name\":\"Test\",\r\n        \"data\":[\r\n        {\r\n            \"id\":\"GHIxNS0wOC0yNiAyMzowNTo1OTNHUHRqVzVSQlFrME1QRWo3Y3V2WHJCVXZX\",\r\n            \"type\":\"walking\",\r\n            \"value\":{\r\n                \"duration\":%@,\r\n                \"distance\":%@,\r\n                \"steps\":%@\r\n            },\r\n            \"device_tracked\":\"false\",\r\n            \"timestamp\":\"%@\"\r\n        }]\r\n    }]\r\n}",accessToken,CLIENT_ID,TRANSACTION_ID,dateString,walkTime,self.walkDistTextFld.text,walkSteps,timestamp];
            }
            if ([btn.titleLabel.text isEqualToString:@"Update"])
            {
                self.activityFlag = @"walkupdate";
                
                 defaults = [NSUserDefaults standardUserDefaults];
                updateWalkDist = (int)[defaults integerForKey:@"walkdistvalue"];
                updateWalkTime = (int)[defaults integerForKey:@"walktimevalue"];
                updateWalkSteps = (int)[defaults integerForKey:@"walkstepsvalue"];
                
                if (updateWalkDist > 0 && updateWalkTime > 0 && updateWalkSteps > 0) {
                    updateWalkDist = [self.walkDistTextFld.text intValue] + updateWalkDist ;
                    updateWalkTime = [walkTime intValue] + updateWalkTime ;
                    updateWalkSteps = [walkSteps intValue] + updateWalkSteps ;
                    [defaults synchronize];
                    
                    
                    postStr =   [NSString stringWithFormat:@"{\r\n    \"updates\":[\r\n    {\r\n        \"access_token\":\"%@\",\r\n        \"affiliate_id\":\"%@\",\r\n        \"transaction_id\":\"%@\",\r\n        \"date\":\"%@\",\r\n        \"user_device_id\":\"1234\",\r\n        \"manufacturer_name\":\"test\",\r\n        \"device_name\":\"Test\",\r\n        \"data\":[\r\n        {\r\n            \"id\":\"GHIxNS0wOC0yNiAyMzowNTo1OTNHUHRqVzVSQlFrME1QRWo3Y3V2WHJCVXZX\",\r\n            \"type\":\"walking\",\r\n            \"value\":{\r\n                \"duration\":%@,\r\n                \"distance\":%@,\r\n                \"steps\":%@\r\n            },\r\n            \"device_tracked\":\"false\",\r\n            \"timestamp\":\"%@\"\r\n        }]\r\n    }]\r\n}",accessToken,CLIENT_ID,TRANSACTION_ID,dateString,[NSString stringWithFormat:@"%i",updateWalkTime],[NSString stringWithFormat:@"%i",updateWalkDist], [NSString stringWithFormat:@"%i",updateWalkSteps],timestamp];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Walking/Running activity not created yet. Please do the create." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    });
                }
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please post miles. It is mandatory" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            });
        }
    }
    else if (btn.tag == 1003)
    {
        self.activityFlag = @"genexcreate";
        
        postStr =  [NSString stringWithFormat:@"{\r\n    \"creates\":[\r\n    {\r\n        \"access_token\":\"%@\",\r\n        \"affiliate_id\":\"%@\",\r\n        \"transaction_id\":\"%@\",\r\n        \"date\":\"%@\",\r\n        \"user_device_id\":\"1234\",\r\n        \"manufacturer_name\":\"Test\",\r\n        \"device_name\":\"Test\",\r\n        \"data\":[\r\n        {\r\n            \"id\":\"MNOxNS0wOC0yNiAyMzowNTo1OTNHUHRqVzVSQlFrME1QRWo3Y3V2WHJCVXZX\",\r\n            \"type\":\"general_exercise\",\r\n            \"value\":{\r\n                \"duration\":%@,\r\n                \"type\":\"general_exercise\"\r\n            },\r\n            \"device_tracked\":\"false\",\r\n            \"timestamp\":\"%@\"\r\n        }]\r\n    }]\r\n}",accessToken,CLIENT_ID,TRANSACTION_ID,dateString,self.genexTimeTextFld.text,timestamp];
        
    }
    else if (btn.tag == 1004)
    {
        postStr =  [NSString stringWithFormat:@"{\r\n    \"creates\":[\r\n    {\r\n        \"access_token\":\"%@\",\r\n        \"affiliate_id\":\"%@\",\r\n        \"transaction_id\":\"%@\",\r\n        \"date\":\"%@\",\r\n        \"user_device_id\":\"1234\",\r\n        \"manufacturer_name\":\"Test\",\r\n        \"device_name\":\"Test\",\r\n        \"data\":[\r\n        {\r\n            \"id\":\"PQRxNS0wOC0yNiAyMzowNTo1OTNHUHRqVzVSQlFrME1QRWo3Y3V2WHJCVXZX\",\r\n            \"type\":\"blood_glucose\",\r\n            \"value\":{\r\n                \"medicine_relation\":\"\",\r\n                \"value\":%@,\r\n                \"meal_relation\":\"Pre\",\r\n                \"meal\":\"Breakfast\"\r\n            },\r\n            \"device_tracked\":\"false\",\r\n            \"timestamp\":\"%@\"\r\n        }]\r\n    }]\r\n}",accessToken,CLIENT_ID,TRANSACTION_ID,dateString,self.bldGlcTextFld.text,timestamp];
    }
    
    NSString *urlStr = activityUrl;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //    NSData *jsonData = [requestStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *jsonData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString
                       stringWithFormat:@"%lu",(unsigned long)[postStr length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
        
         defaults = [NSUserDefaults standardUserDefaults];
        
        if (!error && [[dict objectForKey:@"success_code"] isEqualToString:@"2000"]) {
            
            if ([self.activityFlag length] > 0 && [self.activityFlag isEqualToString:@"stepscreate"]) {
                
                int stepValue = [self.stepsTextFld.text intValue];
                [defaults setInteger:stepValue forKey:@"steps"];
            }
            if ([self.activityFlag length] > 0 && [self.activityFlag isEqualToString:@"stepsupdate"]) {
                
                [defaults setInteger:updateSteps forKey:@"steps"];
            }
            if ([self.activityFlag length] > 0 && [self.activityFlag isEqualToString:@"walkcreate"]) {
                
                int walkDistValue = [self.walkDistTextFld.text intValue];
                [defaults setInteger:walkDistValue forKey:@"walkdistvalue"];
                [defaults setInteger:[walkTime intValue] forKey:@"walktimevalue"];
                [defaults setInteger:[walkSteps intValue] forKey:@"walkstepsvalue"];
            }
            if ([self.activityFlag length] > 0 && [self.activityFlag isEqualToString:@"walkupdate"]) {
                
                [defaults setInteger:updateWalkDist forKey:@"walkdistvalue"];
                [defaults setInteger:updateWalkTime forKey:@"walktimevalue"];
                [defaults setInteger: updateWalkSteps forKey:@"walkstepsvalue"];
            }
            if ([self.activityFlag length] > 0 && [self.activityFlag isEqualToString:@"genexcreate"]) {
                [self saveGenExDefaults];
                self.genExBtn.hidden = YES;
            }
            [defaults synchronize];
            appDelegate.activitySuccess = @"pass";
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"success" message:@"Posted successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            });
        }
        else
        {
            appDelegate.activitySuccess = @"fail";
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Post Failed. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            });
        }
    }
     ];
}


-(void)saveStepsDefaults
{
    NSDate *currentUTCDate = [NSDate date];
    [DateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString * createDate = [DateFormatter stringFromDate:currentUTCDate];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:createDate forKey:@"stepscreatedate"];
    [defaults synchronize];
}

-(void)saveWalkDefaults
{
    NSDate *currentUTCDate = [NSDate date];
    [DateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString * createDate = [DateFormatter stringFromDate:currentUTCDate];
     defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:createDate forKey:@"walkcreatedate"];
    [defaults synchronize];
}

-(void)saveGenExDefaults
{
    NSDate *currentUTCDate = [NSDate date];
    [DateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString * createDate = [DateFormatter stringFromDate:currentUTCDate];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:createDate forKey:@"genxcreatedate"];
    [defaults synchronize];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}

@end
