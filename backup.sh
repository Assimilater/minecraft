#!/bin/bash

worlds=$(find servers/* -maxdepth 0 -type d)
for world_dir in $worlds
do
world=${world_dir#*/}
echo 'Doing backup for '$(echo $world)

# copy the world
screen -S $world -X stuff '/say Backup Started: World saving temporarily disabled'$(echo -ne '\015')
screen -S $world -X stuff '/save-off'$(echo -ne '\015')
screen -S $world -X stuff '/save-all'$(echo -ne '\015')
cp -rpf servers/$world/$world servers/$world/backups/current/world
screen -S $world -X stuff '/save-on'$(echo -ne '\015')
screen -S $world -X stuff '/say Backup Finished: World saving enabled again'$(echo -ne '\015')

# zip the backup
rm -f servers/$world/backups/current/world.zip
zip -r servers/$world/backups/current/world.zip servers/$world/backups/current/world/ >/dev/null

# render overviewer
screen -S $world -X stuff '/say Overviewer Started: Will be available soon'$(echo -ne '\015')
overviewer.py --rendermodes=smooth-lighting servers/$world/backups/current/world servers/$world/backups/current/overviewer
screen -S $world -X stuff '/say Overviewer Finished: See it on the website'$(echo -ne '\015')

today=$(TZ=":US/Mountain" date +"%Y-%m-%d")
dom=$(TZ=":US/Mountain" date '+%d')
dow=$(TZ=":US/Mountain" date '+%u')

echo 'Using timestamp: '$(echo $today)

# Preapre daily variables trims all but the latest 2 dailies (we're about to add a 3rd)
dbs=$(find servers/$world/backups/daily/* -maxdepth 0 -type d | wc -l)
doldest=$(find servers/$world/backups/daily/* -maxdepth 0 -type d | sort -rn)
drm=$(echo $doldest | cut -d" " -f3-)

# Prepare weekly variables trims all but the latest 2 weeklys (we're about to add a 3rd)
wbs=$(find servers/$world/backups/weekly/* -maxdepth 0 -type d | wc -l)
woldest=$(find servers/$world/backups/weekly/* -maxdepth 0 -type d | sort -rn)
wrm=$(echo $woldest | cut -d" " -f3-)

# Prepare monthly variables trims all but the latest 2 monthlys (assuming we're about to add a 3rd)
mbs=$(find servers/$world/backups/monthly/* -maxdepth 0 -type d | wc -l)
moldest=$(find servers/$world/backups/monthly/* -maxdepth 0 -type d | sort -rn)
mrm=$(echo $moldest | cut -d" " -f3-)

screen -S $world -X stuff '/say Archiver Started: Cataloging and cleaning old backups'$(echo -ne '\015')
# Archive a daily backup everyday
if [ "$drm" != "" ]; then
	rm -rf $drm
fi
cp -rp servers/$world/backups/current/ servers/$world/backups/daily/$today

# Archive a weekly backup on sunday
if [ $dow = 07 ]; then
if [ "$wrm" != "" ]; then
	rm -rf $wrm
fi
	cp -rp servers/$world/backups/current/ servers/$world/backups/weekly/$today
fi

# Archive a monthly backup on the first day of the month
if [ $dom = 01 ]; then
if [ "$mrm" != "" ]; then
	rm -rf $mrm
fi
	cp -rp servers/$world/backups/current/ servers/$world/backups/monthly/$today
fi
screen -S $world -X stuff '/say Archiver Finished: Backups can be downloaded from the website'$(echo -ne '\015')
done

# make sure permissions are still ok
chown -R root:sudo ./
