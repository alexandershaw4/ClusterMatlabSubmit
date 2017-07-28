# ClusterMatlabSubmit

Designed for submitting matlab functions and scripts to cluster nodes (using slurm) from within a local matlab.
Usage is similar to that of 'feval', e.g.

```
f = 'myfunction'            % function I want to run
feval(f,varargin)           % evaluate function locally
docluster_slurm(f,varargin) % same usage to send to cluster
```
It works by auto writing out a small bash script like this:

```
#!/bin/bash
cd (the matlab pwd)
matlab -nodesktop -nosplash -r " addpath (paths of dependent funcs); myfunction('inputs');exit;"
```

Example 1.

My function might be an operation that loads a file, performs some operation and saves the output.

```
function LoadDoSave(input)

x   = load(input)    % which contains some variables
x.K = kron(x.A,x.B); % some operation

save(x.name,x);
```

If I need to do this for many inputs, I can submit each as a separate job.

```
Files = {'input1 ... inputn'};
for i = 1:n
  docluster_slurm('LoadDoSave',Files{i});
end
```

Example 2.

My function can take numeric inputs.

```
x = 1.3;
y = 5.56;
f = 'savename';

function myprod(x,y,f)
z = x*y;
save(f,'z');
```


