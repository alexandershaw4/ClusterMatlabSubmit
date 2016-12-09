function docluster(f,varargin)

h = evalinContext('pwd');

ln{1} = sprintf('#!/bin/bash\n');
ln{2} = sprintf('\n');
ln{2} = sprintf([ln{2} 'cd ' h '\n']); 
ln{3} = sprintf('\nmatlab -nodesktop -nosplash  -r ''');
ln{3} = [ln{3} f];

try varargin{1}; catch varargin{1} = []; end

if any(varargin{:});
    ln{4} = ['(''$' varargin{1}];
    
    if length(varargin) > 1
        for j = 2:length(varargin)
            ln{4} = [ln{4} ',''$' varargin{j} ''''];
        end
    end
    
    ln{4} = [ln{4} ''');exit;'''];

else
    ln{4} = [';exit'''];
end

cmd = strcat(ln{1},ln{2},ln{3}, ln{4});

dlmwrite(['job_' date '.sh'],cmd,'delimiter','');
unix(['chmod a+x job_' date]) ;


if any(varargin{:})
    inp = [];
    for k = 1:length(varargin)
        inp = [inp ' ' varargin{k} '=' evalinContext(varargin{k}) ];
    end
    exstr{1} = 'qsub -v ';
    exstr{1} = strcat(exstr{1},inp);
else
    exstr{1} = 'qsub ';
end

torun = [exstr{:} ' ./job_' date '.sh'];
unix(torun)