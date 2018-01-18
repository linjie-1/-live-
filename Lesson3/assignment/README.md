## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2



L(O) = O  
L(A) = A O  
L(B) = B O  
L(C) = C O  

L(K1) = K1 + merge(AO, BO, AB)  
      = K1 + A + merge(O,BO,B)  
      = K1 + A + B + merge(O,O)  
      = K1 A B O  
        
L(K2) = K2 + merge(AO, CO, AC)  
      = K2 + A + merge(O,CO,C)  
      = K2 + A + C + merge(O,O)  
      = K2 A C O   
      
L(Z) = Z + merge(K1ABO, K2ACO, K1K2)  
     = Z + K1 + merge(ABO,K2ACO,K2)  
     = Z + K1 + K2 + merge(ABO,ACO)  
     = Z + K1 + K2 + A + merge(BO,CO)  
     = Z + K1 + K2 + A + B + merge(O,CO)  
     = Z K1 K2 A B C O  
