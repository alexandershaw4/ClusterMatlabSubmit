
[jk,me] = unix('whoami');

cmd = ['qstat | grep ' me];

[s,jobs] = unix(cmd);

T = [' regexp(jobs, ''[0-9]*.master01'', ''match'') '];
r = [' regexp(jobs, ''R'',''match'') '];
e = @eval;
l = @length;

nj = l(e(r));
Tj = l(e(T));
st = sprintf('%d jobs running',nj);

fprintf(st);

while nj > 1
    [s,jobs] = unix(cmd);
    pause(10);
    nj = l(e(r));
    Tj = l(e(T));
    
    fprintf(repmat('\b',[1 length(st)]));
    st = sprintf('%d jobs running',nj);
    nw = fix(clock);
    nw = [num2str(nw(4)) ':' num2str(nw(5))];
    st = [st ' of ' num2str(Tj) ' total on cluster @ ' nw ' on ' date];
    fprintf(st);
end