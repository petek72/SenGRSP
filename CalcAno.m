function [ Vcal ] = CalcAno( nData,x,z,A,Theta,th11,q,c,m,n,p,GR )
%UNTÝTLED3 Summary of this function goes here
%   Detailed explanation goes here
  for i=1:nData
      if GR==1
          Th=90*pi/180;

%            if q==0.5;p=1.0;end
%            if q==0.6;p=0.8;end
%            if q==0.7;p=0.6;end
%            if q==0.8;p=0.4;end
%            if q==0.9;p=0.2;end

%           if q==0.5;p=0.0;end
%           if q==0.6;p=0.2;end
%           if q==0.7;p=0.4;end
%           if q==0.8;p=0.6;end
%           if q==0.9;p=0.8;end
          if q>=0.2;p=0.0;end
          if q>=0.6;p=0.2;end          
          if q>=0.7;p=0.4;end
          if q>=0.8;p=0.6;end
          if q>=0.9;p=0.8;end
          if q>=1.0;p=1.0;end


          pay=c*x(i)*(cos(Th))^n+(z^p)*(sin(Th))^m;
          payda=(x(i)^2+z^2)^q;
          Vcal(i)=A*pay/payda;
      else
          pay=c*x(i)*(cos(th11))^n+(z^p)*(sin(th11))^m;
          payda=(x(i)^2+z^2)^q;
          Vcal(i)=A*pay/payda;
      end
  end

end

