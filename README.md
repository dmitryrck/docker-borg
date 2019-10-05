**WARNING**:

I stopped using this in favor of installing borg in the machine itself. _There is no technical problem with docker_.

I will stop building new versions for this docker image, but if you need let me know using Github issues or build by yourself.

# Borg using docker

## Setup

Run:

```shell
$ docker run --rm -it \
  -e BORG_PASSPHRASE \
  -v /mounted-backup-dir:/data \
  dmitryrck/borg bash
```

Before setup: Don't forget to use `/data` as your backup repository and;

To setup follow the instructions of [https://borgbackup.readthedocs.io/](https://borgbackup.readthedocs.io/).

## Backup, aka, Runner

You can use the runner from [https://borgbackup.readthedocs.io/en/stable/quickstart.html](https://borgbackup.readthedocs.io/en/stable/quickstart.html), just change the `borg` calls to:

```shell
BORG="docker run --rm \
  -e BORG_PASSPHRASE \
  -e BORG_REPO \
  -e HOME \
  -v $HOME:$HOME \
  -v /mnt/backup:/data \
  dmitryrck/borg borg"

$BORG create                      \
  --verbose                       \
  --filter AME                    \
# …
```

This is exactly what I am doing. See [runner.sh](runner.sh).
