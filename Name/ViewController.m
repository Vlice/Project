//
//  ViewController.m
//  花名测
//
//  Created by Vlice on 16/3/4.
//  Copyright © 2016年 Vlice. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *ShowView;
//@property (strong, nonatomic) IBOutlet UIProgressView *GetProgress;
//@property (strong, nonatomic) IBOutlet UITextField *NameTextField;
//@property (strong, nonatomic) IBOutlet UIImageView *ResultImageView;

@end

@implementation ViewController
NSUInteger ProGress;
int ALLCount=0;
int CountC1=0;
int CountC2=0;
int CountC3=0;
//MPMoviePlayerController *moviePlayer;
- (void)viewDidLoad
{
    [super viewDidLoad];
//    // 创建本地URL（也可创建基于网络的URL)
//    NSURL* movieUrl = [[NSBundle mainBundle]
//                       URLForResource:@"mingzi" withExtension:@"mov"];
//    // 使用指定URL创建MPMoviePlayerController
//    // MPMoviePlayerController将会播放该URL对应的视频
//    moviePlayer = [[MPMoviePlayerController alloc]
//                   initWithContentURL:movieUrl];
//    // 设置该播放器的控制条风格。
//    moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
//    moviePlayer.repeatMode=MPMovieRepeatModeOne;
//    // 设置该播放器的缩放模式
//    moviePlayer.scalingMode = MPMovieScalingModeFill;
//    [moviePlayer prepareToPlay];
//    [moviePlayer.view setFrame: CGRectMake(0 , 0 , 380 , 320)];
//    [self.movieView addSubview: moviePlayer.view];
}
- (IBAction)GetChar:(UIButton *)sender
{
    //文件管理声明
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *content=nil;
    NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
    
    //获取Document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents=[paths lastObject];
    self.ShowView.text=documents;
    NSLog(@"%@",documents);
    //姓名数据源路径
    NSString * fileName =@"NameData1.txt";
    NSString *NameSourcePath=[documents stringByAppendingPathComponent:fileName];
    
    
    //train.txt特征提取写入路径
    NSString * TraFileName=@"train.txt";
    NSString * TrainPath=[documents stringByAppendingPathComponent:TraFileName];
    if ([fm createFileAtPath:TrainPath contents:data attributes:nil])
    {
        NSLog(@"文件创建成功");
    }
    
        NSURL* NameUrl = [[NSBundle mainBundle]
                           URLForResource:@"NameData" withExtension:@"txt"];
    //从NameData文件中获取数据
    NSMutableString *NameString=[NSMutableString stringWithContentsOfURL:NameUrl encoding:NSUTF8StringEncoding error:nil];
    NSString* Space=[NameString substringWithRange:NSMakeRange(5, 1)];


    for (int i=0,k=0,between=0; i<NameString.length-Space.length+1; i++)
    {
        if ([[NameString substringWithRange:NSMakeRange(i, Space.length)]isEqualToString:Space])
        {
            between=i-k;
        
            switch (between)
            {
                    
                case 5:
                    
                    if (i/5!=1)
                    {
                        [NameString insertString:@" " atIndex:i-3];
                    }
                    
                    break;
                case 7:
                  
                    [NameString deleteCharactersInRange:NSMakeRange(i-5, 1)];
                    i--;
                    break;
                default:
                    break;
                   
            }
            k=i;
           
        }
    }  
    //从NameData文件中获取数据

    NSMutableString *TranString=[[NSMutableString alloc]init];
    NSString *AppendString;
    NSString *AppendStringA;
    for (int i=0; i<NameString.length-1; i=i+6)
    {
        AppendString =[NameString substringWithRange:NSMakeRange(i, 6)];
        AppendStringA=[NSString stringWithFormat:@"%@ %@ %@ %@%@",
                       [AppendString substringWithRange:NSMakeRange(4, 1)],
                       [AppendString substringWithRange:NSMakeRange(1, 1)],[AppendString substringWithRange:NSMakeRange(2, 1)],[AppendString substringWithRange:NSMakeRange(1, 2)],
                       [AppendString substringFromIndex:5]           ];
        
        [TranString appendString:AppendStringA];
        [TranString writeToFile:TrainPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        ALLCount++;
     // [self.GetProgress setProgress:0.5 animated:YES] ;
    }

}


//用于统计计算的函数
-(NSString *)Count:(NSString *)Word1  String:(NSString *)AfterTrainStringT Start:(NSUInteger)Begin length:(NSUInteger)size
{
    NSUInteger ManCount=0;
    NSUInteger GirlCount=0;
    NSString  *Word2;
    NSString  *Sex2;
    NSUInteger TIndex=0;
    NSString *AnthoerLine;
    NSString *InString;
    
    while (TIndex<AfterTrainStringT.length-1)
    {
        
        NSString *AfterTrainStringPartT=[AfterTrainStringT substringWithRange:NSMakeRange(TIndex, 9)];
        Sex2=[AfterTrainStringPartT substringToIndex:1];
        Word2=[AfterTrainStringPartT substringWithRange:NSMakeRange(Begin, size)];
        AnthoerLine=[AfterTrainStringPartT substringFromIndex:8];
        
        if ([Word1 isEqual:Word2]&&[Sex2 isEqual:@"男"])
        {
            ManCount++;
        }else if ([Word1 isEqual:Word2]&&[Sex2 isEqual:@"女"])
        {
            GirlCount++;
        }
        TIndex=TIndex+9;
    }//嵌套的while循环
    InString=[NSString stringWithFormat:@"%@ %lu %lu %lu%@",Word1,ManCount,GirlCount,(ManCount+GirlCount),AnthoerLine];
    
    ManCount=0;
    GirlCount=0;
    return InString;
}
//用于判断是否写文件重复
-(BOOL)Repeat:(NSMutableArray *)flag Word:(NSString *)Word
{
    
    for (NSString * Str in flag)
    {
        if ([Str isEqual:Word])
        {
            return YES;
        }
        
    }
    return NO;
}
//用于统计的函数
-(NSUInteger)SumStat:(NSString *)WordFile Start:(NSUInteger)Begin length:(NSUInteger)size
{
    //获取Document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents=[paths lastObject];
    //train.txt特征提取写入路径
    NSString * TraFileName=@"train.txt";
    NSString * TrainPath=[documents stringByAppendingPathComponent:TraFileName];
    
    //从NameData文件中获取数据
    NSMutableString *AfterTrainString=[NSMutableString stringWithContentsOfFile:TrainPath encoding:NSUTF8StringEncoding error:nil];
    //从NameData文件中获取数据
    NSMutableString *AfterTrainStringT=[NSMutableString stringWithContentsOfFile:TrainPath encoding:NSUTF8StringEncoding error:nil];
    
    //姓名男女统计整数声明
    NSMutableArray *flag=[[NSMutableArray alloc]init];
    NSUInteger Index=0;
    NSString  *Sex1;
    NSString  *Word1;
    NSString *InString;
    NSMutableString *AllInString=[[NSMutableString alloc]init];
    
    //flag标记数组初始化
    
    for (Index; Index<AfterTrainString.length-1; Index=Index+9)
    {
        NSString *AfterTrainStringPart=[AfterTrainString substringWithRange:NSMakeRange(Index, 9)];

        Sex1=[AfterTrainStringPart substringToIndex:1];
        Word1=[AfterTrainStringPart substringWithRange:NSMakeRange(Begin,size)];
        if ([self Repeat:flag Word:Word1]==NO)
        {
            [flag addObject:Word1];
            InString=[self Count:Word1 String:AfterTrainStringT Start:Begin length:size];
            [AllInString appendString:InString];
        }
     
    }
    
    [AllInString writeToFile:WordFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return 0;
}

- (IBAction)Statis:(UIButton *)sender
{
    //获取Document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents=[paths lastObject];
    //train.txt特征提取写入路径
    NSString * word1File=@"word1File.txt";
    NSString * word1FilePath=[documents stringByAppendingPathComponent:word1File];

    NSString * word2File=@"word2File.txt";
    NSString * word2FilePath=[documents stringByAppendingPathComponent:word2File];
 
    NSString * NameFile=@"NameFile.txt";
    NSString * NameFilePath=[documents stringByAppendingPathComponent:NameFile];
    
    [self SumStat:word1FilePath Start:2 length:1];
    [self SumStat:word2FilePath Start:4 length:1];
    [self  SumStat:NameFilePath Start:6 length:2];
    
}


-(NSUInteger)GetCharInFile:(NSString *)InFile OutFileName:(NSString *)OutFile
{
    //获取Document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents=[paths lastObject];
   
    NSString * NameFile=@"NameFile.txt";
    NSString * NameFilePath=[documents stringByAppendingPathComponent:NameFile];
    
    NSMutableArray* EventArray=[[NSMutableArray alloc]init];
    NSString* Hello=[NSString stringWithContentsOfFile:InFile encoding:NSUTF8StringEncoding error:nil];
   
    //换行符
    NSString* Space=[Hello substringFromIndex:Hello.length-1];
    NSString* NamePart;
    for (int i=0,k=0,between=0; i<Hello.length-Space.length+1; i++)
    {
        if ([[Hello substringWithRange:NSMakeRange(i, Space.length)]isEqualToString:Space])
        {
            between=i-k;
            
            if (k<between-1)
            {
                NamePart=[Hello substringWithRange:NSMakeRange(k, between)];
                [EventArray  addObject:NamePart];
                
            }
            else
            {
                NamePart=[Hello substringWithRange:NSMakeRange(k+1, between)];
                [EventArray  addObject:NamePart];
            }
            k=i;
        }
    }//For循环结束
    NSMutableString* AllInString=[[NSMutableString alloc]init];
    NSString* word;
    NSString* blank=@" ";
    double First=0;
    double Second=0;
    double FeatureFirst=0;
    double FeatureSecond=0;
    NSString* InString;
    NSString* Str;
    NSMutableString* KK=[[NSMutableString alloc]init];
    int Count=0;
    for (int i=0;i<[EventArray count];i++)
    {
        Str=(NSString *)[EventArray objectAtIndex:i];
        if ([[Str substringToIndex:1]isEqualToString:Space])
        {
            KK=[Str substringFromIndex:1];
            [EventArray replaceObjectAtIndex:i withObject:KK];
        }

    }
    
   
    
    for (NSMutableString * Str in EventArray)
    {
        
        if ([InFile isEqual:NameFilePath])
        {
            word=[Str substringToIndex:2];
        }
        else
        {

        
                 word=[Str substringToIndex:1];
           
            
        }
      
        for (int i=0,k=0,Count=0; i<Str.length; i++)
        {
          
            if ([[Str substringWithRange:NSMakeRange(i, blank.length)]isEqualToString:blank])
            {
                Count++;
                switch (Count)
                {
                    case 2:
                        First=[[Str substringWithRange:NSMakeRange(k+1,i-k-1)]doubleValue];
                        break;
                    case 3:
                        if ([word isEqual:blank])
                        {
                            First=[[Str substringWithRange:NSMakeRange(k+1,i-k-1)]doubleValue];
                        }else
                        {
                            Second=[[Str substringWithRange:NSMakeRange(k+1,i-k-1)]doubleValue];
                       }
                        break;
                    case 4:
                            Second=[[Str substringWithRange:NSMakeRange(k+1,i-k-1)]doubleValue];

                        break;
                    default:
                        break;
                }
               k=i;
                
               
            }//If
        }//For2
        
        FeatureFirst=First/ALLCount;
        FeatureSecond=Second/ALLCount;
       
        if (FeatureFirst==0.000000)
        {
            InString=[NSString stringWithFormat:@"%@ 女 %f %f%@",word,FeatureSecond,FeatureFirst+FeatureSecond,Space];
            Count++;
        }else if (FeatureSecond==0.000000)
        {
            InString=[NSString stringWithFormat:@"%@ 男 %f %f%@",word,FeatureFirst,FeatureFirst+FeatureSecond,Space];
            Count++;
        }else
        {
        InString=[NSString stringWithFormat:@"%@ 男 %f %f%@%@ 女 %f %f%@",word,FeatureFirst,FeatureFirst+FeatureSecond,Space,word,FeatureSecond,FeatureFirst+FeatureSecond,Space];
            Count=Count+2;
        }
        [AllInString appendString:InString];
    }//For1
    [AllInString writeToFile:OutFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return Count;
}
- (IBAction)GetFeature:(UIButton *)sender
{

    //文件管理声明
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *content=nil;
    NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
    //获取Document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents=[paths lastObject];
    //train.txt特征提取写入路径
    NSString * word1File=@"word1File.txt";
    NSString * word1FilePath=[documents stringByAppendingPathComponent:word1File];
    
    NSString * word2File=@"word2File.txt";
    NSString * word2FilePath=[documents stringByAppendingPathComponent:word2File];
    
    NSString * NameFile=@"NameFile.txt";
    NSString * NameFilePath=[documents stringByAppendingPathComponent:NameFile];
    
    NSString * charactor1_File=@"charactor1.txt";
    NSString * charactor1_FilePath=[documents stringByAppendingPathComponent:charactor1_File];
    [fm createFileAtPath:charactor1_FilePath contents:data attributes:nil];
    NSString * charactor2_File=@"charactor2.txt";
    NSString * charactor2_FilePath=[documents stringByAppendingPathComponent:charactor2_File];
    [fm createFileAtPath:charactor2_FilePath contents:data attributes:nil];
    NSString * charactor3_File=@"charactor3.txt";
    NSString * charactor3_FilePath=[documents stringByAppendingPathComponent:charactor3_File];
    [fm createFileAtPath:charactor3_FilePath contents:data attributes:nil];
  
    CountC1=(int)[self GetCharInFile:word1FilePath OutFileName:charactor1_FilePath];
    CountC2=(int)[self GetCharInFile:word2FilePath OutFileName:charactor2_FilePath];
    CountC3=(int)[self GetCharInFile:NameFilePath OutFileName:charactor3_FilePath ];
}

-(void)getArgumentsOutFile:(NSString *)OutFile InFile:(NSString *)InFile
{
    
      NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documents=[paths lastObject];
      NSString * Char3File=@"charactor3.txt";
      NSString * Char3FilePath=[documents stringByAppendingPathComponent:Char3File];
      NSMutableArray* Argument=[[NSMutableArray alloc]init];
      NSMutableArray* ep=[[NSMutableArray alloc]init];
      NSMutableArray* px=[[NSMutableArray alloc]init];
      NSMutableArray* CharPart=[[NSMutableArray alloc]init];
    
    
       NSString* CharString=[NSString stringWithContentsOfFile:OutFile encoding:NSUTF8StringEncoding error:nil];
    
        //换行符
        NSString* Space=[CharString substringFromIndex:CharString.length-1];
        NSString* NamePart;
        for (int i=0,k=0,between=0; i<CharString.length-Space.length+1; i++)
        {
            if ([[CharString substringWithRange:NSMakeRange(i, Space.length)]isEqualToString:Space])
            {
                between=i-k;
                
                if (k<between-1)
                {
                    NamePart=[CharString substringWithRange:NSMakeRange(k, between)];
                    [CharPart addObject:NamePart];
                }
                else
                {
                    NamePart=[CharString substringWithRange:NSMakeRange(k+1, between)];
                    [CharPart  addObject:NamePart];
                }
                k=i;
            }
        }//For循环结束
    long d=CountC1+CountC2+CountC3;
    NSString* StrPartE;
    NSString* StrPartP;
    NSString *Index=@"0";
    for (long i=1; i<500000; i++)
    {
    [Argument addObject:Index];
    }
    NSString *ArReplaceTemp;
    NSString *ArReplaceTemp1;
    int i=0;
    
    for (NSString * Str in CharPart)
    {
        
        if ([OutFile isEqual:Char3FilePath])
        {
            StrPartE=[Str substringWithRange:NSMakeRange(5, 8)];
            [ep addObject:StrPartE];
            StrPartP=[Str substringWithRange:NSMakeRange(14, 8)];
            [px addObject:StrPartP];
        }
        else
        {
            StrPartE=[Str substringWithRange:NSMakeRange(4, 8)];
            [ep addObject:StrPartE];
            StrPartP=[Str substringWithRange:NSMakeRange(13, 8)];
            [px addObject:StrPartP];
        }
    }
      NSString *StrPartE_1,*StrPartP_1;
      while (i<[CharPart count]-1)
      {
          NSString * Str=[CharPart objectAtIndex:i];
          if ([OutFile isEqual:Char3FilePath])
          {
              StrPartE=[Str substringWithRange:NSMakeRange(5, 8)];
              StrPartP=[Str substringWithRange:NSMakeRange(14, 8)];
              
          }
          else
          {
              StrPartE=[Str substringWithRange:NSMakeRange(4, 8)];
              StrPartP=[Str substringWithRange:NSMakeRange(13, 8)];
          }
          NSString * Str_1=[CharPart objectAtIndex:i+1];
          if ([OutFile isEqual:Char3FilePath])
          {
              StrPartE_1=[Str_1 substringWithRange:NSMakeRange(5, 8)];
              StrPartP_1=[Str_1 substringWithRange:NSMakeRange(14, 8)];
              
          }
          else
          {
              StrPartE_1=[Str_1 substringWithRange:NSMakeRange(4, 8)];
              StrPartP_1=[Str_1 substringWithRange:NSMakeRange(13, 8)];
          }
          double pi1,pi2,pi3,pi4;
          double W_1=0,W_2=0;
          double EPM,EPM1;
          double SPP1,SPP;
          double SPE,SPE1;
          SPE=[StrPartE doubleValue];
          SPP=[StrPartP doubleValue];
          SPE1=[StrPartE_1 doubleValue];
          SPP1=[StrPartP_1 doubleValue];
          //NSLog(@"Hello:%f  %f",SPE1,SPP1);
          if (SPP==SPE)
          {
              do
              {
                    pi1=exp(W_1)/(exp(W_1)+1);
                    EPM=SPP*pi1;
                    W_1=W_1+1.0/d*log(SPE/EPM);
                    pi2=exp(W_1)/(exp(W_1)+1);
                  
              }while(pi2-pi1>pow(10,-6));
            ArReplaceTemp=[NSString stringWithFormat:@"%f",W_1];

           [Argument replaceObjectAtIndex:i  withObject:ArReplaceTemp];
              i++;
          }
          else
          {
    
              do
              {
                  pi1=exp(W_1)/(exp(W_1)+exp(W_2));
                  pi3=exp(W_2)/(exp(W_1)+exp(W_2));
                  EPM=SPP*pi1;

                  W_1=W_1+1.0/d*log(SPE/EPM);

                  EPM1=SPP1*pi3;
                  W_2=W_2+1.0/d*log(SPE1/EPM1);
          
                  pi2=exp(W_1)/(exp(W_1)+exp(W_2));
                  pi4=exp(W_2)/(exp(W_1)+exp(W_2));
                  if((pi2-pi1<=pow(10,-6))||(pi4-pi3<=pow(10,-6)))
                      break;
              }while((pi2-pi1>pow(10,-6))||(pi4-pi3>pow(10,-6)));

              if((pi2-pi1<=pow(10,-6))&&(pi4-pi3>pow(10,-6)))
              {
                  ArReplaceTemp=[NSString stringWithFormat:@"%f",W_1];
                  [Argument replaceObjectAtIndex:i  withObject:ArReplaceTemp];
                  //w[i]先迭代出来时，迭代求出w[i+1]
                  while(pi4-pi3>pow(10,-6))
                  {
                      pi3=exp(W_2)/(exp(W_1)+exp(W_2));
                      EPM1=SPP1*pi3;
                      W_2=W_2+1.0/d*log(SPE1/EPM1);
                      pi4=exp(W_2)/(exp(W_1)+exp(W_2));
                  }
                  ArReplaceTemp1=[NSString stringWithFormat:@"%f",W_2];
                  [Argument replaceObjectAtIndex:i+1  withObject:ArReplaceTemp1];
              }
              else if((pi2-pi1>pow(10,-6))&&(pi4-pi3<=pow(10,-6)))
              {
                  ArReplaceTemp1=[NSString stringWithFormat:@"%f",W_2];
                  [Argument replaceObjectAtIndex:i+1  withObject:ArReplaceTemp1];
                  //w[i+1]先迭代出来，迭代求出w[i]
                  while(pi2-pi1>pow(10,-6))
                  {
                      pi1=exp(W_1)/(exp(W_1)+exp(W_2));
                      EPM=SPP*pi3;
                      W_1=W_1+1.0/d*log(SPE/EPM);
                      pi2=exp(W_1)/(exp(W_1)+exp(W_2));
                  }
                  ArReplaceTemp=[NSString stringWithFormat:@"%f",W_1];
                  [Argument replaceObjectAtIndex:i  withObject:ArReplaceTemp];
              }
          
            i=i+2;

          }//else

      }//For循环
    NSMutableString *InString=[[NSMutableString alloc]init];
    double S;
    NSString * AR;
    NSString * Strr;
    NSMutableString *Name=[[NSMutableString alloc]init];
    NSString *NameP;
    NSMutableString *Sex=[[NSMutableString alloc]init];
    NSString *SexP;
    NSString *Part;
    
    for (int k=0; k<i; k++)
    {
        if ([OutFile isEqual:Char3FilePath])
        {
            NSString * Strr=[CharPart objectAtIndex:k];
            NameP=[Strr substringWithRange:NSMakeRange(0, 2)];
            [Name appendString:NameP];
            SexP=[Strr substringWithRange:NSMakeRange(3, 1)];
            [Sex appendString:SexP];
        }else
        {
            NSString * Strr=[CharPart objectAtIndex:k];
            NameP=[Strr substringWithRange:NSMakeRange(0, 1)];
            [Name appendString:NameP];
            SexP=[Strr substringWithRange:NSMakeRange(2, 1)];
            [Sex appendString:SexP];
        }
      
    }
    if ([OutFile isEqual:Char3FilePath])
    {
        for (int k=0; k<i; k++)
        {
            AR=[Argument objectAtIndex:k];
            
            S=[AR doubleValue];
            AR=[NSString stringWithFormat:@"%f",S];
            Strr=[NSString stringWithFormat:@"%@ %@ %@%@",[Name substringWithRange:NSMakeRange(k*2, 2)],[Sex substringWithRange:NSMakeRange(k, 1)],AR,Space];
            [InString appendString:Strr];
        }
    }else
    {
        for (int k=0; k<i; k++)
        {
            AR=[Argument objectAtIndex:k];
            
            S=[AR doubleValue];
            AR=[NSString stringWithFormat:@"%f",S];
            Strr=[NSString stringWithFormat:@"%@ %@ %@%@",[Name substringWithRange:NSMakeRange(k, 1)],[Sex substringWithRange:NSMakeRange(k, 1)],AR,Space];
            [InString appendString:Strr];
        }
   
    }

    [InString writeToFile:InFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (IBAction)OnGIS:(UIButton *)sender
{
    //文件管理声明
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *content=nil;
    NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
    //获取Document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents=[paths lastObject];
    //OutFile
    NSString * Char1File=@"charactor1.txt";
    NSString * Char1FilePath=[documents stringByAppendingPathComponent:Char1File];
    NSString * Char2File=@"charactor2.txt";
    NSString * Char2FilePath=[documents stringByAppendingPathComponent:Char2File];
    NSString * Char3File=@"charactor3.txt";
    NSString * Char3FilePath=[documents stringByAppendingPathComponent:Char3File];
    
    //InFile
    NSString * lastCha1_File=@"lastCha1.txt";
    NSString * lastCha1_FilePath=[documents stringByAppendingPathComponent:lastCha1_File];
    [fm createFileAtPath:lastCha1_FilePath contents:data attributes:nil];
    NSString * lastCha2_File=@"lastCha2.txt";
    NSString * lastCha2_FilePath=[documents stringByAppendingPathComponent:lastCha2_File];
    [fm createFileAtPath:lastCha2_FilePath contents:data attributes:nil];
    NSString * lastCha3_File=@"lastCha3.txt";
    NSString * lastCha3_FilePath=[documents stringByAppendingPathComponent:lastCha3_File];
    [fm createFileAtPath:lastCha3_FilePath contents:data attributes:nil];
    [self getArgumentsOutFile:Char1FilePath InFile:lastCha1_FilePath];
    [self getArgumentsOutFile:Char2FilePath InFile:lastCha2_FilePath];
    [self getArgumentsOutFile:Char3FilePath InFile:lastCha3_FilePath];
}

@end
