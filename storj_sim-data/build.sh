#!/bin/sh
#Dependencies 
apk add --no-cache alpine-sdk redis nodejs npm postgresql wget openssh-client go

mkdir -m 700 /root/.ssh
touch -m 600 /root/.ssh/known_hosts
ssh-keyscan github.com > /root/.ssh/known_hosts

cp /tmp/storj/id_ed25519 /root/.ssh/id_ed25519
chmod 600 /root/.ssh/id_ed25519

ssh-add /root/.ssh/id_ed25519

##Pull storj and go
rm -rf $HOME/storj
git clone git@github.com:storj/storj $HOME/storj
cd $HOME/storj
sed -i 's/coinpayments\.CurrencySTORJ/coinpayments.CurrencyLTCT/g' $HOME/storj/satellite/payments/stripecoinpayments/tokens.go
go install ./...

## Get and copy satellite-theme
rm -rf $HOME/tardigrade-satellite-theme
git clone git@github.com:storj/tardigrade-satellite-theme.git $HOME/tardigrade-satellite-theme
cd $HOME/tardigrade-satellite-theme
cp -r $HOME/tardigrade-satellite-theme/us2/* $HOME/storj/web/satellite/

## Build Satellite
cd $HOME/storj/web/satellite
npm install
npm run build

## Build Storagenode
cd $HOME/storj/web/storagenode
npm install
npm run build

## Build Multinode
cd $HOME/storj/web/multinode
npm install
npm run build

## Make WASM old way
#cd $HOME/storj
#make satellite-wasm
#mv release/*/wasm/* web/satellite/static/wasm/

#MAKE WASM
cd $HOME/storj/web/satellite
npm run wasm
npm install
npm run build

cd $HOME/storj
npm install
#npm run build
npm build wasm
## Get and go
rm -r $HOME/gateway-mt
git clone git@github.com:storj/gateway-mt $HOME/gateway-mt
cd $HOME/gateway-mt
go install ./...
cd $HOME