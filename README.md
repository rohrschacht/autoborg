# autoborg
Docker image for automatically backing up a volume into a borg repo.

Docker image is published in [Docker Hub](https://hub.docker.com/r/rohrschacht/autoborg).

## Usage
Mount the volume you want to back up under `/origin` and your borg repo under `/target`.

autoborg will initialize a borg repo if `/target` is empty.

Afterwards, a new borg archive is created containing all data from `/origin`.

If `PRUNE_ARGS` is set, an additional `borg prune` will be executed with these arguments.

### Example command
```
$ docker run --rm -it -v $PWD/mydata:/origin:ro -v $PWD/autoborg-test:/target rohrschacht/autoborg
```

### Environment variables
You can control the behaviour of the script using the following environment variables:

| variable name | purpose                                                                    | default value                          |
| ------------- | -------------------------------------------------------------------------- | -------------------------------------- |
| ORIGIN        | path to the data that should be backed up                                  | `/origin`                              |
| TARGET        | path to the borg repo                                                      | `/target`                              |
| CREATE_ARGS   | arguments for `borg create`                                                | `--progress --stats --compression lz4` |
| LABEL         | label for the new archive                                                  | `{now:%Y-%m-%dT%H-%M}`                 |
| SKIP_CREATE   | controls if the creation of a new archive should be skipped (pruning only) | empty                                  |
| PRUNE_ARGS    | if set, `borg prune` will be executed with these arguments                 | empty                                  |

For additional info on available arguments for `borg create` and `borg prune`, visit the borg documentation for the [create](https://borgbackup.readthedocs.io/en/stable/usage/create.html) and [prune](https://borgbackup.readthedocs.io/en/stable/usage/prune.html) subcommands.

#### Example command for skipping creation and pruning everything older than 4 weeks
```
$ docker run --rm -it -v $PWD/subnetinfov4:/origin:ro -v $PWD/autoborg-test:/target -e SKIP_CREATE=true -e PRUNE_ARGS="--keep-within 4w" rohrschacht/autoborg
```
