//
//  SemanticResponseModel.h
//  cocoBot
//
//  Created by VincentHe on 6/14/15.
//  Copyright (c) 2015 VincentHe. All rights reserved.
//

#import "JSONModel.h"

@interface SemanticResponseModel : JSONModel
@property(strong,nonatomic)NSDictionary * webPage;
@property(strong,nonatomic)NSDictionary * semantic;
@property(assign,nonatomic)int id;
@property(strong,nonatomic)NSString * operation;
@property(strong,nonatomic)NSString * service;
@property(strong,nonatomic)NSDictionary* data;
@property(strong,nonatomic)NSString * text;
@end
