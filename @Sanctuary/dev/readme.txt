The dayz_sanctuary directory contains only the scripts that replace the calls to HiveEXT.dll.
The dayz_server directory contains a copy of these scripts merged with some hopefully recent version of dayz_server.pbo.

To merge in a new version, extract the new dayz_server.pbo to some directory. Then, using a diff/merge program or your
own instincts, merge the dayz_sanctuary directory into your new dayz_server directory. Note that we are replacing the existing
calls to server_hiveReadWrite and server_hiveWrite, so you will want to add support for any new calls to the dayz_sanctuary
hiveReadWrite/hiveWrite SQF files.

Use cpbo.exe or similar to repack your merged dayz_server into dayz_server.pbo and overwrite the one in your production
@Sanctuary\addons directory.
