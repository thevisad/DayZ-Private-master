#!/bin/bash
mkdir -p deploy/@Bliss/addons
mkdir -p deploy/MPMissions
wine util/cpbo -y -p bliss/dayz_server deploy/@Bliss/addons/dayz_server.pbo
wine util/cpbo -y -p bliss/missions/dayz.lingor deploy/MPMissions/dayz.lingor.pbo
wine util/cpbo -y -p bliss/missions/dayz.chernarus deploy/MPMissions/dayz.chernarus.pbo
