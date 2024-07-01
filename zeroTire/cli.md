Basic CLI usage
Get your ZeroTier address and check the service status

zerotier-cli status
200 info 998765f00d 1.2.13 ONLINE

Join, leave, and list networks. Remember, ZeroTier networks are 16-digit IDs that look like 8056c2e21c000001

zerotier-cli join ################
200 join OK

zerotier-cli leave ################
200 leave OK

zerotier-cli listnetworks
200 listnetworks 8056c2e21c000001 earth.zerotier.net 02:99:35:84:f9:dc OK PUBLIC 29.152.27.109/7


Advanced CLI usage
More advanced commands can be found using zerotier-cli -h

Collect debug info for support
zerotier-cli dump