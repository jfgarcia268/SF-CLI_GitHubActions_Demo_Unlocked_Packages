#!/usr/bin/env bash

#---------------------------------------------
#Date: 06/20/2020
#Code by: Juan Felipe Garcia
#---------------------------------------------

DEVHUB_URL=$1
PACKAGE_NAME=$2


NUM_PACKAGES=$(jq -c '.packageDirectories | length' sfdx-project.json)
echo "## Getting Version From Project File sfdx-project.json"
for (( i=0; i<$NUM_PACKAGES; i++ ))
do
	PACKAGE=$(jq -r ".packageDirectories[${i}].package" sfdx-project.json)
	#echo "$PACKAGE - $PACKAGE_NAME"
	if [ "$PACKAGE" == "$PACKAGE_NAME" ]; then
		VERSION=$(jq -r .packageDirectories[${i}].versionNumber sfdx-project.json)
		echo "VERSION: ${VERSION}"
		# "versionNumber": "0.1.0.NEXT",
		delimiter="."
		s=$VERSION$delimiter
		array=();
		while [[ $s ]]; do
			array+=( "${s%%"$delimiter"*}" );
			s=${s#*"$delimiter"};
		done;
		MAYOR_VERSION=${array[0]}
		MINOR_VERSION=${array[1]}
		PATCH_VERSION=${array[2]}
		echo "MAYOR_VERSION: ${MAYOR_VERSION}"
		echo "MINOR_VERSION: ${MINOR_VERSION}"
		echo "PATCH_VERSION: ${PATCH_VERSION}"
	fi	
done

PACKAGE2_ID=$(jq -r ".packageAliases.${PACKAGE_NAME}"  sfdx-project.json)

echo "## Getting Latest Build Number for Package: $PACKAGE_NAME ($PACKAGE2_ID) "
QUERY="SELECT BuildNumber, SubscriberPackageVersionId, IsReleased FROM Package2Version WHERE MajorVersion=${MAYOR_VERSION} AND MinorVersion=${MINOR_VERSION} AND PatchVersion=${PATCH_VERSION} AND Package2Id='${PACKAGE2_ID}' ORDER BY BuildNumber DESC LIMIT 1"
echo "QUERY: ${QUERY}"
RESULT=$(sfdx force:data:soql:query --json --use-tooling-api --target-org="$DEVHUB_URL" --query="$QUERY" )
BUILD_NUMBER=$(jq -r .result.records[0].BuildNumber <<< "$RESULT")
PACKAGE_ID=$(jq -r .result.records[0].SubscriberPackageVersionId <<< "$RESULT")
PACKAGE_IS_RELEASED=$(jq -r .result.records[0].IsReleased <<< "$RESULT")

if [ "$BUILD_NUMBER" != null ]; then
	NEW_VERSION="${MAYOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.${BUILD_NUMBER}"
	echo "## Recent Build Number found:${BUILD_NUMBER}  New Version: ${NEW_VERSION}  Package ID: $PACKAGE_ID"
	echo "$PACKAGE_ID" > ${PACKAGE_NAME}_PID.txt
	echo "$PACKAGE_IS_RELEASED" > ${PACKAGE_NAME}_IS_RELEASED.txt
else
	echo "No Records found for query, Result:"
	echo "$RESULT"
fi

