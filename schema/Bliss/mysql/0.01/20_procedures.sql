DROP PROCEDURE IF EXISTS `delO`;
CREATE PROCEDURE `delO`(IN myuid VARCHAR(50))
BEGIN
      DELETE FROM objects WHERE uid=myuid; --
END;

DROP PROCEDURE IF EXISTS `getLoadout`;
CREATE PROCEDURE `getLoadout`(IN myinstance INT)
BEGIN
    SELECT IF((SELECT loadout FROM instances WHERE instance=myinstance) IS NULL,"[]",(SELECT loadout FROM instances WHERE instance=myinstance)); --
END;

DROP PROCEDURE IF EXISTS `getO`;
CREATE PROCEDURE `getO`(IN myinstance INT,IN page INT)
BEGIN
    SET @i = myinstance; --
    SET @p = page; --
    PREPARE stmt1 FROM 'SELECT id,otype,oid,pos,inventory,health,fuel,damage FROM objects WHERE instance=? LIMIT ?,10'; --
    EXECUTE stmt1 USING @i,@p; --
    DEALLOCATE PREPARE stmt1; --
END;

DROP PROCEDURE IF EXISTS `getOC`;
CREATE PROCEDURE `getOC`(IN myinstance INT)
BEGIN
      SELECT COUNT(*) FROM objects WHERE instance=myinstance; --
END;

DROP PROCEDURE IF EXISTS `getTasks`;
CREATE PROCEDURE `getTasks`(IN myinstance INT)
BEGIN
    SELECT message, mtype, looptime, mstart FROM `dayz`.`scheduler` JOIN `dayz`.`instances` ON mvisibility=visibility WHERE instance=myinstance; --
END;

DROP PROCEDURE IF EXISTS `getTime`;
CREATE PROCEDURE `getTime`(IN myinstance INT)
BEGIN
      SELECT DATE_FORMAT(NOW(),'%d-%m-%Y'), TIME_FORMAT(CURRENT_TIMESTAMP + INTERVAL (SELECT if((SELECT timezone FROM instances WHERE instance=myinstance) IS NULL,0,(SELECT timezone FROM instances WHERE instance=myinstance))) HOUR,'%T'); --
END;

DROP PROCEDURE IF EXISTS `insOselI`;
CREATE PROCEDURE `insOselI`(IN myuid VARCHAR(50),IN mytype VARCHAR(255),IN myhealth VARCHAR(1024),IN myhp DOUBLE,IN myfuel DOUBLE,IN myowner INT,IN mypos VARCHAR(255),IN myinstance INT)
BEGIN
      INSERT INTO objects (uid,otype,health,damage,oid,pos,fuel,instance) VALUES (myuid,mytype,myhealth,myhp,myowner,mypos,myfuel,myinstance); --
END;

DROP PROCEDURE IF EXISTS `insUNselI`;
CREATE PROCEDURE `insUNselI`(IN myuid INT,IN myname VARCHAR(255))
BEGIN
      INSERT INTO main (uid, name,survival) VALUES (myuid, myname,NOW()); --
      SELECT LAST_INSERT_ID(); --
END;

DROP PROCEDURE IF EXISTS `selIIBSM`;
CREATE PROCEDURE `selIIBSM`(IN myuid INT)
BEGIN
      SELECT id, inventory, backpack, FLOOR(TIME_TO_SEC(TIMEDIFF(NOW(),survival))/60), model, late, ldrank FROM main WHERE uid=myuid AND death=0; --
END;

DROP PROCEDURE IF EXISTS `selIPIBMSSS`;
CREATE PROCEDURE `selIPIBMSSS`(IN myuid INT)
BEGIN
      SELECT id, pos, inventory, backpack, medical, FLOOR(TIME_TO_SEC(TIMEDIFF(NOW(),survival))/60), kills, state, late, ldrank, hs, hkills, bkills FROM main WHERE uid=myuid AND death=0; --
END;

DROP PROCEDURE IF EXISTS `selMPSSH`;
CREATE PROCEDURE `selMPSSH`(IN myid INT)
BEGIN
      SELECT medical, pos, kills, state, humanity, hs, hkills, bkills FROM main WHERE id=myid AND death=0; --
END;

DROP PROCEDURE IF EXISTS `setCD`;
CREATE PROCEDURE `setCD`(IN myid INT)
BEGIN
      UPDATE main SET death=1 WHERE id=myid; --
END;

DROP PROCEDURE IF EXISTS `update`;
CREATE PROCEDURE `update`(IN myid INT, IN mypos VARCHAR(1024), IN myinv VARCHAR(1024), IN myback VARCHAR(1024), IN mymed VARCHAR(1024), IN myate INT, IN mydrank INT, IN mytime INT, IN mymod VARCHAR(255), IN myhum INT,IN myk INT, IN myhs INT, IN myhk INT,IN mybk INT,IN mystate VARCHAR(255))
BEGIN
      UPDATE main SET kills=kills+myk,hs=hs+myhs,bkills=bkills+mybk,hkills=hkills+myhk,
      	state=mystate,model=if(mymod='any',model,mymod),late=if(myate=-1,0,late+myate),ldrank=if(mydrank=-1,0,ldrank+mydrank),stime=stime+mytime,
        pos=if(mypos='[]',pos,mypos),humanity=if(myhum=0,humanity,myhum),medical=if(mymed='[]',medical,mymed),
        backpack=if(myback='[]',backpack,myback),inventory=if(myinv='[]',inventory,myinv)
      WHERE id=myid; --
END;

DROP PROCEDURE IF EXISTS `updIH`;
CREATE PROCEDURE `updIH`(IN myid INT,IN myhealth VARCHAR(1024),IN myhp DOUBLE)
BEGIN
      UPDATE objects SET health=myhealth,damage=myhp WHERE id=myid; --
END;

DROP PROCEDURE IF EXISTS `updII`;
CREATE PROCEDURE `updII`(IN myid INT,IN myinv VARCHAR(1024))
BEGIN
      UPDATE objects SET inventory=myinv WHERE id=myid; --
END;

DROP PROCEDURE IF EXISTS `updIPF`;
CREATE PROCEDURE `updIPF`(IN myid INT,IN mypos VARCHAR(255),IN myfuel DOUBLE)
BEGIN
      UPDATE objects SET pos=if(mypos='[]',pos,mypos),fuel=myfuel WHERE id=myid; --
END;

DROP PROCEDURE IF EXISTS `updUI`;
CREATE PROCEDURE `updUI`(IN myuid VARCHAR(50),IN myinv VARCHAR(1024))
BEGIN
      UPDATE objects SET inventory=myinv WHERE uid=myuid; --
END;

DROP PROCEDURE IF EXISTS `updV`;
CREATE PROCEDURE `updV`(IN myuid VARCHAR(50),IN mytype VARCHAR(255) ,IN mypos VARCHAR(255), IN myhealth VARCHAR(1024))
BEGIN
      UPDATE objects SET otype=if(mytype='',otype,mytype),health=myhealth,pos=if(mypos='[]',pos,mypos) WHERE uid=myuid; --
END;
