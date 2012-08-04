#!/bin/bash
mkdir -p deploy/@Sanctuary/addons
mkdir -p deploy/MPMissions
wine util/cpbo -y -p sanctuary/dayz_server deploy/@Sanctuary/addons/dayz_server.pbo
wine util/cpbo -y -p sanctuary/missions/dayz.lingor deploy/MPMissions/dayz.lingor.pbo
wine util/cpbo -y -p sanctuary/missions/dayz.chernarus deploy/MPMissions/dayz.chernarus.pbo
