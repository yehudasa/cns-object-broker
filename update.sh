#!/bin/bash
kubectl --context=service-catalog delete -f broker.yaml
helm del --purge broker
make push
build_count=`cat .build`
echo $((build_count+1)) > .build
helm install  chart --name broker --namespace broker
port=`kubectl get svc -n broker broker-cns-object-broker-node-port | tail -1 | sed 's/.*://g' | sed 's/\/.*//g'`
cat broker.yaml.template | sed s/{port}/$port/g > broker.yaml
kubectl --context=service-catalog create -f broker.yaml
