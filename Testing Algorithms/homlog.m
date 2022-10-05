function f=homlog(I, niterations)
%
%Homomorhic filtering with the log function
% Christos Loizou 2/6/2002. lslog
if isa(I, 'uint8')
  u8out = 1;
  if (islogical(I))
    % It doesn't make much sense to pass a binary image
    % in to this function, but just in case.
    logicalOut = 1;
    I = double(I);
  else
    logicalOut = 0;  
    I = double(I)/255;    
  end
else
  u8out = 0;
end

h = waitbar(0, 'Filtering Image...');

%Initialize the picture f (new picture) with zeros
f = I;

%Apply niteration of the algorithm to the image
for i = 1:niterations            
    % fprintf('\rIteration %d',i);
    if i >=2 
        I=f;
    end
    
    L=log(I);
    K=medfilt2(L, [5 5]); % K=medfilt2(K, [5 5]);
    KK=exp(K); 
    % KK=KK./255;
    f=KK;
    %imshow(KK);
    
    waitbar(i/niterations, h);
end
close(h)

if u8out==1
  if (logicalOut)
    f = uint8(f);
  else
    f = uint8(round(f*255));
  end
end