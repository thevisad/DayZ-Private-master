alter table objects modify inventory varchar(2048) not null default '[]';
alter table main modify inventory varchar(2048) not null default '[]';
alter table main modify backpack varchar(2048) not null default '[]';

drop procedure if exists `updUI`;
create procedure `updUI`(in myuid varchar(50), in myinv varchar(1024))
begin
      update objects set inventory=myinv where uid=myuid; --
end;

drop procedure if exists `updII`;
create procedure `updII`(in myid int, in myinv varchar(1024))
begin
      update objects set inventory=myinv where id=myid; --
end;

drop procedure if exists `update`;
create procedure `update`(in myid int, in mypos varchar(1024), in myinv varchar(2048), in myback varchar(2048), in mymed varchar(1024), in myate int, in mydrank int, in mytime int, in mymod varchar(255), in myhum int, in myk int, in myhs int, in myhk int, in mybk int, in mystate varchar(255))
begin
      update main set kills=kills+myk,hs=hs+myhs,bkills=bkills+mybk,hkills=hkills+myhk,
      	state=mystate,model=if(mymod='any',model,mymod),late=if(myate=-1,0,late+myate),ldrank=if(mydrank=-1,0,ldrank+mydrank),stime=stime+mytime,
        pos=if(mypos='[]',pos,mypos),humanity=if(myhum=0,humanity,myhum),medical=if(mymed='[]',medical,mymed),
        backpack=if(myback='[]',backpack,myback),inventory=if(myinv='[]',inventory,myinv)
      where id=myid; --
end;
