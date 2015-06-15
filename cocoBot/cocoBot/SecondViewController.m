//
//  SecondViewController.m
//  cocoBot
//
//  Created by VincentHe on 6/10/15.
//  Copyright (c) 2015 VincentHe. All rights reserved.
//

#import "SecondViewController.h"
#import <iflyMSC/IFlySpeechUtility.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <AFNetworking/AFNetworking.h>
#import "Utils.h"
#import <iflyMSC/IFlySpeechUnderstander.h>


@interface SecondViewController ()<IFlySpeechRecognizerDelegate>
{
    IFlySpeechUnderstander *_iFlySpeechUnderstander;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *initString = @"appid=5578edb9";
    [IFlySpeechUtility createUtility:initString];
    _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    _iFlySpeechUnderstander.delegate = self;
    [_iFlySpeechUnderstander setParameter:@"iat" forKey:@"domain"];
    [_iFlySpeechUnderstander setParameter:@"json" forKey:@"rst"];
    [_iFlySpeechUnderstander setParameter:@"2.0" forKey:@"nlp_version"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)listen:(id)sender
{
    [_iFlySpeechUnderstander startListening];
}


- (void) onResults:(NSArray *) results isLast:(BOOL) isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = results [0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    NSLog(@"听写结果：%@",result);
    [self sendTococoService:result];
}
-(void) onError:(IFlySpeechError*) error
{
    NSLog(@"%@",error);
}

-(void)sendTococoService:(NSString*)json
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:cocoServiceUrl]];
    [request setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = @"application/json";
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"any-value" forHTTPHeaderField: @"User-Agent"];
    
    //create the body
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    
    //post
    [request setHTTPBody:postBody];
    
    
    //get response
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error                   = [[NSError alloc] init];
    NSData *responseData    = [NSURLConnection sendSynchronousRequest :request returningResponse:&urlResponse error:&error];
    NSString *result                 = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response Code: %ld", [urlResponse statusCode]);
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
        NSLog(@"Response: %@", result);
}


@end
