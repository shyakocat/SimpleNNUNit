{$MODE OBJFPC}{$H+}
unit SimpleNNUnit;
interface
Uses CommonTypeUnit,MatrixUnit;

Type
 pBP_Graph=^BP_Graph;
 BP_Graph=Record
  Rate:Single;
  Weight:Specialize List<Matrix>;
 End;

 Function Rnd:Single;

 Function BP_LayerSize(p:pBP_Graph):Longint;
 Function BP_InputSize(p:pBP_Graph):Longint;
 Function BP_OutputSize(p:pBP_Graph):Longint;

 Procedure BP_SetRate(p:pBP_Graph;learnrate:Single);
 Procedure BP_SetLayer(p:pBP_Graph;Const n:Array Of Longint);
 Procedure BP_Train(p:pBP_Graph;datain,dataout:Vector);
 Function BP_Run(p:pBP_Graph;datain:Vector):Vector;

 Procedure BP_Save(p:pBP_Graph;path:Ansistring);
 Procedure BP_Load(p:pBP_Graph;path:Ansistring);




implementation

 Function Rnd:Single;
 Begin
  Exit(Random(100000000)/99999999)
 End;

 Function Sigmoid(x:Single):Single;
 Begin
  Exit(1/(1+exp(-x)))
 End;

 Function BP_LayerSize(p:pBP_Graph):Longint;
 Begin
  Exit(p^.Weight.Size+1)
 End;

 Function BP_InputSize(p:pBP_Graph):Longint;
 Begin With p^ Do
  If Weight.Size=0 Then Exit(0) Else
  Exit(Weight[1].n-1)
 End;

 Function BP_OutputSize(p:pBP_Graph):Longint;
 Begin With p^ Do
  If Weight.Size=0 Then Exit(0) Else
  Exit(Weight[Weight.Size].m)
 End;

 Procedure BP_SetRate(p:pBP_Graph;learnrate:Single);
 Begin
  p^.Rate:=learnrate;
 End;

 Procedure BP_SetLayer(p:pBP_Graph;Const n:Array Of Longint);
 Var
  i:Longint;
 Begin With P^ Do Begin
  Weight.Resize(high(n));
  For i:=1 to Weight.Size Do Weight.Items[i].Create(n[i-1]+Ord(i=1),n[i]);
 End End;

 Procedure BP_Train(p:pBP_Graph;datain,dataout:Vector);
 Var
  n,i,j,k:Longint;
  Predict:Vector;
  Layer,Delta:Specialize List<Vector>;
 Begin With P^ DO Begin
  n:=Weight.Size+1;
  Layer.Resize(n);
  Layer.Items[1].Create(datain.n+1);
  For j:=1 to datain.n Do Layer.Items[1][j]:=datain[j]; Layer.Items[1][Layer[1].n]:=1;
  For i:=2 to n Do Begin
   Layer[i]:=Layer[i-1]*Weight[i-1];
   For j:=1 to Layer[i].n Do Layer.Items[i][j]:=Sigmoid(Layer[i][j])
  End;
  Predict:=Layer[n];
  Delta.Resize(n);
  Delta.Items[n].Create(Predict.n);
  For j:=1 to Predict.n Do
   Delta[n][j]:=(dataout[j]-Predict[j])*Predict[j]*(1-Predict[j]);
  For i:=n-1 Downto 2 Do Begin
   Delta[i]:=Delta[i+1]*Transpose(Weight[i]);
   For j:=1 to Delta[i].n Do Delta.Items[i][j]:=Delta[i][j]*Layer[i][j]*(1-Layer[i][j])
  End;
  For i:=1 to n-1 Do Begin
   For j:=1 to Weight[i].n Do
   For k:=1 to Weight[i].m Do
    Weight.Items[i][j,k]:=Weight[i][j,k]+rate*Delta[i+1][k]*Layer[i][j]
  End
 End End;

 Function BP_Run(p:pBP_Graph;datain:Vector):Vector;
 Var i,j:Longint;
 Begin With P^ DO Begin
  Result.Create(datain.n+1);
  For j:=1 to datain.n Do Result[j]:=datain[j]; Result[Result.n]:=1;
  For i:=1 to Weight.Size Do Begin
   Result:=Result*Weight[i];
   For j:=1 to Result.n Do Result[j]:=Sigmoid(Result[j])
  End
 End End;

 //TODO : Data Save And Load

 Procedure BP_Save(p:pBP_Graph;path:Ansistring);
 Begin
 End;

 Procedure BP_Load(p:pBP_Graph;path:Ansistring);
 Begin
 End;


end.