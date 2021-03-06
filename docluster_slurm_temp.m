function docluster_slurm(f,varargin)
% use sbatch to submit cluster jobs from within matlab
% by auto-writing a little bash script and sbatching it
%
% f is the matlab function or script to call on the cluster
% other inputs are the *string* inputs to that function
%
% AS

h   = evalinContext('pwd');
fh  = which(f);
fh  = [fileparts(fh) '/'];

ln{1} = sprintf('#!/bin/bash\n');
ln{2} = sprintf('\n');
ln{2} = sprintf([ln{2} 'cd ' h '\n']); 
ln{3} = sprintf('\nmatlab -nodesktop -nosplash -r "');
ln{3} = [ln{3} ' addpath ' fh '; '];
ln{3} = [ln{3} f];


try varargin{1}; catch varargin{1} = []; end

if any(varargin{1});
    ln{4} = ['(''' varargin{1}];
    
    if length(varargin) > 1
        for j = 2:length(varargin)
            ln{4} = [ln{4} ''',''' varargin{j} ''];
        end
    end
    
    ln{4} = [ln{4} ''');exit;"'];

else
    ln{4} = [';exit"'];
end

cmd = strcat(ln{1},ln{2},ln{3}, ln{4});

dlmwrite(['job_' date '.sh'],cmd,'delimiter','');
unix(['chmod a+x job_' date '.sh']) ;


if any(varargin{1})
    inp = [];
    for k = 1:length(varargin)
        if k == 1; inp = [inp ' ']; end
        try   inp = [inp varargin{k} '=' evalinContext(varargin{k}) ];
        catch inp = [inp '''' varargin{k} ''''];
        end
        if k ~= length(varargin)
            inp = [inp ',' ];
        end
    end
    exstr{1} = 'sbatch ';
else
    exstr{1} = 'sbatch ';
end

torun = [exstr{:} ' job_' date '.sh'];
unix(torun);