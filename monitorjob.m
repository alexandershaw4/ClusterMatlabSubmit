function st = monitorjob(jid)

[H,ST] = unix(['qstat -f ',jid(1:16)]);

T = [' regexp(ST, ''job_state = *'', ''match'') '];

[o1,o2] = eval(T);

st = ST(o2+12);