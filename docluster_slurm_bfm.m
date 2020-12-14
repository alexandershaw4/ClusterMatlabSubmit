function docluster_slurm_bfm(f,varargin)
% use sbatch to submit cluster jobs from within matlab
% by auto-writing a little bash script and sbatching it
%
% f is the matlab function or script to call on the cluster
% other inputs are the *string* inputs to that function
%
% AS

%h   = evalinContext('pwd');
h   = [fileparts(varargin{1}) '/'];
fh  = which(f);
fh  = [fileparts(fh) '/'];

ln{1} = sprintf('#!/bin/bash\n');
ln{1} = [ln{1} '#SBATCH --job-name=aOPTIM'];
ln{1} = [ln{1} sprintf('\n')];
ln{1} = [ln{1} '#SBATCH --ntasks 1'];
ln{1} = [ln{1} sprintf('\n')];
ln{1} = [ln{1} '#SBATCH --cpus-per-task 3'];
ln{1} = [ln{1} sprintf('\n')];
ln{1} = [ln{1} '#SBATCH --mem-per-cpu 4096'];
    
ln{2} = sprintf('\n');
ln{2} = sprintf([ln{2} 'cd ' h '\n']); 
ln{3} = sprintf('\nmatlab -nodesktop -nosplash -r "');
ln{3} = [ln{3} ' addpath ' fh '; '];
ln{3} = [ln{3} f];


%try varargin{1}; catch varargin{1} = []; end

if nargin > 1
    
    if isnumeric(varargin{1})
        ln{4} =  ['(' num2str(varargin{1})];
    else
        ln{4} = ['(''' varargin{1}];
    end
    
    if length(varargin) > 1
        for j = 2:length(varargin)
            ln{4} = [ln{4} ''',''' varargin{j} ''];
        end
    end
    
    % end input string 
    if isnumeric(varargin{end})
        ln{4} = [ln{4} ');exit;"'];
    else
        ln{4} = [ln{4} ''');exit;"'];
    end
else
    ln{4} = [';exit"'];
end

cmd = strcat(ln{1},ln{2},ln{3}, ln{4});

id = strrep(strrep(datestr(now),' ','_'),'-','_');

dlmwrite([h 'job_' id '.sh'],cmd,'delimiter','');
unix(['chmod a+x ' h 'job_' id '.sh']) ;


if nargin > 1
    inp = [];
    for k = 1:length(varargin)
        if k == 1; inp = [inp ' ']; end
        %try   
            %inp = [inp varargin{k} '=' evalinContext(varargin{k}) ];
        %catch inp = [inp '''' varargin{k} ''''];
        %end
        if k ~= length(varargin)
            inp = [inp ',' ];
        end
    end
    exstr{1} = 'sbatch ';
else
    exstr{1} = 'sbatch ';
end

torun = [exstr{:} ' ' h 'job_' id '.sh'];
unix(torun); pause(1);