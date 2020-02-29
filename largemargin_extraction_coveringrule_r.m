function     [proto,cover]=largemargin_extraction_coveringrule_r(training,dell)


% Inputs:
% training: n*m matrix n samples and m features ;
% dell: if number of samples covered by a rule is less than dell, then deleted it;
% Outputs:
% proto: the center of the learned rules
% cover: the size of the learned rules 

[row,column]=size(training);
for i=1:row
    dist_mar(i,:)=sqrt(sum((repmat(training(i,1:(column-1)),row,1)-training(:,1:(column-1))).^2, 2));
end
dist_mar1=dist_mar;
dist_mar4=dist_mar;
p=2*max(max(dist_mar));
% set the dist_mar between samples with the same class as zero
for i=1:row
            dist_mar(i,find(training(i,column)==training(:,column)))=p;
            dist_mar1(i,find(training(i,column)~=training(:,column)))=p;
            dist_mar1(i,i)=p;
end
[m,n]= sort(dist_mar');  %find the nearest miss 
[m1,n1]=sort(dist_mar1');%find the nearest hit 

for i=1:row
  RADIUS(i)=(sqrt(sum((training(i,1:(column-1))-training(n(1,i),1:(column-1))).^2))- sqrt(sum((training(i,1:(column-1))-training(n1(1,i),1:(column-1))).^2)));
end

%==========================================================================
ruleset=cell(row,1);
for i=1:row
        index4=find(dist_mar4(i,:)<=RADIUS(i));
        ruleset{i,1}=index4;
        num(i)=length(index4);
        index44=find(training(index4,column)==training(i,column));
        core(i)=length(index4)-length(index44);
end
    
%rule pruning 
k=0;
num3=num;
num(find(core~=0))=0;
num1=num;
num(find(num1<dell))=0;

if length(num)~=0  
    num2=num;
else
     num2=num3;
end
    
  while(max(num2)~=0)
             [m,n]=sort(-num2);
             num2(ruleset{n(1),1})=0;
             k=k+1;
             lab(k)=n(1);
  end
           
proto=training(lab,:);
cover=RADIUS(lab);                 