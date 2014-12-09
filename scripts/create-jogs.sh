#!/bin/sh
for distance in 9000 10000 11000 12000 
do
	for time in 3300 3600 3800 4000 
	do
		for date in 2014-12-08T20:00:00 2014-12-08T21:00:00 2014-12-07T22:00:00 2014-12-06T20:00:00 2014-12-05T21:00:00 2014-12-04T22:00:00 2014-12-03T22:00:00 2014-12-02T22:00:00 2014-12-01T22:00:00
		do
			curl -X POST -d "{\"time\":$time,\"user\":{\"__type\":\"Pointer\",\"className\":\"_User\",\"objectId\":\"fxszRIECBm\"},\"distance\":$distance,\"date\":{\"__type\":\"Date\",\"iso\":\"$date\"}}" --compressed --cookie "_parse_session=BAh7BkkiD3Nlc3Npb25faWQGOgZFRiIlYmQwYjUzNzRmMWE5MjdiODUwMDUyZWFlYzQyZjgyMTM%3D--be0b7fbaf8de9b628102bcc6d3bb5e5ad83485f2" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'X-Parse-Session-Token: herOwuRBGNIeLn16GAQdKjKrd' -H 'User-Agent: Jogging/1.0 (iPhone Simulator; iOS 8.1; Scale/2.00)' -H 'X-Parse-Application-Id: miw8ufMpwGjfvnuLssMXMNs0xNqThjWDRKJC2ELl' -H 'X-Parse-REST-API-Key: fCtvn92JEjCElNM1kfGIicIB3AvP5lO7pLUIznLv' -H 'Accept-Language: en;q=1' "https://api.parse.com/1/classes/Jog"
		done
	done
done
