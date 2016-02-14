function state = initStateDecoder()

m = 1;
nq = 4;
% 
% state = {};
% s = {};
% for i=1:2^nq
%     s{i} = C{1}{i};
%     L(i) = str2num(C{1}{16 + i});
% end
% state.wmin = str2num(C{1}{33});
% state.wmax = str2num(C{1}{34});
% for i=1:m
%     wq(i) = str2num(C{1}{34 + i});
% end
% state.wq = wq;
% state.s = s;
% state.L = L;
state.nq = nq;
state.NofEl = 500;
state.m =m;
end
