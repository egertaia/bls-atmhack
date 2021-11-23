fx_version "cerulean"

description "Basic ATM Hacking script utilizing bls-hackingdevices"
author "egertaia"
version '0.0.2'
repository 'https://github.com/egertaia/bls-atmhack'

lua54 'yes'

games {
  "gta5",
}

client_script "client/**/*"
server_script "server/**/*"
shared_script "shared/**/*"