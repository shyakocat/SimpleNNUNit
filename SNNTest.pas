Uses MatrixUnit,SimpleNNUnit;
Type
 AS=Array[0..30]Of SIngle;
 pAS=^AS;
Var
 a:BP_Graph;
 i,j,x:Longint;
 datain,dataout:Vector;
 Arr:Array[0..6000]Of LOngint;
Begin
 BP_SetLayer(@a,[32,4]);
 BP_SetRate(@a,0.02);
 For i:=0 to 6000 Do Arr[i]:=Random(1<<16)<<16+Random(1<<16);
 For i:=1 to 25 DO
 For x in Arr DO Begin
  datain.Create(32);
  For j:=0 to 31 Do datain.a[j]:=(x>>j)And 1;
  dataout.Create(4);
  If x>0 Then
   If Odd(x) Then dataout[1]:=1
             Else dataout[2]:=1
  Else
   If Odd(x) Then dataout[3]:=1
             Else dataout[4]:=1;
  BP_Train(@a,datain,dataout);
 End;
 While True DO Begin
  WriteLN;
  WriteLN('Input A Num:');
  ReadLn(x);
  datain.Create(32);
  For j:=0 to 31 Do datain.a[j]:=(x>>j)And 1;
  dataout:=BP_Run(@a,datain);
  PrintfLn(dataout);
  x:=1; If dataout[2]>dataout[x] Then x:=2;
        IF dataout[3]>dataout[x] Then x:=3;
        If dataout[4]>dataout[x] Then x:=4;
  Case x OF
   1:WriteLn('+Odd');
   2:WriteLn('+Eve');
   3:WriteLN('-Odd');
   4:WriteLN('-Eve')
  ENd
 End
End.