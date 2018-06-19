# Borg using docker

## Setup

Run:

```terminal
$ docker run --rm -it \
  -u $(id -u) \
  -e BORG_PASSPHRASE \
  -v /mounted-backup-dir:/data \
  dmitryrck/borg bash
```

Before setup:

* Don't forget to use `/data` as your backup repository and;
* Make sure the user `id -u` has (filesystem) permission to create the repository.

To setup follow the instructions of [https://borgbackup.readthedocs.io/](https://borgbackup.readthedocs.io/).

## Backup, aka, Runner

You can use the runner from [https://borgbackup.readthedocs.io/en/stable/quickstart.html](https://borgbackup.readthedocs.io/en/stable/quickstart.html) and change the `borg` call to:

```terminal
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
