  function   [ClassRate,num1,label]=rulelearning_test_s(training,testS,testL,number)

% Inputs:
% training: trainig samples 
% testS:test samples 
% testL:label of test set
% number:the number of seleted rules on training set

% Outputs:
% ClassRate: the classification accuracy on the test set
% num1: the number of selected rules 
% label:the ouput of the test samples
  
  
%rule learning 
[proto,cover]=largemargin_extraction_coveringrule_s(training,2);
%classification using the learned rules 
[m,n]=sort(1-cover);
[row, column]=size(proto);
[row1, column1]=size(testS);
ClassRate1=[];
data=[];
cover1=[];
for h=number

    data=proto(n(1:h),:);
    cover1=cover(n(1:h));
 for i=1:row1
              dist_mar(i,:)=max(abs(repmat(testS(i,1:(column-1)),h,1)-data(:,1:(column-1)))'); 
 end


 label1=[];
 for i=1:row1
     k=0;
     index=[];
     for j=1:h
      if dist_mar(i,j)<=cover1(j)
          k=k+1;
          index(k)=data(j,column);
      end
     end

     if k==1
          label1(i)=index(1);
     else
         [indd,in]=min(dist_mar(i,:));
         label1(i)=data(in,column);
     end

 end
      LABELS(h,:)=label1;
      data=[];
      cover1=[];
      dist_mar=[];
      ClassRate1(h)=length(find((label1'-testL)==0))/length(testL);
end
[m1,n1]=max(ClassRate1);
ClassRate=m1;
num1=n1;
label=LABELS(n1,:);