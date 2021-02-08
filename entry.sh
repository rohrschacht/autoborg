#!/bin/sh

[ -z "$ORIGIN" ] && ORIGIN="/origin"
[ -z "$TARGET" ] && TARGET="/target"
[ -z "$CREATE_ARGS" ] && CREATE_ARGS="--progress --stats --compression lz4"
[ -z "$LABEL" ] && LABEL="{now:%Y-%m-%dT%H-%M}"

[ -d "$ORIGIN" ] || { echo "Origin folder $ORIGIN does not exist. Is a volume mounted here?"; exit 1; }
[ -d "$TARGET" ] || { echo "Target folder $TARGET does not exist. Is a volume mounted here?"; exit 1; }

export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes

echo "Checking if borg repository exists in $TARGET, attempting to create it otherwise..."
borg list "$TARGET" &>/dev/null || {
	borg init -e none "$TARGET" || { echo "Unable to initialize borg repo in $TARGET"; exit 1; } 
}

[ -z "$SKIP_CREATE" ] && { 
	echo "Creating new archive..."
	borg create ${CREATE_ARGS} "$TARGET"::"$LABEL" "$ORIGIN" || { echo "Unable to create a new archive"; exit 1; }
}

[ ! -z "$PRUNE_ARGS" ] && { 
	echo "Pruning old archives with $PRUNE_ARGS ..." 
	borg prune ${PRUNE_ARGS} "$TARGET" || { echo "Pruning failed"; exit 1; }
}

exit 0
