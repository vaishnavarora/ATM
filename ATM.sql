create column table Transactions
(
 TRX_ID INT,
 TRX_TS Timestamp,
 Account Int,
 Amount Decimal(10,2),
 Action Varchar(1)
);

Insert into Transactions Values(1000,Now(),1,100,'D');
Insert into Transactions Values(1001,Now(),2,100,'D');

Create Procedure Transactions_App8(In Account Int,
			   In Amount Decimal(10,2),
			   In Action Varchar(1),
			   Out MSG1 NVarchar(100),
			   Out MSG2 NVarchar(100))

        Language SQLSCRIPT
	SQL SECURITY INVOKER
	Default Schema DBADMIN
As
Begin
Declare TRX Int Default 1;
Declare balance Decimal(10,2) Default 1.0;
If :Action ='D' Then
    Select (Max(Trx_id)+1) into TRX from Transactions;
    Insert into Transactions values(:TRX,Now(),:Account,:Amount,:Action);
    MSG1='transaction successful and $' ||:Amount|| 'Deposited into your account';
    Select Sum(Amount) into balance from Transactions where Account=:Account;
    MSG2='Your availabale balance is :$'|| :balance;
Elseif :Action='W' Then
     Select Sum(Amount) into balance from Transactions where Account=:Account;
     if :balance>:Amount then 
        Select (Max(Trx_id)+1) into TRX from Transactions;
        Amount:=Amount*(-1);
        Insert into Transactions values(:TRX,Now(),:Account,:Amount,:Action);
        MSG1='transaction successful and $' ||:Amount|| 'deducted from your account';
        Select Sum(Amount) into balance from Transactions where Account=:Account;
        MSG2='Your availabale balance is :$'|| :balance;
     else
     MSG1:='insufficient funds';
     MSG2:='try again with less amount';
     end if;
Else
     MSG1:='Invalid Transaction type';
     MSG2:='Please try again with D/W transaction type';
End if;
End;

call  transactions_app8(2,1000,'W',?,?)
